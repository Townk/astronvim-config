return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = {
      ["Townk"] = "Townk/astronvim-config", -- Track my personal configuration
    },
  },
  --

  -- Set colorscheme to use
  colorscheme = "astrodark",
  --

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },
  --

  -- LSP configuration
  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = {}, -- enable format on save for specified filetypes only
        ignore_filetypes = {}, -- disable format on save for specified filetypes
      },
      disabled = {}, -- disable formatting capabilities for the listed language servers
      timeout_ms = 1000, -- default format timeout
    },
    -- enable servers that you already have installed without mason
    servers = {
      "lua_ls",
      "bashls",
      "clangd",
      "gradle_ls",
      "jsonls",
      "kotlin_language_server",
      "pyright",
      "rnix",
      "rust_analyzer",
      "taplo",
      "tsserver",
      "vimls",
      "yamlls",
    },
  },
  --

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },
  --

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- Use relative line numbers in all modes except insert.
    local ui_updates_group = vim.api.nvim_create_augroup("MyUiUpdates", { clear = true })
    vim.api.nvim_create_autocmd("InsertEnter", {
      group = ui_updates_group,
      pattern = "*",
      command = "set norelativenumber",
    })
    vim.api.nvim_create_autocmd("InsertLeave", {
      group = ui_updates_group,
      pattern = "*",
      command = "set relativenumber",
    })

    require("which-key").register({
      b = { name = " Buffers" },
      h = { name = "󰘥 Help" },
      s = { name = "󰑮 Skip to" },
      v = { name = " Visualise" },
      w = { name = "󰕮 Windows" },
    }, { prefix = "<leader>" })
  end,
}
