local utils = require("astronvim.utils")

return {
  "sindrets/diffview.nvim",
  event = "User AstroGitFile",
  opts = function(_, opts)
    return utils.extend_tbl(opts, {
      keymaps = {
        view = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
      },
    })
  end,
}
