require("lze").load({
  {
    "conform.nvim",
    for_cat = "general.extra",
    keys = {
      { "<leader>ff", desc = "[F]ormat [F]ile" },
    },
    after = function(plugin)
      local conform = require("conform")

      conform.setup({
        format_after_save = {
          async = true,
          lsp_format = "fallback",
        },
        formatters_by_ft = {
          -- NOTE: download some formatters in lspsAndRuntimeDeps
          -- and configure them here
          lua = { "stylua" },
          go = { "gofmt", "golint" },
          templ = { "templ" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          nix = { "alejandra", "nixfmt", stop_after_first = true },
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>ff", function()
        conform.format()
      end, { desc = "[F]ormat [F]ile" })
    end,
  },
})
