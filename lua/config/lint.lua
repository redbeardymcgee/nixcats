require("lze").load({
  {
    "nvim-lint",
    for_cat = "general.extra",
    event = "BufEnter",
    after = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        astro = { "biomejs" },
        bash = { "shellcheck" },
        css = { "biomejs" },
        fish = { "fish" },
        html = { "biomejs", "alex" },
        -- TODO: Set up vale
        -- markdown = { "vale", "alex" },
        markdown = { "alex" },
        mdx = { "alex" },
        javascript = { "biomejs" },
        javascriptreact = { "biomejs" },
        jq = { "jq" },
        json = { "biomejs" },
        json5 = { "biomejs" },
        jsonc = { "biomejs" },
        lua = { "luac" },
        nix = { "nix" },
        sh = { "shellcheck" },
        svelte = { "biomejs" },
        typescript = { "biomejs" },
        typescriptreact = { "biomejs" },
        vue = { "biomejs" },
        yaml = { "yamllint" },
      }

      lint.linters.biomejs.cmd = "biome"

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
})
