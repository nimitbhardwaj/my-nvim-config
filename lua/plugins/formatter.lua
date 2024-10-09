return {
    "stevearc/conform.nvim",
    event = {
        "BufReadPre",
        "BufNewFile",
    },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                python = { "black" },
            },
            format_after_save = {
                lsp_fallback = true,
                timeout_ms = 500
            }
        })
    end
}
