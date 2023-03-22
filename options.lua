-- set vim options here (vim.<first_key>.<second_key> = value)
return {
  opt = {
    -- set to true or false etc.
    spell = false, -- sets vim.opt.spell
    -- Some servers have issues with backup files, see #649
    backup = false,
    writebackup = false,
    -- Which-Key helper
    timeout = true,
    timeoutlen = 300,
    -- Set highlight on search
    hlsearch = true,
    -- Make line numbers default
    relativenumber = true, -- sets vim.opt.relativenumber
    number = true, -- sets vim.opt.number
    -- Enable cursor line
    cursorline = true,
    -- Enable mouse mode
    mouse = "a",
    mousemoveevent = true,
    -- Enable break indent
    breakindent = true,
    -- Save undo history
    undofile = true,
    -- Tab indent
    smarttab = true,
    autoindent = true,
    smartindent = true,
    cindent = true,
    expandtab = true,
    wrap = false,
    shiftround = true,
    -- Case insensitive searching UNLESS /C or capital in search
    ignorecase = true,
    smartcase = true,
    -- Decrease update time
    updatetime = 250,
    signcolumn = "yes:1",
    -- Set colorscheme
    termguicolors = true,
    -- Set completeopt to have a better completion experience
    completeopt = "longest,menuone",
    -- Visual changes
    scrolloff = 2,
  },
  g = {
    mapleader = " ", -- sets vim.g.mapleader
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    cmp_enabled = true, -- enable completion at start
    autopairs_enabled = true, -- enable autopairs at start
    diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements
  },
}
