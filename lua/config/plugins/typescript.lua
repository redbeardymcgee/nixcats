return {
  {
    "typescript-tools.nvim",
    for_cat = "typescript",
    ft = {
      "typescript",
      "typescriptreact",
      "javascript",
      "javascriptreact",
    },
    after = function()
      require("typescript-tools").setup({})
    end,
  },
}
