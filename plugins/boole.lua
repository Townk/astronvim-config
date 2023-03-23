local utils = require("astronvim.utils")

return {
  {
    "nat-418/boole.nvim",
    event = "BufRead",
    opts = function(_, opts)
      return utils.extend_tbl(opts, {
        mappings = {
          increment = "<C-a>",
          decrement = "<C-x>",
        },
      })
    end,
  },
}
