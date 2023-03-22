return {
  {
    "direnv/direnv.vim",
    event = "BufRead",
  },
  {
    -- Navigate windows with Ctrl+[hjkl], and do it with terminal windows too
    "knubie/vim-kitty-navigator",
    lazy = false,
    build = "cp ./*.py ~/.config/kitty/",
  },
}
