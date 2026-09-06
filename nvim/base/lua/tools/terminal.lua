local M = {}

M.terminals = {}
M.next_id = 1000

function M.get_count()
  local id = M.next_id
  M.next_id = M.next_id + 1
  return id
end

-- The TUIs we host in these floats (omp, posting, lazydocker) turn on
-- any-motion mouse tracking (DECSET 1003) for hover. nvim only asks the host
-- terminal for bare motion when 'mousemoveevent' is on — without it you get
-- clicks, wheel and drags but no hover. Keep it on only while a registered
-- terminal is focused; globally, motion events abort pending mappings
-- (:h 'mousemoveevent').
vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave" }, {
  callback = function(ev)
    vim.o.mousemoveevent = ev.event == "BufEnter" and M.terminals[ev.buf] ~= nil
  end,
})

-- SGR mouse reports keyed by the terminal-mode key nvim delivers, as
-- { button code, "M" press / "m" release }. Buttons are left/middle/right
-- 0/1/2 and back/forward 128/129, wheel is 64-67, motion adds 32 (35 is
-- motion with no button held), and modifiers add shift 4, alt 8, ctrl 16.
--
-- Every variant nvim can deliver has to be in here: a drag while holding the
-- button arrives as <LeftDrag>, a fast second click as <2-LeftMouse> and then
-- <2-LeftDrag>/<2-LeftRelease>, and anything we leave unmapped falls through
-- to nvim, which is exactly what drops us back into normal mode.
local mouse_reports = {}
for modifier, mod_code in pairs({ [""] = 0, ["S-"] = 4, ["M-"] = 8, ["C-"] = 16 }) do
  for wheel, code in pairs({
    ScrollWheelUp = 64,
    ScrollWheelDown = 65,
    ScrollWheelLeft = 66,
    ScrollWheelRight = 67,
  }) do
    mouse_reports["<" .. modifier .. wheel .. ">"] = { code + mod_code, "M" }
  end
  mouse_reports["<" .. modifier .. "MouseMove>"] = { 35 + mod_code, "M" }

  for button, code in pairs({ Left = 0, Middle = 1, Right = 2, X1 = 128, X2 = 129 }) do
    for _, click in ipairs({ "", "2-", "3-", "4-" }) do
      local prefix = "<" .. modifier .. click .. button
      mouse_reports[prefix .. "Mouse>"] = { code + mod_code, "M" }
      mouse_reports[prefix .. "Drag>"] = { code + mod_code + 32, "M" }
      mouse_reports[prefix .. "Release>"] = { code + mod_code, "m" }
    end
  end
end

-- Own the mouse inside these floats. The TUIs we host only turn mouse tracking
-- on for their fullscreen overlays (omp's pickers, for one); in the normal
-- inline view it is off, and nvim then handles the click itself — which is why
-- every click and scroll used to kick you from terminal mode into normal mode.
-- So consume the event and write the SGR report to the job ourselves: the TUI
-- acts on it when it asked for tracking and ignores it when it did not (checked
-- against omp), and either way terminal mode survives. Read the scrollback with
-- <C-\><C-n> as before.
local function own_mouse(term)
  for key, report in pairs(mouse_reports) do
    vim.keymap.set("t", key, function()
      local pos = vim.fn.getmousepos()
      if term.job_id and pos.winid == term.window then
        vim.api.nvim_chan_send(
          term.job_id,
          string.format("\27[<%d;%d;%d%s", report[1], pos.wincol, pos.winrow, report[2])
        )
      end
    end, { buffer = term.bufnr, desc = "forward mouse to the TUI" })
  end
end

function M.register(term)
  M.terminals[term.bufnr] = term
  -- register() runs from on_open, i.e. after the float's BufEnter has already
  -- fired for a buffer we did not know about yet.
  vim.o.mousemoveevent = true
  own_mouse(term)
end

function M.unregister(term)
  M.terminals[term.bufnr] = nil
end

function M.toggle_current()
  if vim.bo.buftype ~= "terminal" then
    vim.cmd("ToggleTerm")
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local term = M.terminals[bufnr]

  if term then
    term:toggle()
    return
  else
    vim.cmd("ToggleTerm")
  end
end

function M.toggle_with_count(count)
  if count == 0 then
    if vim.bo.buftype == "terminal" then
      M.toggle_current()
      return
    end
    count = 1
  end
  vim.cmd("exe " .. count .. " . 'ToggleTerm name=Terminal" .. count .. "'")
end

return M
