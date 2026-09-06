-- Floating-terminal wrapper around CLI coding agents ("harnesses").
--
-- One harness is active at a time; `:SetAIHarness omp|claude` switches, and the
-- choice is remembered per project directory across nvim restarts
-- (`:SetAIHarness reset` forgets it). The keymaps (<C-.> to toggle, <leader>o+
-- to send a file reference) always act on whichever harness is active. Each
-- harness keeps its own terminal and its own process, so switching back and
-- forth doesn't kill a running agent.
local M = {}

local Terminal = require("toggleterm.terminal").Terminal
local terminal = require("tools.terminal")

-- Per-harness config. `ref` builds the @-mention the agent understands:
--   path              -- absolute/relative file path
--   srow, scol        -- selection start (1-based; nil outside visual mode)
--   erow, ecol        -- selection end
local harnesses = {
  omp = {
    cmd = "omp",
    ref = function(path, srow, scol, erow, ecol, linewise)
      if not srow then
        return "@" .. path
      end
      -- Oh My Pi keeps pi's mention syntax: @path:Lstart-Lend, with columns
      -- when the selection is characterwise.
      if linewise then
        return string.format("@%s:L%d-L%d", path, srow, erow)
      end
      return string.format("@%s:L%dC%d-L%dC%d", path, srow, scol, erow, ecol)
    end,
  },
  claude = {
    cmd = "claude",
    ref = function(path, srow, _, erow, _, _)
      if not srow then
        return "@" .. path
      end
      -- Claude Code's own IDE integration uses @path#Lstart-end (no columns).
      if srow == erow then
        return string.format("@%s#L%d", path, srow)
      end
      return string.format("@%s#L%d-%d", path, srow, erow)
    end,
  },
}

local DEFAULT_HARNESS = "omp"

-- The choice is remembered per project directory, keyed by the cwd nvim was
-- started in, in a small JSON map under nvim's state dir. Two nvim instances in
-- different projects therefore keep different harnesses, and each remembers its
-- own across restarts.
local store_path = vim.fs.joinpath(vim.fn.stdpath("state"), "ai_harness.json")

-- Canonical key for a directory: symlinks resolved, no trailing slash — so
-- /tmp and /private/tmp (or a symlinked worktree) don't get separate entries.
local function dir_key(dir)
  local resolved = vim.uv.fs_realpath(dir) or vim.fn.fnamemodify(dir, ":p")
  return (resolved:gsub("/+$", ""))
end

-- Directory nvim was launched in. Captured once at load so a later :cd doesn't
-- silently swap the harness out from under an open agent.
local root = dir_key(vim.fn.getcwd())

local function read_store()
  if vim.fn.filereadable(store_path) == 0 then
    return {}
  end
  local ok, decoded = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(store_path), "\n"))
  end)
  if not ok or type(decoded) ~= "table" then
    return {}
  end
  return decoded
end

-- Re-read before writing so a concurrent nvim in another project doesn't get
-- its entry clobbered, and drop entries for directories that no longer exist.
local function write_store(dir, name)
  local store = read_store()
  store[dir] = name
  for key in pairs(store) do
    if vim.fn.isdirectory(key) == 0 then
      store[key] = nil
    end
  end
  local ok, err = pcall(function()
    vim.fn.mkdir(vim.fs.dirname(store_path), "p")
    vim.fn.writefile({ vim.json.encode(store) }, store_path)
  end)
  if not ok then
    vim.notify("ai: could not save harness choice: " .. tostring(err), vim.log.levels.WARN)
  end
end

local active = read_store()[root]
if not harnesses[active] then
  active = DEFAULT_HARNESS
end

-- name -> { term = <Terminal>, running = bool }. Built lazily on first toggle.
-- `running` tracks whether the process is alive (true once opened, false once
-- it exits); toggling the window off keeps the process running, so it stays
-- true while the window is merely hidden.
local sessions = {}

local function create_session(name)
  local harness = harnesses[name]
  local session = { running = false }
  session.term = Terminal:new({
    cmd = harness.cmd,
    direction = "float",
    count = terminal.get_count(),
    float_opts = {
      border = "rounded",
    },
    hidden = true,
    on_open = function(self)
      terminal.register(self)
      session.running = true
      vim.cmd("startinsert!")
    end,
    on_exit = function(self)
      terminal.unregister(self)
      session.running = false
    end,
  })
  return session
end

local function session_for(name)
  if not sessions[name] then
    sessions[name] = create_session(name)
  end
  return sessions[name]
end

function M.current()
  return active
end

function M.names()
  return vim.tbl_keys(harnesses)
end

-- Switch the active harness. If the outgoing harness' window is open, close it
-- and open the incoming one in its place (its process, if any, keeps running).
function M.set(name)
  if not harnesses[name] then
    vim.notify(
      string.format("ai: unknown harness %q (known: %s)", name, table.concat(vim.tbl_keys(harnesses), ", ")),
      vim.log.levels.ERROR
    )
    return
  end

  if name == active then
    -- Still persist: this may be the first explicit choice for a directory
    -- that was merely falling back to the default.
    write_store(root, name)
    vim.notify(string.format("ai: harness already %s (remembered for %s)", name, vim.fn.fnamemodify(root, ":~")), vim.log.levels.INFO)
    return
  end

  local previous = sessions[active]
  local was_open = previous ~= nil and previous.term:is_open()
  if was_open then
    previous.term:close()
  end

  active = name
  write_store(root, name)
  vim.notify(string.format("ai: harness set to %s for %s", name, vim.fn.fnamemodify(root, ":~")), vim.log.levels.INFO)

  if was_open then
    session_for(active).term:open()
  end
end

function M.toggle()
  session_for(active).term:toggle()
end

-- Path of the current buffer relative to the cwd (falls back to absolute
-- when the file lives outside cwd).
local function relative_path()
  local path = vim.fn.expand("%:.")
  if path == "" then
    return nil
  end
  return path
end

-- Build the harness-specific reference for the current mode/selection.
function M.build_reference()
  local path = relative_path()
  if not path then
    vim.notify("ai: current buffer has no file path", vim.log.levels.WARN)
    return nil
  end

  local mode = vim.fn.mode()
  local visual_line = mode == "V"
  local visual_char = mode == "v" or mode == "\22" -- v or <C-v> (blockwise)

  if not (visual_line or visual_char) then
    return harnesses[active].ref(path)
  end

  -- In visual mode getpos("v") is the selection anchor and getpos(".") the
  -- cursor; normalise so (srow,scol) is the start.
  local anchor = vim.fn.getpos("v")
  local cursor = vim.fn.getpos(".")
  local srow, scol = anchor[2], anchor[3]
  local erow, ecol = cursor[2], cursor[3]
  if srow > erow or (srow == erow and scol > ecol) then
    srow, erow, scol, ecol = erow, srow, ecol, scol
  end

  return harnesses[active].ref(path, srow, scol, erow, ecol, visual_line)
end

-- Type text into the agent's prompt without submitting (no trailing CR).
local function type_into_agent(session, text)
  if not session.term.job_id then
    return false
  end
  vim.fn.chansend(session.term.job_id, text)
  return true
end

-- Type the reference followed by a space. Claude closes its @-mention popup on
-- that trailing space, so nothing else is needed to dismiss it.
local function deliver(session, ref)
  type_into_agent(session, ref .. " ")
end

function M.send_reference()
  -- Read the reference while we are still in the source buffer/selection.
  local ref = M.build_reference()

  -- Leave visual mode (back to normal) now that the selection has been read.
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end

  if not ref then
    return
  end

  -- If the process isn't running, don't spawn or open anything — just tell the
  -- user to start it. Otherwise send the reference straight to the process
  -- without changing the window's open/hidden state.
  local session = sessions[active]
  if not session or not session.running then
    vim.notify(
      string.format("ai: %s not running — press <C-.> to open it first", active),
      vim.log.levels.WARN
    )
    return
  end

  deliver(session, ref)
end

-- Forget this directory's saved choice; the next nvim here falls back to the
-- default harness again.
function M.reset()
  local store = read_store()
  store[root] = nil
  pcall(function()
    vim.fn.writefile({ vim.json.encode(store) }, store_path)
  end)
  active = DEFAULT_HARNESS
  vim.notify(
    string.format("ai: cleared saved harness for %s (back to %s)", vim.fn.fnamemodify(root, ":~"), DEFAULT_HARNESS),
    vim.log.levels.INFO
  )
end

vim.api.nvim_create_user_command("SetAIHarness", function(opts)
  if opts.args == "" then
    local saved = read_store()[root]
    vim.notify(
      string.format(
        "ai: harness is %s for %s (%s)",
        active,
        vim.fn.fnamemodify(root, ":~"),
        saved and "saved" or "default, not saved yet"
      ),
      vim.log.levels.INFO
    )
    return
  end
  if opts.args == "reset" then
    M.reset()
    return
  end
  M.set(opts.args)
end, {
  nargs = "?",
  desc = "Set the AI agent harness used by <C-.> for this directory (omp|claude|reset)",
  complete = function(lead)
    local candidates = vim.tbl_keys(harnesses)
    table.insert(candidates, "reset")
    return vim.tbl_filter(function(name)
      return name:find(lead, 1, true) == 1
    end, candidates)
  end,
})

return M
