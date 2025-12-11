local load_w_after = function(name)
  vim.cmd.packadd(name)
  vim.cmd.packadd(name .. "/after")
end

return {
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
        symbol_map = {
          TypeParameter = "",
        },
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
        debug = true,
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
