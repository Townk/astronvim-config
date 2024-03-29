-- customize lsp formatting options
return {
  -- control auto formatting on save
  format_on_save = {
    enabled = false, -- enable or disable format on save globally
    allow_filetypes = {}, -- enable format on save for specified filetypes only
    ignore_filetypes = {}, -- disable format on save for specified filetypes
  },
  disabled = {}, -- disable formatting capabilities for the listed language servers
  timeout_ms = 1000, -- default format timeout
  filter = function(client)
    -- only enable null-ls for javascript files
    if vim.bo.filetype == "nix" then return client.name == "null-ls" end
    -- enable all other clients
    return true
  end,
}
