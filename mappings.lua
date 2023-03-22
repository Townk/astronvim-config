-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
local telescopeBuiltins = require("telescope.builtin")
local userFunctions = require("user.functions")

return {
  -- first key is the mode
  -- second key is the lefthand side of the map

  -- Normal mappings
  n = {
    -- Shortcuts I like to disable
    ["<leader>/"] = false,
    ["<leader>c"] = false,
    ["<leader>C"] = false,
    ["<leader>h"] = false,
    ["<leader>n"] = false,
    ["<leader>o"] = false,
    ["<leader>w"] = false,
    --

    -- Joinning lines won't move cursor
    ["J"] = { "mzJ`z", noremap = true },
    --

    -- Jumping vertically keep the cursor centralized on the screen
    ["<C-f>"] = { "<C-f>zz", noremap = true },
    ["<C-b>"] = { "<C-b>zz", noremap = true },
    ["<C-d>"] = { "<C-d>zz", noremap = true },
    ["<C-u>"] = { "<C-u>zz", noremap = true },
    ["n"] = { "nzzzv", noremap = true },
    ["N"] = { "Nzzzv", noremap = true },
    --

    -- [[ Keymaps: Buffers ]]
    ["<leader><space>"] = { telescopeBuiltins.buffers, desc = "Switch to buffer" },
    ["<leader>bl"] = { ':b#<cr>g`"zv', desc = "Buffer Last Used", silent = true },
    ["<leader>bn"] = { ':bnext<cr>g`"zv', desc = "Buffer Next", silent = true },
    ["<leader>bp"] = { ':bprev<cr>g`"zv', desc = "Buffer Previous", silent = true },
    ["<leader>bx"] = { userFunctions.closeBufferSelection, desc = "Pick close buffer" },
    ["zx"] = { require("astronvim.utils.buffer").close, desc = "Close buffer" },
    ["zX"] = { userFunctions.closeBufferForced, desc = "Force close buffer", silent = true },
    --

    -- [[ Keymaps: Find ]]
    ["<leader>fa"] = false,
    ["<leader>fc"] = false,
    ["<leader>fC"] = false,
    ["<leader>fh"] = false,
    ["<leader>fk"] = false,
    ["<leader>fm"] = false,
    ["<leader>fn"] = false,
    ["<leader>fo"] = false,
    ["<leader>ft"] = false,
    ["<leader>fW"] = false,
    ['<leader>f"'] = { telescopeBuiltins.registers, desc = "Find registers" },
    ["<leader>f."] = { "<cmd>Telescope file_browser<cr>", desc = "File browser" },
    ["<leader>fd"] = { telescopeBuiltins.diagnostics, desc = "Find diagnostics" },
    ["<leader>fg"] = { telescopeBuiltins.git_files, desc = "Find in project" },
    ["<leader>fi"] = { name = "in..." },
    ["<leader>fid"] = { userFunctions.findInCurrentDir, desc = "Find in directory" },
    ["<leader>fif"] = { telescopeBuiltins.live_grep, desc = "Find in files (Grep)" },
    ["<leader>fiF"] = { userFunctions.findInAllFiles, desc = "Find in ALL files (Grep)" },
    ["<leader>fp"] = { userFunctions.findInConfigFiles, desc = "Find in NeoVim config" },
    ["<leader>fr"] = { telescopeBuiltins.oldfiles, desc = "Find recent files" },
    ["<leader>fs"] = { userFunctions.findStringInBuffer, desc = "Find string in buffer" },
    ["<leader>fu"] = { userFunctions.findInUserConfigFiles, desc = "Find in NeoVim user config" },
    ["<leader>fw"] = { telescopeBuiltins.grep_string, desc = "Find word under cursor" },
    --

    -- [[ Keymaps: Help ]]
    ["<leader>hh"] = { telescopeBuiltins.help_tags, desc = "Search help" },
    ["<leader>hm"] = { telescopeBuiltins.man_pages, desc = "Search man pages" },
    ["<leader>hk"] = { telescopeBuiltins.keymaps, desc = "Search keymaps" },
    ["<leader>ho"] = { telescopeBuiltins.vim_options, desc = "Search options" },
    ["<leader>hc"] = { telescopeBuiltins.commands, desc = "Search commands" },
    ["<leader>hf"] = { telescopeBuiltins.highlights, desc = "Search highlights" },
    ["<leader>ht"] = { telescopeBuiltins.colorscheme, desc = "Search themes" },
    --

    -- [[ Keymaps: Windows ]]
    -- I like to create all windows mappings using <leader> instead of <C-W>
    ["<leader>w+"] = { "<C-W>+", desc = "Increase height" },
    ["<leader>w-"] = { "<C-W>-", desc = "Decrease height" },
    ["<leader>w="] = { "<C-W>=", desc = "Equally height and wide" },
    ["<leader>w>"] = { "<C-W>>", desc = "Increase width" },
    ["<leader>w<"] = { "<C-W><", desc = "Decrease width" },
    ["<leader>w_"] = { "<C-W>_", desc = "Max out the height" },
    ["<leader>w|"] = { "<C-W>|", desc = "Max out the width" },
    ["<leader>wh"] = { "<C-W><C-H>", desc = "Go to the left window" },
    ["<leader>wj"] = { "<C-W><C-J>", desc = "Go to the down window" },
    ["<leader>wk"] = { "<C-W><C-K>", desc = "Go to the up window" },
    ["<leader>wl"] = { "<C-W><C-L>", desc = "Go to the right window" },
    ["<leader>wq"] = { "<C-W>q", desc = "Quit a window" },
    ["<leader>ws"] = { "<C-W>s", desc = "Split window" },
    ["<leader>wT"] = { "<C-W>T", desc = "Break out into new tab" },
    ["<leader>wv"] = { "<C-W>v", desc = "Split window vertically" },
    ["<leader>ww"] = { "<C-W>w", desc = "Switch windows" },
    ["<leader>wx"] = { "<C-W>x", desc = "Swap current with next" },
    ["<leader>wo"] = { "<C-W>ozz", desc = "Swap current with next" },
    --

    -- [[ Keymaps: Visualise ]]
    ["<leader>vd"] = { vim.diagnostic.open_float, desc = "View diagnostics" },
    ["<leader>vm"] = { "<cmd>messages<cr>", desc = "View messages" },
    ["<leader>vb"] = { userFunctions.viewNotifications, desc = "View notifications" },
    --

    -- [[ Keymaps: Open ]]
    ["<leader>op"] = { "<cmd>Neotree toggle<cr>", desc = "Open Project Tree" },
    --

    -- [[ Keymaps: Git ]]
    ["<leader>gr"] = false,
    ["<leader>gd"] = { "<cmd>DiffviewOpen<cr>", desc = "View Git diff" },
    ["<leader>gh"] = { "<cmd>DiffviewFileHistory %<cr>", desc = "View Git history" },
    ["<leader>gU"] = { userFunctions.unstageBuffer, desc = "Unstage Git buffer" },
    --

    -- [[ Keymaps: Navigation ]]
    ["[d"] = { vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
    ["]d"] = { vim.diagnostic.goto_next, desc = "Next diagnostic" },
  },
  --

  -- Visual mappings
  v = {
    -- Move lines
    ["J"] = { ":m '>+1<CR>gv=gv" },
    ["K"] = { ":m '<-2<CR>gv=gv" },
  },
  --

  -- Selection OR Visual mappings
  x = {
    -- Adjust the paste behavior.
    -- Usually, I want to re-yank the text I just past over a selection, but if for
    -- some reason I need the traditional Vim behavior I can use `gp` or `gP`.
    ["p"] = { "pgvy", noremap = true },
    ["P"] = { "Pgvy", noremap = true },
    ["gp"] = { "p", noremap = true, desc = "Replace and yank old selection" },
    ["gP"] = { "P", noremap = true, desc = "Replace and yank old selection" },
  },
  --

  -- Terminal mappings
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
}
