local utils = require("astronvim.utils")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    opts = function(_, opts)
      return utils.extend_tbl(opts, {
        add_blank_line_top = false,
        enable_git_status = false,
        event_handlers = {
          {
            event = "file_opened",
            handler = function(_)
              --auto close
              require("neo-tree").close_all()
            end,
          },
        },
      })
    end,
  },
}
