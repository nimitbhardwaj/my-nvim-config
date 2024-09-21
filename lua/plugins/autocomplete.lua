return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- LSP completions
      'hrsh7th/cmp-buffer',    -- Buffer completions
      'hrsh7th/cmp-path',      -- Path completions
      'hrsh7th/cmp-cmdline',   -- Command line completions
      'L3MON4D3/LuaSnip'       -- Snippet completions
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
          ['<C-Space>'] = cmp.mapping.complete(),  -- Manually trigger with Ctrl-Space
          ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()  -- If the completion is visible, go to the next item
            else
              cmp.complete()  -- If not visible, open the completion menu
            end
          end, { 'i', 'c' }),
          ['<C-p>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()  -- If the completion is visible, go to the previous item
            else
              cmp.complete()  -- If not visible, open the completion menu
            end
          end, { 'i', 'c' }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),  -- Confirm and select the current item
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },  -- LSP completions
          { name = 'buffer' },    -- Buffer completions
        })
      })
    end
  }
}

