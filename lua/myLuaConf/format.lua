require("lze").load({
  {
    "conform.nvim",
    for_cat = "general.extra",
    event = { "BufWritePre" },
    keys = {
      {
        "<leader>ff",
        function()
          require("conform").format()
        end,
        mode = { "n", "v" },
        desc = "[F]ormat [F]ile",
      },
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
          javascriptreact = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
          json = { "prettierd", "prettier", stop_after_first = true },
          yaml = { "prettierd", "prettier", stop_after_first = true },
          bash = { "shfmt" },
          sh = { "shfmt" },
          fish = { "fish_indent" },
          markdown = { "prettierd", "prettier", stop_after_first = true },
          css = { "prettierd", "prettier", stop_after_first = true },
          html = { "prettierd", "prettier", stop_after_first = true },
          nix = { "alejandra", "nixfmt", stop_after_first = true },
        },
      })
    end,
  },
})
