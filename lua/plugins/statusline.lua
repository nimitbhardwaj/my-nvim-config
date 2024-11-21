return {
    "nvim-lualine/lualine.nvim",
    name = "statusline",
    config = function()
        require("lualine").setup({
            options = {
                theme = "dracula",
                disabled_filetypes = { "NvimTree" },
                globalstatus = true
            }
        })
    end
}
