return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    opts = function(_, opts)
      opts.add_blank_line_top = false
      opts.enable_git_status = false
      opts.event_handlers = {
        {
          event = "file_opened",
          handler = function(_)
            --auto close
            require("neo-tree").close_all()
          end,
        },
      }
    end,
  },
}
