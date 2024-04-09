local utils = require("astronvim.utils")

return {
  -- Restore last edited place
  {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
  },

  {
    "Civitasv/cmake-tools.nvim",
    event = "BufRead",
  },

  -- When using TreeSitter, show cursor context
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufRead",
    opts = {
      separator = "🮂",
      min_window_height = 1,
    },
  },

  -- Floating mini view of the open document [<leader>om / <leader>um]
  {
    "gorbit99/codewindow.nvim",
    event = "BufRead",
    config = function(_, opts)
      local codewindow = require("codewindow")
      codewindow.setup(opts)
    end,
    opts = function(_, opts)
      -- local codewindow = require('codewindow')
      return utils.extend_tbl(opts, {})
    end,
  },
}
