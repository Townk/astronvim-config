-- This module contains helper functions and tables related to NeoVim buffers,
-- from extracting information to helper functions used on mappings.

local mySystem = require("user.lib.system")

local M = { fileTypeLabels = {} }

local devToolVersionsCache = {}

local function getBashVersion()
  return mySystem.runCmd("bash -c 'echo -n \"${BASH_VERSION%\\(*}\"'")
end

local function getJavaVersion()
  local javaVersion = mySystem.runCmd("javac -version")
  return javaVersion and javaVersion:match("[^%s]+%s+([^%s]+)")
end

local function getLuaVersion()
  local luaVersion = mySystem.runCmd("lua -v")
  return luaVersion and luaVersion:match("[^%s]+%s[^%s]+")
end

local function getNodeJSVersion()
  local nodeVersion = mySystem.runCmd("node -v")
  return nodeVersion and nodeVersion:match("^%s*(.-)%s*$")
end

local function getPerlVersion()
  return mySystem.runCmd("perl -e 'print substr(\"$^V\", 1);'")
end

local function getPythonVersion()
  local pythonVersion
  local active_venv = require("venv-selector").get_active_venv()
  if active_venv then
    pythonVersion = mySystem.runCmd(active_venv .. "/bin/python --version")
  else
    pythonVersion = mySystem.runCmd("python --version")
  end
  return pythonVersion and pythonVersion:match("[^%s]+%s+([^%s]+)")
end

local function getRustVersion()
  local rustVersion = mySystem.runCmd("rustc -V")
  return rustVersion and rustVersion:match("[^%s]+%s+([^%s]+)")
end

local function getZshVersion()
  local zshVersion = mySystem.runCmd("zsh --version")
  return zshVersion and zshVersion:match("[^%s]+%s+([^%s]+)")
end

local function getSingletonVersion(typeName, versionGetter)
  local version = devToolVersionsCache[typeName]
  if not version then
    version = versionGetter()
    devToolVersionsCache[typeName] = version
  end
  return version
end

function M.fileTypeLabels.bash()
  local bashVersion = getSingletonVersion("bash", getBashVersion)
  return bashVersion and ("Bash-" .. bashVersion:match("^%s*(.-)%s*$")) or "Bash"
end

function M.fileTypeLabels.java()
  local javaVersion = nil -- getSingletonVersion("java", getJavaVersion)
  return javaVersion and ("Java (JDK " .. javaVersion:match("^%s*(.-)%s*$") .. ")") or "Java"
end

function M.fileTypeLabels.javascript()
  if vim.lsp.get_active_clients({ name = "tsserver" }) then
    local nodeVersion = getSingletonVersion("nodeJS", getNodeJSVersion)
    return nodeVersion and ("JavaScript (Node " .. nodeVersion .. ")") or "JavaScript"
  end
  return "JavaScript"
end

function M.fileTypeLabels.lua()
  local luaVersion = getSingletonVersion("lua", getLuaVersion)
  return luaVersion and ("Lua (" .. luaVersion .. ")") or "Lua"
end

function M.fileTypeLabels.perl()
  local perlVersion = getSingletonVersion("perl", getPerlVersion)
  return perlVersion and ("Perl-" .. perlVersion) or "Perl"
end

function M.fileTypeLabels.python()
  local active_venv = require("venv-selector").get_active_venv()
  local pythonVersion = getSingletonVersion("python", getPythonVersion)
  local pythonLabel
  if pythonVersion then
    pythonLabel = "Python-" .. pythonVersion
    if active_venv then pythonLabel = pythonLabel .. " (venv)" end
  else
    pythonLabel = "Python"
  end
  return pythonLabel
end

function M.fileTypeLabels.rust()
  local rustVersion = getSingletonVersion("rust", getRustVersion)
  return rustVersion and ("Rust-" .. rustVersion) or "Rust"
end

function M.fileTypeLabels.sh()
  local bashVersion = getSingletonVersion("bash", getBashVersion)
  return bashVersion and ("ShellScript (bash-" .. bashVersion:match("^%s*(.-)%s*$") .. ")")
    or "ShellScript"
end

function M.fileTypeLabels.typescript()
  local nodeVersion = getSingletonVersion("nodeJS", getNodeJSVersion)
  return nodeVersion and ("TypeScript (Node " .. nodeVersion .. ")") or "TypeScript"
end

function M.fileTypeLabels.zsh()
  local zshVersion = getSingletonVersion("zsh", getZshVersion)
  return zshVersion and ("Zsh-" .. zshVersion:match("^%s*(.-)%s*$")) or "Zsh"
end

function M.currentFileTypeLabel()
  local buftype = vim.bo.filetype
  local fileTypeLabelFun = M.fileTypeLabels[buftype]
  return fileTypeLabelFun and fileTypeLabelFun() or buftype:gsub("^%l", string.upper)
end

return M
