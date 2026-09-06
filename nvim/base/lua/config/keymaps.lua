-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local posting = require("tools.posting")
local terminal = require("tools.terminal")
local ralph = require("tools.ralph")
local ai = require("tools.ai")
local lazydocker = require("tools.lazydocker")

vim.keymap.set("n", "<leader>tp", posting.toggle, { desc = "Posting TUI" })
vim.keymap.set("n", "<leader>td", lazydocker.toggle, { desc = "Lazydocker TUI" })
vim.keymap.set("n", "<leader>tr", ralph.toggle, { desc = "Ralph TUI" })
vim.keymap.set({ "n", "t" }, "<C-.>", ai.toggle, { desc = "AI agent (toggle) — :SetAIHarness omp|claude" })
vim.keymap.set({ "n", "x" }, "<leader>o+", ai.send_reference, { desc = "Send file reference to AI agent" })
vim.keymap.set({ "n", "t" }, "<C-/>", function()
  terminal.toggle_with_count(vim.v.count)
end, {
  desc = "Toggle terminal (smart)",
})
