-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
local telescope = require("telescope.builtin")
local tscontext = require("treesitter-context")

local myLib = {
  find = require("user.lib.find"),
  ui = require("user.lib.ui"),
  git = require("user.lib.git"),
}

return {
  -- first key is the mode
  -- second key is the lefthand side of the map

  -- Normal mappings
  n = {
    -- Shortcuts I like to disable
    ["|"] = false,
    ["<leader>/"] = false,
    ["<leader>c"] = false,
    ["<leader>C"] = false,
    ["<leader>e"] = false,
    ["<leader>h"] = false,
    ["<leader>n"] = false,
    ["<leader>o"] = false,
    ["<leader>w"] = false,
    --

    -- Joinning lines won't move cursor
    ["J"] = { "mzJ`z", noremap = true },
    --

    -- I can move between tabs with the Alt key
    ["<A-1>"] = { "1gt", noremap = true },
    ["<A-2>"] = { "2gt", noremap = true },
    ["<A-3>"] = { "3gt", noremap = true },
    ["<A-4>"] = { "4gt", noremap = true },
    ["<A-5>"] = { "5gt", noremap = true },
    ["<A-6>"] = { "6gt", noremap = true },
    ["<A-7>"] = { "7gt", noremap = true },
    ["<A-8>"] = { "8gt", noremap = true },
    ["<A-9>"] = { "9gt", noremap = true },
    --

    -- Jumping vertically keep the cursor centralized on the screen
    ["<C-f>"] = { "<C-f>zz", noremap = true },
    ["<C-b>"] = { "<C-b>zz", noremap = true },
    ["<C-d>"] = { "<C-d>zz", noremap = true },
    ["<C-u>"] = { "<C-u>zz", noremap = true },
    ["n"] = { "nzzzv", noremap = true },
    ["N"] = { "Nzzzv", noremap = true },
    --

    -- [[ Keymaps: Global ]]
    ["ga"] = { "<Plug>(EasyAlign)", desc = "Easy Align" },
    --

    -- [[ Keymaps: Buffers ]]
    ["<leader><space>"] = { telescope.buffers, desc = "Switch to buffer" },
    ["<leader>bl"] = { ':b#<cr>g`"zv', desc = "Buffer Last Used", silent = true },
    ["<leader>bn"] = { ':bnext<cr>g`"zv', desc = "Buffer Next", silent = true },
    ["<leader>bp"] = { ':bprev<cr>g`"zv', desc = "Buffer Previous", silent = true },
    ["<leader>bx"] = { myLib.ui.closeBufferSelection, desc = "Pick close buffer" },
    ["zx"] = { require("astronvim.utils.buffer").close, desc = "Close buffer" },
    ["zX"] = { myLib.ui.closeBufferForced, desc = "Force close buffer", silent = true },
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
    ['<leader>f"'] = { telescope.registers, desc = "Find registers" },
    ["<leader>f."] = { "<cmd>Telescope file_browser<cr>", desc = "File browser" },
    ["<leader>fd"] = { telescope.diagnostics, desc = "Find diagnostics" },
    ["<leader>fg"] = { telescope.git_files, desc = "Find in project" },
    ["<leader>fi"] = { name = "in..." },
    ["<leader>fid"] = { myLib.find.findInCurrentDir, desc = "Find in directory" },
    ["<leader>fif"] = { telescope.live_grep, desc = "Find in files (Grep)" },
    ["<leader>fiF"] = { myLib.find.findInAllFiles, desc = "Find in ALL files (Grep)" },
    ["<leader>fp"] = { myLib.find.findInUserConfigFiles, desc = "Find in NeoVim user config" },
    ["<leader>fr"] = { telescope.oldfiles, desc = "Find recent files" },
    ["<leader>fs"] = { myLib.find.findStringInBuffer, desc = "Find string in buffer" },
    ["<leader>fw"] = { telescope.grep_string, desc = "Find word under cursor" },
    --

    -- [[ Keymaps: Help ]]
    ["<leader>hh"] = { telescope.help_tags, desc = "Search help" },
    ["<leader>hm"] = { telescope.man_pages, desc = "Search man pages" },
    ["<leader>hk"] = { telescope.keymaps, desc = "Search keymaps" },
    ["<leader>ho"] = { telescope.vim_options, desc = "Search options" },
    ["<leader>hc"] = { telescope.commands, desc = "Search commands" },
    ["<leader>hf"] = { telescope.highlights, desc = "Search highlights" },
    ["<leader>ht"] = { telescope.colorscheme, desc = "Search themes" },
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
    ["<leader>wh"] = { myLib.ui.moveWindowCursorToLeft, desc = "Go to the left window" },
    ["<leader>wj"] = { myLib.ui.moveWindowCursorToBottom, desc = "Go to the down window" },
    ["<leader>wk"] = { myLib.ui.moveWindowCursorToTop, desc = "Go to the up window" },
    ["<leader>wl"] = { myLib.ui.moveWindowCursorToRight, desc = "Go to the right window" },
    ["<leader>wq"] = { "<C-W>q", desc = "Quit a window" },
    ["<leader>ws"] = { "<C-W>s", desc = "Split window" },
    ["<leader>wT"] = { "<C-W>T", desc = "Break out into new tab" },
    ["<leader>wv"] = { "<C-W>v", desc = "Split window vertically" },
    ["<leader>ww"] = { "<C-W>w", desc = "Switch windows" },
    ["<leader>wx"] = { "<C-W>x", desc = "Swap current with next" },
    ["<leader>wo"] = { "<C-W>ozz", desc = "Swap current with next" },
    ["<C-h>"] = { myLib.ui.moveWindowCursorToLeft, desc = "Move cursor to window in the left" },
    ["<C-j>"] = { myLib.ui.moveWindowCursorToBottom, desc = "Move cursor to window below" },
    ["<C-k>"] = { myLib.ui.moveWindowCursorToTop, desc = "Move cursor to window above" },
    ["<C-l>"] = { myLib.ui.moveWindowCursorToRight, desc = "Move cursor to window in the right" },
    --

    -- [[ Keymaps: Visualise ]]
    ["<leader>vd"] = { vim.diagnostic.open_float, desc = "View diagnostics" },
    ["<leader>vm"] = { "<cmd>messages<cr>", desc = "View messages" },
    ["<leader>vb"] = { myLib.ui.viewNotifications, desc = "View notifications" },
    --

    -- [[ Keymaps: Join ]]
    ["<leader>jj"] = { require('treesj').toggle, desc = "Toggle block joinning" },
    ["<leader>js"] = { require('treesj').split, desc = "Block split" },
    ["<leader>jm"] = { require('treesj').join, desc = "Block join" },
    --

    -- [[ Keymaps: Open ]]
    ["<leader>ot"] = { "<cmd>InspectTree<cr>", desc = "Open TreeSitter Inspector" },
    ["<leader>op"] = { "<cmd>Neotree toggle<cr>", desc = "Open Project Tree" },
    ["<leader>oo"] = { "<cmd>AerialToggle<cr>", desc = "Open Buffer Outline" },
    ["<leader>om"] = { myLib.ui.openMiniMap, desc = "Open Mini Map" },
    ["<leader>od"] = { "<cmd>TroubleToggle<cr>", desc = "Open Diagnostics" },
    --

    -- [[ Keymaps: Toggles ]]
    ["<leader>um"] = { myLib.ui.toggleMiniMap, desc = "Toggle Mini Map" },
    --

    -- [[ Keymaps: Git ]]
    ["<leader>gr"] = false,
    ["<leader>gn"] = { name = "Neogit..." },
    ["<leader>gg"] = { "<cmd>Neogit<cr>", desc = "Open Neogit (MaGit)" },
    ["<leader>gd"] = { "<cmd>DiffviewOpen<cr>", desc = "View Git diff" },
    ["<leader>gh"] = { "<cmd>DiffviewFileHistory %<cr>", desc = "View Git history" },
    ["<leader>gU"] = { myLib.git.unstageBuffer, desc = "Unstage Git buffer" },
    --

    -- [[ Keymaps: Toggles ]]
    ["<leader>ux"] = { function(silend)
      tscontext.toggle()
      if tscontext.enabled() then
        myLib.ui.notify(silend, "treesitter-context on")
      else
        myLib.ui.notify(silend, "treesitter-context off")
      end
    end, desc = "Toggle Tree-Sitter Context" },
    --

    -- [[ Keymaps: Navigation ]]
    ["[d"] = { vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
    ["]d"] = { vim.diagnostic.goto_next, desc = "Next diagnostic" },
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
    ["ga"] = { "<Plug>(EasyAlign)" },
  },
  --

  -- Terminal mappings
  t = {
    -- setting a mapping to false will disable it
    ["<esc>"] = false,
  },
}
