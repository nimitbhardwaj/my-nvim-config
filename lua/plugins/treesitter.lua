return {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = { 'lua', 'typescript',
                'javascript', 'html', 'css', 'json', 'yaml', 'tsx',
                'python', 'java'
            },
            highlight = {
                enable = true,
            },
        }
    end,
}
