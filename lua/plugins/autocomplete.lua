return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp', -- LSP completions
            'hrsh7th/cmp-buffer',   -- Buffer completions
            'hrsh7th/cmp-path',     -- Path completions
            'hrsh7th/cmp-cmdline',  -- Command line completions
            'L3MON4D3/LuaSnip',     -- Snippet completions
            'saadparwaiz1/cmp_luasnip'
        },
        config = function()
            local cmp = require('cmp')

            local lsp_cfg = { name = 'nvim_lsp' }
            local buffer_cfg = { name = 'buffer' }
            local luasnip_cfg = { name = "luasnip" }
            local dadbod_cfg = { name = "vim-dadbod-completion" }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users
                    end,
                },
                mapping = {
                    ['<C-n>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item() -- If the completion is visible, go to the previous item
                        end
                    end, { 'i', 'c' }),
                    ['<C-p>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        end
                    end, { 'i', 'c' }),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                },
                sources = cmp.config.sources({
                    lsp_cfg,
                    buffer_cfg,
                    luasnip_cfg,
                    dadbod_cfg,
                })
            })
            cmp.setup.filetype('codecompanion', {
                sources = cmp.config.sources({
                    { name = 'codecompanion' },
                })
            })
        end
    }
}
