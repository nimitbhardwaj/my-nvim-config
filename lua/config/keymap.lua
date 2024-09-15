-- NvimTree
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Normal mode keybinding for <leader>e to toggle NVim
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Keybindings for navigating between windows
keymap('n', '<C-H>', '<C-W>h', { noremap = true, silent = true })
keymap('n', '<C-J>', '<C-W>j', { noremap = true, silent = true })
keymap('n', '<C-K>', '<C-W>k', { noremap = true, silent = true })
keymap('n', '<C-L>', '<C-W>l', { noremap = true, silent = true })


-- LSP
keymap('n', 'K', 'vim.lsp.buf.hover', {})
keymap('n', 'K', 'vim.lsp.buf.definition', {})
