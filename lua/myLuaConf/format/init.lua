local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    nix = { "alejandra" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
  },
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  })
end, { desc = "Format file" })
