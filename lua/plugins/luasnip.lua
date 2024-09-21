return {
    "L3MON4D3/LuaSnip",
    dependencies={
        "rafamadriz/friendly-snippets",
    },
    version="v2.*",
    event="VeryLazy",
    run="make install_jsregexp",
    config=function()
        require('luasnip').setup({})
        require("luasnip.loaders.from_vscode").lazy_load()
        vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
        vim.keymap.set({"i", "s"}, "<C-H>", function() ls.jump(-1) end, {silent = true})

        vim.keymap.set({"i", "s"}, "<C-E>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, {silent = true})
        require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets/" })
    end
}
