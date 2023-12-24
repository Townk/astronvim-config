-- This module hosts all helper functions used to perform different searches
-- in my system.

local telescope = {
  builtin = require("telescope.builtin"),
  themes = require("telescope.themes"),
  utils = require("telescope.utils"),
}
local astrovim = {
  utils = require("astronvim.utils"),
}

local M = {}

--- Keymap function to find a file in current buffer's directory recursively.
--
-- This function invokes Telescope to perform the file search. Notice that
-- this searcn only consider file names.
function M.findInCurrentDir()
  telescope.builtin.find_files({ cwd = telescope.utils.buffer_dir() })
end

--- Keymap function to find a file inside NeoVim's configuration directory.
--
-- This function invokes Telescope to perform the file search. Notice that
-- this searcn only consider file names.
function M.findInConfigFiles()
  telescope.builtin.find_files({ cwd = "~/.config/nvim" })
end

--- Keymap function to find a file inside AstroVim user's configuration.
--
-- This function invokes Telescope to perform the file search. Notice that
-- this searcn only consider file names.
function M.findInUserConfigFiles()
  local cwd = vim.fn.stdpath("config") .. "/.."
  local search_dirs = {}
  for _, dir in ipairs(astronvim.supported_configs) do                      -- search all supported config locations
    if dir == astronvim.install.home then dir = dir .. "/lua/user" end      -- don't search the astronvim core files
    if vim.fn.isdirectory(dir) == 1 then table.insert(search_dirs, dir) end -- add directory to search if exists
  end
  if vim.tbl_isempty(search_dirs) then                                      -- if no config folders found, show warning
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

--- Keymap function to fuzzy find a string in the current buffer.
--
-- This function invokes Telescope to perform the string search.
function M.findStringInBuffer()
  telescope.builtin.current_buffer_fuzzy_find(telescope.themes.get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end

--- Keymap function find a string in all files in CWD recursively.
--
-- This function invokes Telescope to perform the string search.
function M.findInAllFiles()
  telescope.builtin.live_grep({
    additional_args = function(args)
      return vim.list_extend(args, { "--hidden", "--no-ignore" })
    end,
  })
end

return M
