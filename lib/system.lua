local astroUtils = require("astronvim.utils")

local M = {}

--- Helper function that runs a shell command, and returns its output.
--
-- If an error occur while executing the given command, this function will
-- return `null`.
--
-- @param cmd A string containing the command line to run.
function M.runCmd(cmd) --> String,null
  local handle, err = io.popen(cmd)
  local result = handle and handle:read("*a"):gsub("[\n\r]", " ")

  if not handle then
    astroUtils.notify("Error runnint command '" .. cmd .. "'\n" .. err, "error")
  else
    handle:close()
  end

  return result
end

return M
