local telescope = {
  core = require("telescope"),
}
local astrovim = {
  buffer = require("astronvim.utils.buffer"),
  status = require("astronvim.utils.status"),
  utils = require("astronvim.utils"),
}

local M = {}

--- Lookup table with a map between `windowNavigateTo` direction and its
--- corresponding Vim cursor nabigation direction.
local windowDirectionMap = {
  left = "h",
  top = "k",
  right = "l",
  bottom = "j",
}

--- Keymap function to allow user to pick a buffer to close.
--
-- Thia function uses the Heirline picker to allow user to choose the buffer.
-- It presents a highlighted character in the tab of each buffer as options.
function M.closeBufferSelection()
  astrovim.status.heirline.buffer_picker(function(bufnr)
    astrovim.buffer.close(bufnr)
  end)
end

--- Keymap function to force the current buffer to be closed.
function M.closeBufferForced()
  astrovim.buffer.close(0, true)
end

--- Keymap function to display a list of past notifications.
--
-- This function invokes Telescope to display the notification list.
function M.viewNotifications()
  telescope.core.extensions.notify.notify()
end

--- Move cursor to the next window located on the given direction.
--
-- This function tries to move the cursor inside vim, but before doing it, it
-- tests if the cursor is already located to last possible window on the
-- given direction. If the cursor is already on the edge of NeoVim, it will
-- invoke the _kitten_ `neighboring_window.py` from the Kitty Terminal.
--
-- @param direction A string representing the direction where the cursror
--                  should move to. Valid values are: "left", "top", "right",
--                  and "bottom"
local function windowNavigateTo(direction)
  local vimDir = windowDirectionMap[direction]
  if vim.fn.winnr() == vim.fn.winnr("1" .. vimDir) then
    io.popen("kitty @ kitten plugins/pass-key/neighboring_window.py " .. direction)
  else
    vim.cmd("wincmd " .. vimDir)
  end
end

--- Wrapper function to move cursor to the window on the left.
--
-- This function simply invokes `windowNavigateTo` with the `direction`
-- parameter as `"left"`.
--
-- @see windowNavigateTo
function M.moveWindowCursorToLeft()
  windowNavigateTo("left")
end

--- Wrapper function to move cursor to the window above.
--
-- This function simply invokes `windowNavigateTo` with the `direction`
-- parameter as `"top"`.
--
-- @see windowNavigateTo
function M.moveWindowCursorToTop()
  windowNavigateTo("top")
end

--- Wrapper function to move cursor to the window on the right.
--
-- This function simply invokes `windowNavigateTo` with the `direction`
-- parameter as `"right"`.
--
-- @see windowNavigateTo
function M.moveWindowCursorToRight()
  windowNavigateTo("right")
end

--- Wrapper function to move cursor to the window bellow.
--
-- This function simply invokes `windowNavigateTo` with the `direction`
-- parameter as `"bottom"`.
--
-- @see windowNavigateTo
function M.moveWindowCursorToBottom()
  windowNavigateTo("bottom")
end

function M.toggleMiniMap()
  if astrovim.utils.is_available("codewindow.nvim") then require("codewindow").toggle_minimap() end
end

function M.openMiniMap()
  if astrovim.utils.is_available("codewindow.nvim") then
    local codewindow = require("codewindow")
    codewindow.open_minimap()
    codewindow.toggle_focus()
  end
end

function M.notify(silent, ...)
  return not silent and astrovim.utils.notify(...)
end

return M
