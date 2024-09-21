return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- LSP completions
      'hrsh7th/cmp-buffer',    -- Buffer completions
      'hrsh7th/cmp-path',      -- Path completions
      'hrsh7th/cmp-cmdline',   -- Command line completions
      'L3MON4D3/LuaSnip',       -- Snippet completions
      'saadparwaiz1/cmp_luasnip'
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        completion={
          autocomplete=false
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users
          end,
        },
        mapping = {
          -- Trigger completion manually and also use C-N and C-P for navigation and trigger
          ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()  -- If the completion is visible, go to the previous item
            else
              cmp.complete({
                config={sources={{name='buffer'}, {name='nvim_lsp'}}}
              })
            end
          end, { 'i', 'c' }),
          ['<C-p>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()  -- If the completion is visible, go to the previous item
            else
              cmp.complete({
                config={sources={{name='buffer'}, {name='nvim_lsp'}}}
              })
            end
          end, { 'i', 'c' }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Confirm and select the current item
          ['<C-k>'] = cmp.mapping(function(fallback)
            cmp.complete({ config = { sources = { { name = 'luasnip' } } } })  -- Show only snippets
          end, {'i', 'c'}),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },  -- LSP completions
          { name = 'buffer' },    -- Buffer completions
          { name = 'luasnip' },    -- Buffer completions
        })
      })
    end
  }
}

