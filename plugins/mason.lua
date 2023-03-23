-- customize mason plugins
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- Make sure no other configuration add an "ensure installed" LSP
      ensure_installed = {},
    },
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    config = function(_, opts)
      local mason_null_ls = require("mason-null-ls")
      local null_ls = require("null-ls")
      mason_null_ls.setup(opts)
      mason_null_ls.setup_handlers({
        prettierd = function()
          null_ls.register(null_ls.builtins.formatting.prettierd.with({
            extra_filetypes = { "json", "markdown", "yaml" },
          }))
        end,
      })
    end,
    opts = {
      -- Make sure no other configuration add an "ensure installed" analyzer
      ensure_installed = {},
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      -- Make sure no other configuration add an "ensure installed" dap
      ensure_installed = {},
    },
  },
}
