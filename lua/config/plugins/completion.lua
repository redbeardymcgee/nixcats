local load_w_after = function(name)
  vim.cmd.packadd(name)
  vim.cmd.packadd(name .. "/after")
end

return {
  -- {
  --   "cmp-cmdline",
  --   for_cat = "general.blink",
  --   on_plugin = { "blink.cmp" },
  --   load = load_w_after,
  -- },
  -- {
  --   "blink.compat",
  --   for_cat = "general.blink",
  --   dep_of = { "cmp-cmdline" },
  -- },
  -- {
  --   "luasnip",
  --   for_cat = "general.blink",
  --   dep_of = { "blink.cmp" },
  --   after = function(_)
  --     local luasnip = require("luasnip")
  --     require("luasnip.loaders.from_vscode").lazy_load()
  --     luasnip.config.setup({})
  --
  --     vim.keymap.set({ "i", "s" }, "<M-n>", function()
  --       if luasnip.choice_active() then
  --         luasnip.change_choice(1)
  --       end
  --     end)
  --   end,
  -- },
  -- {
  --   "colorful-menu.nvim",
  --   for_cat = "general.blink",
  --   on_plugin = { "blink.cmp" },
  -- },
  -- {
  --   -- TODO: https://max397574.github.io/care.nvim/
  --   "blink.cmp",
  --   for_cat = "general.blink",
  --   event = "DeferredUIEnter",
  --   after = function(_)
  --     require("blink.cmp").setup({
  --       -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
  --       -- See :h blink-cmp-config-keymap for configuring keymaps
  --       keymap = {
  --         preset = "default",
  --       },
  --       cmdline = {
  --         enabled = true,
  --         completion = {
  --           menu = {
  --             auto_show = true,
  --           },
  --         },
  --         sources = function()
  --           local type = vim.fn.getcmdtype()
  --           -- Search forward and backward
  --           if type == "/" or type == "?" then
  --             return { "buffer" }
  --           end
  --           -- Commands
  --           if type == ":" or type == "@" then
  --             return { "cmdline", "cmp_cmdline" }
  --           end
  --           return {}
  --         end,
  --       },
  --       fuzzy = {
  --         sorts = {
  --           "exact",
  --           -- defaults
  --           "score",
  --           "sort_text",
  --         },
  --       },
  --       signature = {
  --         enabled = true,
  --         window = {
  --           show_documentation = true,
  --         },
  --       },
  --       completion = {
  --         menu = {
  --           draw = {
  --             treesitter = { "lsp" },
  --             components = {
  --               label = {
  --                 text = function(ctx)
  --                   return require("colorful-menu").blink_components_text(ctx)
  --                 end,
  --                 highlight = function(ctx)
  --                   return require("colorful-menu").blink_components_highlight(
  --                     ctx
  --                   )
  --                 end,
  --               },
  --             },
  --           },
  --         },
  --         documentation = {
  --           auto_show = false,
  --         },
  --       },
  --       snippets = {
  --         preset = "luasnip",
  --         active = function(filter)
  --           local snippet = require("luasnip")
  --           local blink = require("blink.cmp")
  --           if snippet.in_snippet() and not blink.is_visible() then
  --             return true
  --           else
  --             if not snippet.in_snippet() and vim.fn.mode() == "n" then
  --               snippet.unlink_current()
  --             end
  --             return false
  --           end
  --         end,
  --       },
  --       sources = {
  --         default = { "lsp", "path", "snippets", "buffer", "omni" },
  --         providers = {
  --           path = {
  --             score_offset = 50,
  --           },
  --           lsp = {
  --             score_offset = 40,
  --           },
  --           snippets = {
  --             score_offset = 40,
  --           },
  --           cmp_cmdline = {
  --             name = "cmp_cmdline",
  --             module = "blink.compat.source",
  --             score_offset = -100,
  --             opts = {
  --               cmp_name = "cmdline",
  --             },
  --           },
  --         },
  --       },
  --     })
  --   end,
  -- },
  {
    "nvim-autopairs",
    for_cat = "general.completion",
    event = "BufEnter",
    after = function(plugin)
      require("nvim-autopairs").setup()
    end,
  },
  {
    "lspkind.nvim",
    for_cat = "general.completion",
    dep_for = { "care" },
    event = "BufEnter",
    after = function()
      require("lspkind").setup({
        mode = "symbol_text",
      })
    end,
  },
  {
    "luasnip",
    for_cat = "general.completion",
    dep_for = { "care" },
    event = "BufEnter",
    after = function(_)
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({})

      vim.keymap.set({ "i", "s" }, "<M-n>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end)
      vim.keymap.set({ "i", "s" }, "<M-p>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(-1)
        end
      end)
    end,
  },
  {
    "care",
    for_cat = "general.completion",
    event = "BufEnter",
    keys = {},
    after = function()
      require("care").setup({
        snippet_expansion = function(body)
          require("luasnip").lsp_expand(body)
        end,
        ui = {
          docs = {
            advanced_styling = true,
          },
          menu = {
            -- TODO: Add colorful-menu highlights
            -- format_entry = function(entry) end,
            scrollbar = {
              enabled = false,
            },
          },
          type_icons = "lspkind",
        },
      })

      local function map(keys, mapping, desc)
        vim.keymap.set("i", keys, mapping, { desc = desc })
      end

      -- Perform completion
      map("<C-Space>", function()
        require("care").api.complete()
      end, "Confirm completion")
      map("<C-y>", "<Plug>(CareConfirm)", "Confirm completion")
      map("<C-e>", "<Plug>(CareClose)", "Close completion")
      map("<C-n>", "<Plug>(CareSelectNext)", "Select next completion")
      map("<C-p>", "<Plug>(CareSelectPrev)", "Select previous completion")

      -- Documentation for current completion
      map("<C-k>", function()
        require("care").api.get_documentation()
      end)
      map("<C-f>", function()
        local care = require("care")
        if care.api.doc_is_open() then
          care.api.scroll_docs(4)
        else
          vim.api.nvim_feedkeys(vim.keycode("<c-f>"), "n", false)
        end
      end)
      map("<C-b>", function()
        local care = require("care")
        if care.api.doc_is_open() then
          care.api.scroll_docs(-4)
        else
          vim.api.nvim_feedkeys(vim.keycode("<c-b>"), "n", false)
        end
      end)
      map("<C-K>", function()
        local documentation = require("care").api.get_documentation()
        if #documentation == 0 then
          return
        end
        local old_win = vim.api.nvim_get_current_win()
        vim.cmd.wincmd("v")
        local buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].ft = "markdown"
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, documentation)
        vim.api.nvim_win_set_buf(0, buf)
        vim.api.nvim_set_current_win(old_win)
      end, "Open documentation in split")
    end,
  },
}
