local astroUtils = require("astronvim.utils")
local astroStatus = require("astronvim.utils.status")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local myBuffers = require("user.lib.buffers")
local mySystem = require("user.lib.system")

local M = { segments = {}, utils = {}, conditions = {} }

M.colors = {
  statusbar_bg = "#181a1f",
  text = "#abb2bf",
  file_path_secondary = "#5B6268",
  file_path_important = "#98c379",
  file_path_basename = "#ffffff",
  blue = "#64bef0",
  bright_blue = "#a2d4f6",
  cyan = "#56b6c2",
  green = "#98c379",
  red = "#e06c75",
  yellow = "#e5c07b",
  dark_grey = "#5B6268",
  orange = "#ff9640",
  purple = "#c678dd",
  bright_purple = "#a9a1e1",
  vibrant_red = "#fc6c6e",
  white = "#ffffff",
}

local ignoredFiletypes = {
  "help",
  "TelescopePrompt",
}

function M.conditions.filetypeIgnored()
  return vim.tbl_contains(ignoredFiletypes, vim.bo.filetype)
end

function M.conditions.filetypeNotIgnored()
  return not M.conditions.filetypeIgnored()
end

M.segments.Spacer = {
  provider = "%=",
}

M.segments.DoomDecoration = {
  hl = { fg = M.colors.blue, bg = M.colors.statusbar_bg },
  { provider = "▌ " },
  {
    condition = function()
      return (vim.fn.winnr("$") > 1) and (vim.api.nvim_win_get_number(0) ~= nil)
    end,
    provider = function(_)
      return vim.api.nvim_win_get_number(0) .. " "
    end,
  },
  { provider = " " },
}

M.segments.ModeIndicator = {
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
  end,
  static = {
    mode_colors = {
      n = M.colors.green, -- normal
      i = M.colors.bright_blue, -- insert
      v = M.colors.yellow, -- visual
      V = M.colors.yellow, -- visual line
      ["\22"] = M.colors.yellow, -- visual block
      c = M.colors.dark_grey, -- command
      s = M.colors.orange, -- selection
      S = M.colors.orange, -- selection line
      ["\19"] = M.colors.orange, -- selection block
      R = M.colors.red, -- replace mode
      r = M.colors.red, -- replace character
      ["!"] = M.colors.bright_purple, -- waiting for shell running to complete (from cmd :!...)
      t = M.colors.purple, -- terminal
    },
    mode_icons = {
      n = "🅝   ", -- normal
      i = "🅘   ", -- insert
      v = "🅥   ", -- visual
      V = "🅛   ", -- visual line
      ["\22"] = "🅑   ", -- visual block
      c = "🅒   ", -- command
      s = "🅢   ", -- selection
      S = "🅛   ", -- selection
      ["\19"] = "🅑   ", -- special selection?
      R = "🅡   ", -- replace mode
      r = "🅧   ", -- replace character
      ["!"] = "🅦   ", -- waiting for shell running to complete (from cmd :!...)
      t = "🅣   ", -- terminal
    },
  },
  provider = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return self.mode_icons[mode]
  end,
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd.redrawstatus()
    end),
  },
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = self.mode_colors[mode], bold = true }
  end,
}

M.segments.FileSize = {
  condition = function()
    return vim.fn.getfsize(vim.api.nvim_buf_get_name(0)) > 0
  end,
  provider = function()
    -- stackoverflow, compute human readable file size
    local suffix = { "b", "k", "M", "G", "T", "P", "E" }
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
    fsize = (fsize < 0 and 0) or fsize
    if fsize < 1024 then return fsize .. suffix[1] .. "  " end
    local i = math.floor((math.log(fsize) / math.log(1024)))
    return string.format("%.2g%s  ", fsize / math.pow(1024, i), suffix[i + 1])
  end,
  hl = { fg = M.colors.text, bold = true },
}

M.segments.FileNameBlock = {
  -- let's first set up some attributes needed by this component and it's children
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}
-- We can now define some children separately and add them later

local FileIcon = {
  fallthrough = false,
  {
    condition = function()
      return vim.bo.filetype == "TelescopePrompt"
    end,
    provider = " ",
    hl = { fg = M.colors.white, bold = true },
  },
  {
    init = function(self)
      local filename = self.filename
      local extension = vim.fn.fnamemodify(filename, ":e")
      self.icon, self.icon_color =
        require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
    end,
    provider = function(self)
      return self.icon and (self.icon .. "  ")
    end,
    hl = function(self)
      return { fg = self.icon_color }
    end,
  },
}

local FileName = {
  static = {
    zshDirHashTable = nil,
    readZshHashDirs = function()
      local cmdOutput = mySystem.runCmd("zsh -ic 'hash -d'")
      local dirHashTable = {}
      if type(cmdOutput) == "string" then
        for line in string.gmatch(cmdOutput, "%S+") do
          for k, v in line:gmatch("([^=]+)=(%S+)") do
            dirHashTable[k] = v
          end
        end
      end
      return dirHashTable
    end,
    importantDirFileMarker = {
      ".git",
      "packageInfo",
      "Config",
      "settings.gradle",
      "settings.gradle.kts",
      "CMakeLists.txt",
      "package.json",
      "cargo.toml",
    },
    isImportantDir = function(dir, fileMarkers)
      for _, markerFile in ipairs(fileMarkers) do
        if os.execute('[[ -e "' .. dir .. "/" .. markerFile .. '" ]]') == 0 then
          return true
        end
      end
      return false
    end,
    parseImportantDir = function(filename, absoluteFilename, importantDirPredicate)
      local file_table = { basename = vim.fn.fnamemodify(filename, ":t") }
      local dirname = vim.fn.fnamemodify(filename, ":h")
      local absoluteDirname = vim.fn.fnamemodify(absoluteFilename, ":h")
      local dirname_prefix = vim.fn.fnamemodify(dirname, ":h") .. "/"
      local dirname_suffix = ""
      local dirname_tail = vim.fn.fnamemodify(dirname, ":t") .. "/"
      while dirname ~= "." and dirname ~= "/" and dirname ~= "~" do
        if importantDirPredicate(absoluteDirname) then
          file_table["dirname_prefix"] = dirname_prefix
          file_table["dirname_suffix"] = dirname_suffix
          file_table["dirname"] = dirname_tail
          break
        end
        dirname = vim.fn.fnamemodify(dirname, ":h")
        absoluteDirname = vim.fn.fnamemodify(absoluteDirname, ":h")
        dirname_prefix = vim.fn.fnamemodify(dirname, ":h") .. "/"
        dirname_suffix = dirname_tail .. dirname_suffix
        dirname_tail = vim.fn.fnamemodify(dirname, ":t") .. "/"
      end
      if not file_table["dirname"] then
        dirname = vim.fn.fnamemodify(filename, ":h")
        file_table["dirname_prefix"] = vim.fn.fnamemodify(dirname, ":h") .. "/"
        file_table["dirname_suffix"] = ""
        file_table["dirname"] = vim.fn.fnamemodify(dirname, ":t") .. "/"
      end
      if not conditions.width_percent_below(#filename, 0.25) then
        file_table["dirname_prefix"] = vim.fn.pathshorten(file_table["dirname_prefix"])
        file_table["dirname_suffix"] = vim.fn.pathshorten(file_table["dirname_suffix"])
      end
      return file_table
    end,
    filenameDirTable = {},
  },
  init = function(self)
    if not self.zshDirHashTable then self.zshDirHashTable = self.readZshHashDirs() end
    self.filename = vim.api.nvim_buf_get_name(0)
    self.filenameRel = nil
    for hash, dir in pairs(self.zshDirHashTable) do
      if string.match(self.filename, "^" .. dir) then
        self.filenameRel = string.gsub(self.filename, "^" .. dir, "~" .. hash)
        break
      end
    end
    self.filenameRel = self.filenameRel or vim.fn.fnamemodify(self.filename, ":~")
    self.filenameTable = self.filenameDirTable[self.filename]
    if not self.filenameTable then
      self.filenameTable = self.parseImportantDir(self.filenameRel, self.filename, function(d)
        return self.isImportantDir(d, self.importantDirFileMarker)
      end)
      self.filenameDirTable[self.filename] = self.filenameTable
    end
  end,
  fallthrough = false,
  {
    condition = function()
      return vim.bo.filetype == "help"
    end,
    provider = function()
      local filename = vim.api.nvim_buf_get_name(0)
      return vim.fn.fnamemodify(filename, ":t")
    end,
    hl = { fg = M.colors.blue },
  },
  {
    condition = M.conditions.filetypeNotIgnored,
    fallthrough = false,
    {
      condition = function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~") == ""
      end,
      provider = "[No Name]",
      hl = { fg = M.colors.white, bold = true },
    },
    {
      {
        provider = function(self)
          return self.filenameTable["dirname_prefix"]
        end,
        hl = { fg = M.colors.dark_grey },
      },
      {
        provider = function(self)
          return self.filenameTable["dirname"]
        end,
        hl = { fg = M.colors.green },
      },
      {
        provider = function(self)
          return self.filenameTable["dirname_suffix"]
        end,
        hl = { fg = M.colors.dark_grey },
      },
      {
        provider = function(self)
          return self.filenameTable["basename"]
        end,
        hl = { fg = M.colors.white, bold = true },
      },
    },
  },
}

local FileFlags = {
  {
    condition = M.conditions.filenameNotIgnored,
    {
      condition = function()
        return vim.bo.modified
      end,
      provider = " ",
      hl = { fg = M.colors.vibrant_red },
    },
    {
      condition = function()
        return not vim.bo.modifiable or vim.bo.readonly
      end,
      provider = " ",
      hl = { fg = M.colors.yellow },
    },
  },
}

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = M.colors.vibrant_red, bold = true, force = true }
    end
  end,
}

-- let's add the children to our FileNameBlock component
M.segments.FileNameBlock = utils.insert(
  M.segments.FileNameBlock,
  FileIcon,
  FileFlags,
  utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
  { provider = "  %<" } -- this means that the statusline is cut here when there's not enough space
)

M.segments.Ruler = {
  init = function(self)
    local new_showcmd = vim.api.nvim_eval_statusline("%S", {}).str
    self.showcmd = new_showcmd or self.showcmd
  end,
  condition = M.conditions.filenameNotIgnored,
  update = { "CursorMoved", "ModeChanged" },
  {
    -- %l = current line number
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = "%l:%c %P  ",
  },
  {
    condition = function()
      local mode = vim.fn.mode()
      local is_visual = mode == "\22" or mode == "v" or mode == "V"
      local showcmd_status = vim.o.showcmd and vim.o.showcmdloc == "statusline"
      return is_visual and showcmd_status
    end,
    provider = function(self)
      return "󰩭 " .. self.showcmd .. "  "
    end,
  },
}

M.segments.Lsp = {
  condition = conditions.lsp_attached,
  on_click = {
    name = "heirline_lsp",
    callback = function()
      vim.defer_fn(function()
        vim.cmd.LspInfo()
      end, 100)
    end,
  },
  {
    provider = astroStatus.provider.lsp_progress({
      str = "",
      padding = { left = 2 },
    }),
    update = {
      "User",
      pattern = "AstroLspProgress",
      callback = vim.schedule_wrap(function()
        vim.cmd.redrawstatus()
      end),
    },
  },
  {
    provider = "   ",
    update = {
      "LspAttach",
      "LspDetach",
      "BufEnter",
      callback = vim.schedule_wrap(function()
        vim.cmd.redrawstatus()
      end),
    },
  },
}

M.segments.TreeSitter = {
  condition = function()
    if not package.loaded["nvim-treesitter"] then return false end
    local parsers = require("nvim-treesitter.parsers")
    return parsers.has_parser(parsers.get_buf_lang(vim.api.nvim_get_current_buf()))
  end,
  on_click = {
    name = "heirline_treesitter",
    callback = function()
      vim.defer_fn(function()
        vim.cmd("InspectTree")
      end, 100)
    end,
  },
  update = { "OptionSet", pattern = "syntax" },
  provider = "  󱘎 ",
  hl = { fg = M.colors.cyan },
}

M.segments.LineEnding = {
  static = {
    symbols = {
      unix = "LF",
      dos = "CRLF",
      mac = "CR",
    },
  },
  provider = function(self)
    return "  " .. self.symbols[vim.bo.fileformat]
  end,
}

M.segments.Encoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
    return "  " .. enc:upper()
  end,
}

M.segments.BufferType = {
  provider = function()
    return "  " .. myBuffers.currentFileTypeLabel()
  end,
  hl = { fg = utils.get_highlight("Type").fg, bold = true },
}

M.segments.Git = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status_dict = vim.b["gitsigns_status_dict"]
  end,
  {
    on_click = {
      name = "heirline_branch",
      callback = function()
        if astroUtils.is_available("telescope.nvim") then
          vim.defer_fn(function()
            require("telescope.builtin").git_branches()
          end, 100)
        end
      end,
    },
    provider = function(self)
      return "   " .. self.status_dict.head
    end,
    hl = { fg = M.colors.green, bold = true },
  },
  {
    condition = function()
      local git_status = vim.b["gitsigns_status_dict"]
      return git_status.added ~= 0 or git_status.removed ~= 0 or git_status.changed ~= 0
    end,
    on_click = {
      name = "heirline_git",
      callback = function()
        if astroUtils.is_available("diffview.nvim") then
          vim.defer_fn(function()
            vim.cmd("DiffviewOpen")
          end, 100)
        elseif astroUtils.is_available("telescope.nvim") then
          vim.defer_fn(function()
            require("telescope.builtin").git_status()
          end, 100)
        end
      end,
    },
    hl = { fg = M.colors.text },
    {
      provider = "  !",
      hl = { fg = M.colors.yellow },
    },
    {
      provider = function(self)
        return self.status_dict.removed or 0
      end,
      hl = { fg = M.colors.red },
    },
    {
      provider = "/",
    },
    {
      provider = function(self)
        return self.status_dict.changed or 0
      end,
      hl = { fg = M.colors.yellow, bold = true },
    },
    {
      provider = "/",
    },
    {
      provider = function(self)
        return self.status_dict.added or 0
      end,
      hl = { fg = M.colors.green },
    },
  },
}

M.segments.Diagnostics = {
  static = {
    error_icon = " ",
    warn_icon = " ",
    info_icon = " ",
    hint_icon = " ",
  },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  condition = function()
    return vim.fn.getfsize(vim.api.nvim_buf_get_name(0)) > 0
  end,
  update = { "DiagnosticChanged", "BufEnter" },
  {
    condition = conditions.has_diagnostics,
    on_click = {
      name = "heirline_diagnostic",
      callback = function()
        if astroUtils.is_available("trouble.nvim") then
          vim.defer_fn(function()
            vim.cmd.TroubleToggle()
          end, 100)
        elseif astroUtils.is_available("telescope.nvim") then
          vim.defer_fn(function()
            require("telescope.builtin").diagnostics()
          end, 100)
        end
      end,
    },
    {
      provider = "  ",
    },
    {
      provider = function(self)
        return self.errors > 0 and (self.error_icon .. self.errors .. " ")
      end,
      hl = { fg = M.colors.red, bold = true },
    },
    {
      provider = function(self)
        return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
      end,
      hl = { fg = M.colors.yellow, bold = true },
    },
    {
      provider = function(self)
        return self.info > 0 and (self.info_icon .. self.info .. " ")
      end,
      hl = { fg = M.colors.bright_blue, bold = true },
    },
    {
      provider = function(self)
        return self.hints > 0 and (self.hint_icon .. self.hints .. " ")
      end,
      hl = { fg = M.colors.bright_purple, bold = true },
    },
  },
  {
    condition = function()
      local has_diags = conditions.has_diagnostics()
      local has_error = has_diags
        and (
          #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          or #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        )
      return not has_diags or not has_error
    end,
    provider = "   ",
    hl = { fg = M.colors.green },
  },
}

M.segments.ScrollBar = {
  static = {
    sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" },
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return "  " .. string.rep(self.sbar[i], 2)
  end,
  on_click = {
    name = "heirline_buf_outline",
    callback = function()
      if astroUtils.is_available("codewindow.nvim") then
        vim.defer_fn(function()
          require("codewindow").toggle_minimap()
        end, 100)
      elseif astroStatus.condition.aerial_available() then
        vim.defer_fn(function()
          vim.cmd("AerialToggle")
        end, 100)
      end
    end,
  },
  hl = { fg = M.colors.yellow, bg = M.colors.statusbar_bg },
}

return M
