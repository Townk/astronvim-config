local cmp = require("cmp")
local luasnip = require("luasnip")

return {
  "hrsh7th/nvim-cmp",
  keys = { ":", "/", "?" }, -- lazy load cmp on more keys along with insert mode
  dependencies = {
    "hrsh7th/cmp-cmdline",  -- add cmp-cmdline as dependency of cmp
  },
  config = function(_, opts)
    -- run cmp setup
    cmp.setup(opts)

    -- configure `cmp-cmdline` as described in their repo: https://github.com/hrsh7th/cmp-cmdline#setup
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })
  end,
  opts = function(_, opts)
    opts.performance = {
      debounce = 300,
      throttle = 120,
      fetching_timeout = 100,
    }
    opts.experimental = {
      ghost_text = true,
    }
    opts.mapping["<C-d>"] = cmp.mapping.scroll_docs(-4)
    opts.mapping["<C-f>"] = cmp.mapping.scroll_docs(4)
    opts.mapping["<C-Space>"] = cmp.mapping.complete({})
    opts.mapping["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
    opts.sources = {
      { name = "nvim_lsp", priority = 1000 },
      -- { name = "codeium",  priority = 750 },
      { name = "luasnip",  priority = 700 },
      { name = "path",     priority = 650 },
      { name = "buffer",   priority = 400 },
    }
    opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" })
    opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" })
    return opts
  end,
}
