-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set the <Leader> key
vim.g.mapleader = "," -- Use comma as the leader key for custom mappings

-- Wrap text

-- Text Wrapping Options
vim.wo.wrap = true -- Visually wrap long lines
vim.wo.linebreak = true -- Wrap lines at word boundaries only
vim.wo.breakindent = true -- Preserve indentation on wrapped lines

-- Disable auto change directory
vim.o.autochdir = false

-- A TUI in a terminal float (claude, omp) copies through OSC 52, and nvim hands
-- the decoded text to the clipboard provider as ONE register line with embedded
-- newlines. When the provider is an external command, nvim writes those newlines
-- as NUL (inside a line, NL is nvim's stand-in for NUL) — so a multi-line copy
-- pastes back as ^@ everywhere. A Lua copy function gets the raw string instead,
-- so run the clipboard tool ourselves. Same tools nvim would have picked;
-- linewise yanks keep their trailing newline.
local tools = {
  { "mac", { "pbcopy" }, { "pbpaste" } },
  { "WAYLAND_DISPLAY", { "wl-copy" }, { "wl-paste", "--no-newline" } },
  { "DISPLAY", { "xclip", "-quiet", "-i", "-selection", "clipboard" }, { "xclip", "-o", "-selection", "clipboard" } },
  { "DISPLAY", { "xsel", "-i", "-b" }, { "xsel", "-o", "-b" } },
}
for _, tool in ipairs(tools) do
  local where, copy_cmd, paste_cmd = tool[1], tool[2], tool[3]
  local usable = where == "mac" and vim.fn.has("mac") == 1 or vim.env[where] ~= nil
  if usable and vim.fn.executable(copy_cmd[1]) == 1 then
    local function copy(lines, regtype)
      local text = table.concat(lines, "\n") .. (regtype == "V" and "\n" or "")
      vim.system(copy_cmd, { stdin = text }):wait()
    end
    vim.g.clipboard = {
      name = copy_cmd[1] .. " (NUL-safe)",
      copy = { ["+"] = copy, ["*"] = copy },
      paste = { ["+"] = paste_cmd, ["*"] = paste_cmd },
    }
    break
  end
end
