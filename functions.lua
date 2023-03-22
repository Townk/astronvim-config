local telescope = {
  core = require("telescope"),
  builtin = require("telescope.builtin"),
  themes = require("telescope.themes"),
  utils = require("telescope.utils"),
}
local astrovim = {
  buffer = require("astronvim.utils.buffer"),
  status = require("astronvim.utils.status"),
  utils = require("astronvim.utils"),
}
local gitsigns = require("gitsigns")

M = {}

-- Clean the search register to remove the current search highlight.
function M.clearSearchHighlight()
  vim.fn.setreg("/", "")
end

-- Mapping function that fuzzy-find files starting from the current buffer's
-- directory up.
function M.findInCurrentDir()
  telescope.builtin.find_files({ cwd = telescope.utils.buffer_dir() })
end

-- Find files in NeoVim config directory using Telescope
function M.findInConfigFiles()
  telescope.builtin.find_files({ cwd = "~/.config/nvim" })
end

-- Find files in NeoVim config directory using Telescope
function M.findInUserConfigFiles()
  local cwd = vim.fn.stdpath("config") .. "/.."
  local search_dirs = {}
  for _, dir in ipairs(astronvim.supported_configs) do -- search all supported config locations
    if dir == astronvim.install.home then dir = dir .. "/lua/user" end -- don't search the astronvim core files
    if vim.fn.isdirectory(dir) == 1 then table.insert(search_dirs, dir) end -- add directory to search if exists
  end
  if vim.tbl_isempty(search_dirs) then -- if no config folders found, show warning
    astrovim.utils.notify("No user configuration files found", "warn")
  else
    if #search_dirs == 1 then cwd = search_dirs[1] end -- if only one directory, focus cwd
    require("telescope.builtin").find_files({
      prompt_title = "Config Files",
      search_dirs = search_dirs,
      cwd = cwd,
    }) -- call telescope
  end
end

-- Fuzzy search in current buffer.
function M.findStringInBuffer()
  telescope.builtin.current_buffer_fuzzy_find(telescope.themes.get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end

function M.findInAllFiles()
  telescope.builtin.live_grep({
    additional_args = function(args)
      return vim.list_extend(args, { "--hidden", "--no-ignore" })
    end,
  })
end

function M.closeBufferSelection()
  astrovim.status.heirline.buffer_picker(function(bufnr)
    astrovim.buffer.close(bufnr)
  end)
end

function M.closeBufferForced()
  astrovim.buffer.close(0, true)
end

function M.viewNotifications()
  telescope.core.extensions.notify.notify()
end

function M.unstageBuffer()
  gitsigns.reset_buffer_index()
end

return M
