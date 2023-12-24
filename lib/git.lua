----------
-- This module contains utilities to interact with Git.
--
-- @module user.lib.git

local gitsigns = require("gitsigns")

local M = {}

----------
-- Keymap function to unstage the entire buffer from Git.
--
-- This function uses GitSign to perform the unstage, which calls `git reset`
-- on the buffer.
function M.unstageBuffer()
  gitsigns.reset_buffer_index()
end

return M

