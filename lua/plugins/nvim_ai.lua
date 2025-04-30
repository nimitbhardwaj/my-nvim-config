return {
    "magicalne/nvim.ai",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("ai").setup({
            provider = "groq",
            debug = false,
            groq = {
                endpoint = "https://api.groq.com",
                model = "llama-3.3-70b-versatile"
            }
        })
    end

}
