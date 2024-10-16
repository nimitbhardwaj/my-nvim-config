-- Imports
local ls = require("luasnip")
local builtin = require('telescope.builtin')
-- NvimTree
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Normal mode keybinding for <leader>e to toggle NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Keybindings for navigating between windows
keymap('n', '<C-H>', '<C-W>h', opts)
keymap('n', '<C-J>', '<C-W>j', opts)
keymap('n', '<C-K>', '<C-W>k', opts)
keymap('n', '<C-L>', '<C-W>l', opts)

-- LuaSnip keybindings
keymap({ "i", "s" }, "<C-L>", function() ls.jump(1) end, opts)
keymap({ "i", "s" }, "<C-H>", function() ls.jump(-1) end, opts)

-- Buffer Delete Key Binds
keymap('n', '<leader>bd', ':Bdelete<CR>', opts)
keymap('n', '<leader>bw', ':Bwipeout<CR>', opts)

-- LSP Config Settings

-- Hover
keymap('n', 'K', function() vim.lsp.buf.hover() end, opts)

-- Go to definition
keymap('n', 'gd', function() vim.lsp.buf.definition() end, opts)

-- Code action
keymap('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)


-- Telescope keybindings
keymap('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files', noremap = true, silent = true })
keymap('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep', noremap = true, silent = true })
keymap('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers', noremap = true, silent = true })
keymap('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags', noremap = true, silent = true })
