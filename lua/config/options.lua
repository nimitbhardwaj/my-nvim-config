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
