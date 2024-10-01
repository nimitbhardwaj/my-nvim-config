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
        require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets/" })
    end
}
