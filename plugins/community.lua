local utils = require("astronvim.utils")

return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",

  { import = "astrocommunity.pack.bash" },

  { import = "astrocommunity.pack.cpp" },

  { import = "astrocommunity.pack.cmake" },

  { import = "astrocommunity.pack.java" },

  { import = "astrocommunity.pack.json" },

  { import = "astrocommunity.pack.kotlin" },

  { import = "astrocommunity.pack.lua" },

  { import = "astrocommunity.pack.markdown" },

  { import = "astrocommunity.pack.nix" },

  { import = "astrocommunity.pack.python" },

  { import = "astrocommunity.pack.rust" },

  { import = "astrocommunity.pack.toml" },

  { import = "astrocommunity.pack.typescript" },

  { import = "astrocommunity.pack.yaml" },

  -- Rename symbols with visual updates
  { import = "astrocommunity.lsp.inc-rename-nvim" },
  {
    "smjonas/inc-rename.nvim",
    opts = function(_, opts)
      return utils.extend_tbl(opts, {
        input_buffer_type = "dressing",
      })
    end,
  },

  -- Project Runner
  { import = "astrocommunity.code-runner.overseer-nvim" },
  {
    "stevearc/overseer.nvim",
    opts = function(_, opts)
      return utils.extend_tbl(opts, {
        templates = { "builtin", "poethepoet" },
      })
    end,
  },

  -- Make tabs have their own set of buffers
  { import = "astrocommunity.bars-and-lines.scope-nvim" },

  { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },

  { import = "astrocommunity.editing-support.auto-save-nvim" },

  { import = "astrocommunity.editing-support.refactoring-nvim" },

  { import = "astrocommunity.editing-support.telescope-undo-nvim" },

  { import = "astrocommunity.editing-support.treesj" },

  { import = "astrocommunity.editing-support.dial-nvim" },

  { import = "astrocommunity.editing-support.vim-move" },

  { import = "astrocommunity.editing-support.ultimate-autopair-nvim" },

  -- Jump around the buffer
  { import = "astrocommunity.motion.leap-nvim" },
  {
    "ggandor/leap.nvim",
    keys = {
      { "<leader>sw", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "<leader>sW", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "<leader>st", mode = { "x", "o" },      desc = "Leap forward till" },
      { "<leader>sT", mode = { "x", "o" },      desc = "Leap backward till" },
      { "<leader>so", mode = { "n" },           desc = "Leap from window" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(false)
      vim.keymap.set({ "n", "x", "o" }, "<leader>sw", "<Plug>(leap-forward-to)")
      vim.keymap.set({ "n", "x", "o" }, "<leader>sW", "<Plug>(leap-backward-to)")
      vim.keymap.set({ "x", "o" }, "<leader>st", "<Plug>(leap-forward-till)")
      vim.keymap.set({ "x", "o" }, "<leader>sT", "<Plug>(leap-backward-till)")
      vim.keymap.set({ "n" }, "<leader>so", "<Plug>(leap-from-window)")
    end,
    opts = {
      safe_labels = {},
      highlight_unlabeled_phase_one_targets = true,
    },
  },
  {
    "ggandor/leap-ast.nvim",
    keys = {
      { "<leader>sa", mode = { "n" }, desc = "Leap using AST to" },
    },
    config = function(_, _)
      vim.keymap.set({ "n" }, "<leader>sa", require("leap-ast").leap)
    end,
    dependencies = { "ggandor/leap.nvim" },
  },
  { import = "astrocommunity.motion.flit-nvim" },

  { import = "astrocommunity.motion.vim-matchup" },

  -- Surrounding characters
  { import = "astrocommunity.motion.nvim-surround" },
  {
    "kylechui/nvim-surround",
    opts = function(_, opts)
      return utils.extend_tbl(opts, {
        keymaps = {
          normal = "sa",
          normal_cur = "sv",
          normal_line = "ss",
          normal_curl_line = "sS",
          visual = "s",
          delete = "sd",
          change = "sr",
        },
        aliases = {
          ["b"] = "]",
          ["c"] = "}",
          ["a"] = ">",
          ["p"] = ")",
          ["q"] = "'",
          ["d"] = '"',
          ["u"] = { "}", "]", ")", ">", '"', "'", "`" },
        },
      })
    end,
  },

  { import = "astrocommunity.diagnostics.trouble-nvim" },

  { import = "astrocommunity.git.diffview-nvim" },
  {
    "sindrets/diffview.nvim",
    opts = function(_, opts)
      return utils.extend_tbl(opts, {
        keymaps = {
          view = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          },
          panel = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          },
          merge_tool = {
            { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          },
        },
      })
    end,
  },

  { import = "astrocommunity.git.neogit" },

  { import = "astrocommunity.search.nvim-hlslens" },

  { import = "astrocommunity.syntax.vim-easy-align" },
}
