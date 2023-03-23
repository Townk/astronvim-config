return {
  {
    "ggandor/leap.nvim",
    keys = {
      { "<leader>sw", mode = { "n", "x", "o" }, desc = "Skip forward to" },
      { "<leader>sW", mode = { "n", "x", "o" }, desc = "Skip backward to" },
      { "<leader>so", mode = { "n" }, desc = "Skip to other window" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(false)
      vim.keymap.set({ "n", "x", "o" }, "<leader>sw", "<Plug>(leap-forward-to)")
      vim.keymap.set({ "n", "x", "o" }, "<leader>sW", "<Plug>(leap-backward-to)")
      vim.keymap.set({ "n" }, "<leader>so", "<Plug>(leap-from-window)")
    end,
    dependencies = { "tpope/vim-repeat" },
    opts = {
      safe_labels = {},
      highlight_unlabeled_phase_one_targets = true,
    },
  },
  {
    "ggandor/flit.nvim",
    keys = function()
      ---@type LazyKeys[]
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" },
    dependencies = { "ggandor/leap.nvim" },
  },
  {
    "ggandor/leap-ast.nvim",
    keys = {
      { "<leader>st", mode = { "n" }, desc = "Skip using AST to" },
    },
    config = function(_, _)
      vim.keymap.set({ "n" }, "<leader>st", require("leap-ast").leap)
    end,
    dependencies = { "ggandor/leap.nvim" },
  },
}
