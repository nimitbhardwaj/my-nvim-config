return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config=function()
        require("telescope").setup({
            defaults = {
              vimgrep_arguments = {
                'rg',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
                '--highlight'
              },
              -- Highlight matched terms
              grep_highlight = true,
              -- Other Telescope configurations...
            }
        })
    end
}
