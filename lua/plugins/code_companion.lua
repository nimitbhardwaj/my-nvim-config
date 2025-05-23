return {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("codecompanion").setup({
            strategies = {
                chat = {
                    adapter = "groq",
                },
                inline = {
                    adapter = "groq",
                },
                cmd = {
                    adapter = "groq",
                },
            },
            display = {
                chat = {
                    window = {
                        position = "right"
                    }
                }
            },
            adapters = {
                groq = function()
                    return require("codecompanion.adapters").extend("openai_compatible", {
                        env = {
                            url = "https://api.groq.com/openai",
                            api_key = "GROQ_API_KEY",
                            chat_url = "/v1/chat/completions", -- optional: default value, override if different
                            models_endpoint = "/v1/models",    -- optional: attaches to the end of the URL to form the endpoint to retrieve models
                        },
                        schema = {
                            model = {
                                default = "llama-3.3-70b-versatile", -- define llm model to be used
                            },
                        },
                    })
                end,
            },
        })
    end
}
