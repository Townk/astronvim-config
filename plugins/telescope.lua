local utils = require("astronvim.utils")
local telescope = {
  core = require("telescope"),
  themes = require("telescope.themes"),
  action = require("telescope.actions"),
  actionlayout = require("telescope.actions.layout"),
}

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-symbols.nvim", -- optional, select symbols
      "nvim-telescope/telescope-ui-select.nvim", -- optional, for using telescope in more places
      "nvim-tree/nvim-web-devicons", -- optional, for icons
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    opts = function(_, opts)
      return utils.extend_tbl(opts, {
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case", -- this is default
          },
          ["ui-select"] = {
            telescope.themes.get_cursor(),
          },
        },
        defaults = {
          prompt_prefix = "    ",
          selection_caret = "  ",
          entry_prefix = "   ",
          multi_icon = " ",
          sorting_strategy = "ascending",
          results_title = "",
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--trim",
          },
          color_devicons = true,
          layout_strategy = "horizontal",
          winblend = 5,
          layout_config = {
            prompt_position = "top",
            horizontal = {
              width = 0.75,
              height = 0.85,
              width_padding = 0.04,
              height_padding = 0.1,
              preview_width = 0.6,
            },
            vertical = {
              width_padding = 0.05,
              height_padding = 1,
              preview_height = 0.5,
            },
          },
          mappings = {
            i = {
              ["<C-u>"] = telescope.action.preview_scrolling_up,
              ["<C-d>"] = telescope.action.preview_scrolling_down,
              ["<C-j>"] = telescope.action.move_selection_next,
              ["<C-k>"] = telescope.action.move_selection_previous,
              ["<C-Space>"] = telescope.actionlayout.toggle_preview,
              ["<esc>"] = telescope.action.close,
              ["<C-x>"] = telescope.action.cycle_previewers_next,
              ["<C-a>"] = telescope.action.cycle_previewers_prev,
            },
          },
        },
      })
    end,
    config = function(...)
      require("plugins.configs.telescope")(...)
      telescope.core.load_extension("undo")
      telescope.core.load_extension("file_browser")
      telescope.core.load_extension("fzf")
      telescope.core.load_extension("frecency")
      telescope.core.load_extension("ui-select")
      -- telescope.core.load_extension("textcase")
      -- telescope.core.load_extension("notify")
    end,
  },
  {
    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
    cond = vim.fn.executable("make") == 1,
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    -- Order fuzzy list by frequency
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
    },
  },
}
