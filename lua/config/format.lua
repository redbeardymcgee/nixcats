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
          astro = { "biome-check" },
          bash = { "shfmt" },
          css = { "biome-check" },
          fish = { "fish_indent" },
          go = { "gofmt", "golint" },
          html = { "biome-check" },
          javascript = { "biome-check" },
          javascriptreact = { "biome-check" },
          json = { "biome-check" },
          lua = { "stylua" },
          -- markdown = { "prettierd", "prettier", stop_after_first = true },
          nix = { "alejandra", "nixfmt", stop_after_first = true },
          sh = { "shfmt" },
          templ = { "templ" },
          typescript = { "biome-check" },
          typescriptreact = { "biome-check" },
          yaml = { "yq" },
        },
        formatters = {
          biome = {
            command = "biome",
          },
        },
      })
    end,
  },
})
