return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config=function()
      local harpoon = require("harpoon");
      harpoon.setup({});
      -- basic telescope configuration
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
          local function make_finder()
              local paths = {}
              for _, item in ipairs(harpoon_files.items) do
                table.insert(paths, item.value)
              end

              return require("telescope.finders").new_table(
                {
                  results = paths
                }
              )
          end

          require("telescope.pickers").new({}, {
              prompt_title = "Harpoon",
              finder = make_finder(),
              previewer = conf.file_previewer({}),
              sorter = conf.generic_sorter({}),
          }):find()
        end
        vim.keymap.set("n", "<leader>ha",
            function()
                harpoon:list():add()
                print("Added to Harpoon " .. vim.fn.expand("%:p"))
            end)
        vim.keymap.set("n", "<leader>hc",
            function()
                harpoon:list():clear()
                print("Cleared Harpoon")
            end)
        vim.keymap.set("n", "<leader>hl", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
        vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end)
    end
}
