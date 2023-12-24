-- Use relative line numbers in all modes except insert.
local ui_updates_group = vim.api.nvim_create_augroup("MyUiUpdates", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
  group = ui_updates_group,
  pattern = "*",
  callback = function(_)
    if vim.o.number then vim.o.relativenumber = false end
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = ui_updates_group,
  pattern = "*",
  callback = function(_)
    if vim.o.number then vim.o.relativenumber = true end
  end,
})

local dev_setup_group = vim.api.nvim_create_augroup("MyDevSetup", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  group = dev_setup_group,
  desc = "Auto select virtualenv (if available), when Nvim open",
  pattern = "*",
  callback = function()
    local venv_selector = require("venv-selector")
    local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
    if venv ~= "" then
      venv_selector.retrieve_from_cache()
      if not venv_selector.get_active_venv() then
        local venv_path = vim.fn.finddir(".venv", vim.fn.getcwd() .. ";")
        if venv_path then
          local selected_venv = {
            value = vim.fn.getcwd() .. "/" .. venv_path,
          }
          local venv_lib = require("venv-selector.venv")
          venv_lib.set_venv_and_system_paths(selected_venv)
          if venv_selector.get_active_venv() then venv_lib.cache_venv(selected_venv) end
        end
      end
    end
  end,
  once = true,
})
