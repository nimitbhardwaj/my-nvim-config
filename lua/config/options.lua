-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = ","

-- Wrap text
vim.wo.wrap = true -- Enable line wrapping
vim.wo.linebreak = true -- Wrap only at word boundaries
vim.wo.breakindent = true -- Preserve indentation on wrapped lines
