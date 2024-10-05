function RemoveEntityFromTelescope(item)
  local opts = { noremap = true, silent = true }
  local harpoon = require("harpoon")
  local list = harpoon:list()
  item = item or list.config.create_list_item(list.config)
  local Extensions = require("harpoon.extensions")
  local Logger = require("harpoon.logger")

  local items = list.items
  if item ~= nil then
    for i = 1, list._length do
      local v = items[i]
      if list.config.equals(v, item) then
        table.remove(items, i)
        list._length = list._length - 1

        Logger:log("HarpoonList:remove", { item = item, index = i })

        Extensions.extensions:emit(
          Extensions.event_names.REMOVE,
          { list = list, item = item, idx = i }
        )
        break
      end
    end
  end
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("harpoon"):setup()
  end,
  keys = function()
    local harpoon = require("harpoon")

    local conf = require("telescope.config").values

    local function toggle_telescope(harpoon_files)
      local file_paths = {}

      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      local make_finder = function()
        local paths = {}

        for _, item in ipairs(harpoon_files.items) do
          table.insert(paths, item.value)
        end

        return require("telescope.finders").new_table({
          results = paths,
        })
      end

      require("telescope.pickers")
        .new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = false,
          sorter = conf.generic_sorter({}),
          layout_strategy = "center",
          layout_config = {
            preview_cutoff = 1, -- Preview should always show (unless previewer = false)

            width = function(_, max_columns, _)
              return math.min(max_columns, 80)
            end,

            height = function(_, _, max_lines)
              return math.min(max_lines, 15)
            end,
          },
          borderchars = {
            prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
            preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          },
          attach_mappings = function(prompt_buffer_number, map)
            map("i", "<c-d>", function()
              local state = require("telescope.actions.state")
              local selected_entry = state.get_selected_entry()
              local current_picker = state.get_current_picker(prompt_buffer_number)

              RemoveEntityFromTelescope(selected_entry)
              current_picker:refresh(make_finder())
            end)

            return true
          end,
        })
        :find()
    end

    return {
      {
        "<leader>hl",
        function()
          toggle_telescope(harpoon:list())
        end,
        desc = "Harpoon (Telescope)",
      },
      {
        "<leader>ha",
        function()
          harpoon:list():add()
        end,
        desc = "Harpoon: Add",
      },

      {
        "<leader>h1",
        function()
          harpoon:list():select(1)
        end,
      },

      {
        "<leader>h2",
        function()
          harpoon:list():select(2)
        end,
      },

      {
        "<leader>h3",
        function()
          harpoon:list():select(3)
        end,
      },

      -- Toggle previous & next buffers stored within Harpoon list
      {
        "<leader>hp",
        function()
          harpoon:list():prev()
        end,
        desc = "Harpoon: Previous",
      },

      {
        "<leader>hn",
        function()
          harpoon:list():next()
        end,
        desc = "Harpoon: Next",
      },
      {
          "<leader>hc",
          function()
            harpoon:list():clear()
          end,
          desc = "Harpoon: Clear",
      }
    }
  end,
}
