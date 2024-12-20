return {
    "mfussenegger/nvim-lint",
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    config = function()
        require("lint").linters_by_ft = {
            python = { "ruff" },
        };
        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave", "TextChanged" }, {
            group = lint_augroup,
            callback = function()
                require("lint").try_lint()
            end,
        })
    end
}
