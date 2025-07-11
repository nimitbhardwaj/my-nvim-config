return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
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
          position = "right",
        },
      },
    },
    adapters = {
      groq = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          env = {
            url = "https://api.groq.com/openai",
            api_key = "GROQ_API_KEY",
            chat_url = "/v1/chat/completions", -- optional: default value, override if different
            models_endpoint = "/v1/models", -- optional: attaches to the end of the URL to form the endpoint to retrieve models
          },
          schema = {
            model = {
              default = "llama-3.3-70b-versatile", -- define llm model to be used
            },
          },
        })
      end,
    },
  },
  keys = {
    { "<Leader>a", desc = "AI Power", mode = { "n", "v" } },
    { "<Leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion Actions", mode = { "n", "v" } },
    { "<Leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompanion Chat Toggle", mode = { "n", "v" } },
    { "<Leader>as", "<cmd>CodeCompanionChat Add<cr>", desc = "CodeCompanion Chat Add", mode = "v" },
  },
}
