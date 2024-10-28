return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({})
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "pyright", "clangd", "ts_ls", "tailwindcss", "eslint", "jdtls", "omnisharp" }
            })
        end
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "ruff",
                    "prettierd",
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig");
            local lsp_configuration = {};
            lspconfig.lua_ls.setup(lsp_configuration)
            lspconfig.pyright.setup(lsp_configuration)
            lspconfig.clangd.setup(lsp_configuration)
            lspconfig.ts_ls.setup(lsp_configuration)
            lspconfig.tailwindcss.setup(lsp_configuration)
            lspconfig.eslint.setup(lsp_configuration)
            lspconfig.jdtls.setup(lsp_configuration)
            lspconfig.omnisharp.setup(lsp_configuration)
        end
    },
}
