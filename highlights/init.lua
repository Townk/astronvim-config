return {
  -- this table overrides highlights in all themes
  TelescopeBorder = { fg = "#61afef" },
  TelescopeSelectionCaret = { fg = "#e2b86b", bg = "#30363f" },
  TelescopePromptBorder = { fg = "#e2b86b" },
  TelescopeResultsBorder = { fg = "#abb2bf" },
  TelescopePreviewBorder = { fg = "#5c6370" },
  NormalFloat = { bg = "#1f2329" },
  CursorLineNr = { fg = "#FFFFFF", bg = "#282c34" },
  CursorLineSign = { bg = "#282c34" },
  CursorLineFold = { bg = "#282c34" },
  StatusLine = { bg = "#181a1f" },
  LeapBackdrop = { link = "Comment" },
  LeapMatch = {
    fg = "white", -- for light themes, set to 'black' or similar
    bold = true,
    nocombine = true,
  },
  WinBar = { bg = "#20252c" },
  TreesitterContext = { bg = "#20252c", fg = "#5c6370" },
  TreesitterContextLineNumber = { bg = "#20252c", fg = "#5c6370" },
  TreesitterContextSeparator = { bg = "#1B1D22", fg = "#181a1f" },
}
