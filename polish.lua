-- This function is run last and is a good place to configuring
-- anything that doesn't fit in the normal config can go here
return function()
  require("user.autocmds")
  require("user.filetypes")

  -- I adjust my Which Key descriptions here becaus I want to override any plugin that end up
  -- doing a late config into it.
  local whichkey = require("which-key")
  whichkey.register({
    ["<C-w>"] = { name = "󰕮 Windows" },
    ["<leader>"] = { name = " Custom" },
    ['"'] = { name = " Registers" },
    ["'"] = { name = " Marks" },
    ["<"] = { name = " Indent left" },
    [">"] = { name = " Indent" },
    ["@"] = { name = " Registers" },
    ["["] = { name = " Go Previous" },
    ["]"] = { name = " Go Next" },
    ["`"] = { name = " Marks" },
    c = { name = " Change" },
    d = { name = " Delete (cut)" },
    g = { name = " Global" },
    s = { name = " Surroung" },
    v = { name = "󰩭 Visual Mode (select)" },
    y = { name = " Yank (copy)" },
    z = { name = " Fold & Utils" },
  })
  whichkey.register({
    b = { name = " Buffers" },
    h = { name = "󰘥 Help" },
    j = { name = "⨝ Join" },
    o = { name = " Open" },
    r = { name = "󱩽 Refactor" },
    s = { name = "󰑮 Skip to" },
    v = { name = " Visualise" },
    w = { name = "󰕮 Windows" },
  }, { prefix = "<leader>" })
end
