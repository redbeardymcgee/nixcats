require("lze").load({
  {
    "nvim-lint",
    for_cat = "general.extra",
    event = "BufEnter",
    after = function(plugin)
      local lint = require("lint")
      lint.linters_by_ft = {
        markdown = { "eslint" },
        javascript = { "eslint" },
        typescript = { "eslint" },
        json = { "eslint" },
        jsonc = { "eslint" },
        json5 = { "eslint" },
        astro = { "eslint" },
        fish = { "fish" },
        nix = { "nix" },
        yaml = { "yq" },
        bash = { "shellcheck" },
        sh = { "shellcheck" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
})
