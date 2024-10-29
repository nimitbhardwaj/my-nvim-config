return {
    {
        "github/copilot.vim"
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        config = function()
            require("CopilotChat").setup({
                debug = true
            });
        end
    }
}
