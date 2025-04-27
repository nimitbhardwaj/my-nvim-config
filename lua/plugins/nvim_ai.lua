return {
    "magicalne/nvim.ai",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("ai").setup({
            provider = "ollama",
            ollama = {
            }

        })
    end

}
