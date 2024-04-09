local utils = require("astronvim.utils")

return {
  -- Keymaps visualizer
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      return utils.extend_tbl(opts, {
        icons = {
          separator = "➜", -- symbol used between a key and it's label
        },
      })
    end,
  },

  -- File-tree navigation [<leader>op]
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      local events = require("neo-tree.events")
      local handlers = opts.event_handlers or {}
      table.insert(handlers, {
        event = events.FILE_OPENED,
        handler = function(_)
          require("neo-tree.command").execute({ action = "close" })
        end,
      })

      return utils.extend_tbl(opts, {
        event_handlers = handlers,
        window = {
          mappings = {
            ["<tab>"] = "child_or_open",
          },
        },
      })
    end,
  },

  -- Vim lines (status, win, buf, tabs, etc.)
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local astroStatusLine = require("astronvim.utils.status")
      local myStatusLine = require("user.lib.statusline")

      opts.statusline = {
        -- statusline
        hl = { fg = "fg", bg = "bg" },
        myStatusLine.segments.DoomDecoration,
        myStatusLine.segments.ModeIndicator,
        myStatusLine.segments.FileSize,
        myStatusLine.segments.FileNameBlock,
        myStatusLine.segments.Ruler,
        myStatusLine.segments.Spacer,
        myStatusLine.segments.Lsp,
        myStatusLine.segments.TreeSitter,
        myStatusLine.segments.LineEnding,
        myStatusLine.segments.Encoding,
        myStatusLine.segments.BufferType,
        myStatusLine.segments.Git,
        myStatusLine.segments.Diagnostics,
        myStatusLine.segments.ScrollBar,
      }

      opts.statuscolumn = vim.fn.has("nvim-0.9") == 1
          and {
            astroStatusLine.component.signcolumn(),
            astroStatusLine.component.foldcolumn(),
            astroStatusLine.component.fill(),
            astroStatusLine.component.numbercolumn(),
          }
        or nil

      return opts
    end,
  },

  -- Fuzzy search things
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-symbols.nvim", -- optional, select symbols
      "nvim-telescope/telescope-ui-select.nvim", -- optional, for using telescope in more places
      "nvim-tree/nvim-web-devicons", -- optional, for icons
      "nvim-telescope/telescope-file-browser.nvim",
      "tiagovla/scope.nvim",
    },
    config = function(...)
      local telescope = require("telescope")
      require("plugins.configs.telescope")(...)
      telescope.load_extension("file_browser")
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      telescope.load_extension("scope")
    end,
    opts = function(_, opts)
      local telescope = {
        themes = require("telescope.themes"),
        action = require("telescope.actions"),
        actionlayout = require("telescope.actions.layout"),
      }
      return utils.extend_tbl(opts, {
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case", -- this is default
          },
          ["ui-select"] = {
            telescope.themes.get_cursor(),
          },
        },
        defaults = {
          prompt_prefix = " " .. opts.defaults.prompt_prefix .. " ",
          selection_caret = "  ",
          entry_prefix = "   ",
          multi_icon = " ",
          sorting_strategy = "ascending",
          results_title = "",
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--trim",
          },
          color_devicons = true,
          layout_strategy = "horizontal",
          winblend = 5,
          layout_config = {
            prompt_position = "top",
            horizontal = {
              width = 0.75,
              height = 0.85,
              width_padding = 0.04,
              height_padding = 0.1,
              preview_width = 0.6,
            },
            vertical = {
              width_padding = 0.05,
              height_padding = 1,
              preview_height = 0.5,
            },
          },
          mappings = {
            i = {
              ["<C-u>"] = telescope.action.preview_scrolling_up,
              ["<C-d>"] = telescope.action.preview_scrolling_down,
              ["<C-j>"] = telescope.action.move_selection_next,
              ["<C-k>"] = telescope.action.move_selection_previous,
              ["<C-Space>"] = telescope.actionlayout.toggle_preview,
              ["<esc>"] = telescope.action.close,
              ["<C-x>"] = telescope.action.cycle_previewers_next,
              ["<C-a>"] = telescope.action.cycle_previewers_prev,
            },
          },
        },
      })
    end,
  },

  -- Completion framework
  {
    "hrsh7th/nvim-cmp",
    keys = { ":", "/", "?" }, -- lazy load cmp on more keys along with insert mode
    dependencies = {
      "hrsh7th/cmp-cmdline", -- add cmp-cmdline as dependency of cmp
    },
    config = function(_, opts)
      local cmp = require("cmp")

      -- run cmp setup
      cmp.setup(opts)

      -- configure `cmp-cmdline` as described in their repo: https://github.com/hrsh7th/cmp-cmdline#setup
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } } }
        ),
      })
    end,
    opts = function(_, opts)
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      return utils.extend_tbl(opts, {
        performance = {
          debounce = 300,
          throttle = 120,
          fetching_timeout = 100,
        },
        experimental = {
          ghost_text = true,
        },
        sources = {
          { name = "nvim_lsp", priority = 1000 },
          -- { name = "codeium",  priority = 750 },
          { name = "luasnip", priority = 700 },
          { name = "path", priority = 650 },
          { name = "buffer", priority = 400 },
        },
        mapping = {
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
      })
    end,
  },

  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, {
        "clangd",
        "html",
        "jsonls",
        "kotlin_language_server",
        "lua_ls",
        "marksman",
        "pyright",
        "tsserver",
        "vimls",
        "yamlls",
      })
    end,
  },

  -- use mason-null-ls to configure Formatters/Linter installations
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, {
        "beautysh",
        "ruff",
      })
    end,
  },

  -- use mason-nvim-dap to configure Debuggers installations
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, {})
    end,
  },

  -- Diagnostics
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      return utils.extend_tbl(opts, {
        -- Check supported formatters and linters
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
        sources = {
          -- Global (ish)
          null_ls.builtins.code_actions.refactoring,
          null_ls.builtins.formatting.prettierd.with({
            extra_filetypes = { "json", "markdown", "yaml" },
          }),

          -- Shell
          null_ls.builtins.code_actions.shellcheck.with({
            extra_filetypes = { "zsh", "bsh" },
          }),
          null_ls.builtins.formatting.beautysh.with({
            extra_filetypes = { "zsh", "bsh" },
          }),
          null_ls.builtins.diagnostics.shellcheck.with({
            extra_filetypes = { "bash" },
          }),
          null_ls.builtins.diagnostics.zsh,

          -- Nix
          null_ls.builtins.code_actions.statix,
          null_ls.builtins.formatting.nixfmt,
          null_ls.builtins.diagnostics.statix,

          -- Lua
          null_ls.builtins.diagnostics.luacheck,
          null_ls.builtins.formatting.stylua,
        },
      })
    end,
  },
}
