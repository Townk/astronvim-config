-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Use this file to map any key that should work only when there is an LSP
-- connected to the buffer.

local myLib = {
  ui = require("user.lib.ui"),
}
local is_available = require("astronvim.utils").is_available

return function(maps)
  -- LSP mappings that should be available regardless the features or
  -- the servers
  local to_disable = {
    n = {
      ["gY"] = false,
    },
  }
  maps = vim.tbl_deep_extend("force", maps, to_disable)
  maps.n["<A-CR>"] = {
    vim.lsp.buf.code_action,
    desc = "Open code-action window",
  }
  local diagnostics_active = true
  maps.n["<leader>lt"] = {
    function(silent)
      diagnostics_active = not diagnostics_active
      if diagnostics_active then
        vim.diagnostic.show()
        myLib.ui.notify(silent, "diagnostics on")
      else
        vim.diagnostic.hide()
        myLib.ui.notify(silent, "diagnostics off")
      end
    end,
    desc = "Toggle diagnostics",
  }
  maps.n["<leader>lr"] = {
    function()
        require "inc_rename"
        return ":IncRename " .. vim.fn.expand "<cword>"
    end,
    expr = true,
    desc = "Rename current symbol <LSP>",
  }

  -- Mappings that should be available only if I have Trouble plugin installed
  if is_available("trouble.nvim") then
    local trouble_map = {
      n = {
        -- Like find usages on IntelliJ
        ["gr"] = {
          function()
            require("trouble").open("lsp_references")
          end,
          desc = "List references",
        },
        -- Populate the trouble buffer with all implementations of a symbol
        ["gI"] = {
          function()
            require("trouble").open("lsp_implementations")
          end,
          desc = "List implementations",
        },
      },
    }
    maps = vim.tbl_deep_extend("force", maps, trouble_map)
  end

  -- Mappings specific for the `clangd` LSP
  if is_available("clangd_extensions.nvim") then
    -- If the command `ClangdSwitchSourceHeader` is available, make a
    -- buffer mapping
    if vim.fn.exists(":ClangdSwitchSourceHeader") > 0 then
      local clangd_cmd_map = {
        n = {
          ["<leader>ba"] = {
            function()
              vim.cmd("ClangdSwitchSourceHeader")
            end,
            desc = "Switch to alternate buffer",
          },
        },
      }
      maps = vim.tbl_deep_extend("force", maps, clangd_cmd_map)
    end
  end
  return maps
end
