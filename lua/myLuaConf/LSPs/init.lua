local catUtils = require("nixCatsUtils")
if catUtils.isNixCats and nixCats("lspDebugMode") then
  vim.lsp.set_log_level("debug")
end

-- NOTE: This file uses lzextras.lsp handler https://github.com/BirdeeHub/lzextras?tab=readme-ov-file#lsp-handler
-- This is a slightly more performant fallback function
-- for when you don't provide a filetype to trigger on yourself.
-- nixCats gives us the paths, which is faster than searching the rtp!
local old_ft_fallback = require("lze").h.lsp.get_ft_fallback()
require("lze").h.lsp.set_ft_fallback(function(name)
  local lspcfg = nixCats.pawsible({ "allPlugins", "opt", "nvim-lspconfig" })
    or nixCats.pawsible({ "allPlugins", "start", "nvim-lspconfig" })
  if lspcfg then
    local ok, cfg = pcall(dofile, lspcfg .. "/lsp/" .. name .. ".lua")
    if not ok then
      ok, cfg =
        pcall(dofile, lspcfg .. "/lua/lspconfig/configs/" .. name .. ".lua")
    end
    return (ok and cfg or {}).filetypes or {}
  else
    return old_ft_fallback(name)
  end
end)

-- NOTE: `jq` isn't a recognized filetype by default
-- but we have a language server that expects it
vim.cmd([[au BufRead,BufNewFile *.jq setfiletype jq]])

require("lze").load({
  {
    "nvim-lspconfig",
    for_cat = "general.always",
    on_require = { "lspconfig" },
    -- NOTE: define a function for lsp,
    -- and it will run for all specs with type(plugin.lsp) == table
    -- when their filetype trigger loads them
    lsp = function(plugin)
      vim.lsp.config(plugin.name, plugin.lsp or {})
      vim.lsp.enable(plugin.name)
    end,
    before = function(_)
      vim.lsp.config("*", {
        on_attach = require("myLuaConf.LSPs.on_attach"),
      })
    end,
  },
  {
    "mason.nvim",
    -- only run it when not on nix
    enabled = not catUtils.isNixCats,
    on_plugin = { "nvim-lspconfig" },
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("mason-lspconfig.nvim")
      require("mason").setup()
      require("mason-lspconfig").setup({ automatic_installation = true })
    end,
  },
  {
    "lazydev.nvim",
    for_cat = "lua",
    cmd = { "LazyDev" },
    ft = "lua",
    after = function(_)
      require("lazydev").setup({
        library = {
          {
            words = { "nixCats" },
            path = (nixCats.nixCatsPath or "") .. "/lua",
          },
        },
      })
    end,
  },
  {
    "otter.nvim",
    for_cat = "general.extra",
    keys = {
      {
        "<leader>cO",
        function()
          require("otter").activate()
        end,
        mode = { "n" },
        desc = "[O]tter",
      },
    },
    after = function()
      require("otter").setup({})
    end,
  },
  {
    "quadlet-lsp-nvim",
    for_cat = "general.extra",
    event = "BufEnter",
    after = function()
      require("quadlet-lsp").setup()
    end,
  },
  {
    "lua_ls",
    enabled = nixCats("lua"),
    lsp = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          formatters = {
            ignoreComments = true,
          },
          signatureHelp = { enabled = true },
          diagnostics = {
            globals = { "nixCats", "vim" },
            disable = { "missing-fields" },
          },
          telemetry = { enabled = false },
        },
      },
    },
  },
  {
    "stylua",
    enabled = nixCats("lua"),
    lsp = {},
  },
  {
    "mdx_analyzer",
    enabled = nixCats("markdown"),
    lsp = {
      init_options = {
        typescript = {
          enabled = true,
        },
      },
    },
  },
  {
    "marksman",
    enabled = nixCats("markdown"),
    lsp = {},
  },
  {
    "jsonls",
    enabled = nixCats("typescript"),
    lsp = {},
  },
  {
    "astro",
    enabled = nixCats("typescript"),
    lsp = {
      init_options = {
        typescript = {
          enabled = true,
        },
      },
    },
  },
  {
    "tailwindcss",
    enabled = nixCats("typescript"),
    for_cat = "typescript",
    lsp = {},
  },
  {
    "gopls",
    for_cat = "go",
    enabled = nixCats("go"),
    lsp = {},
  },
  {
    "rust_analyzer",
    enabled = nixCats("rust"),
    for_cat = "rust",
    lsp = {},
  },
  {
    "fish_lsp",
    enabled = nixCats("shell"),
    for_cat = "shell",
    lsp = {},
  },
  {
    "bashls",
    enabled = nixCats("shell"),
    for_cat = "shell",
    lsp = {},
  },
  {
    "html",
    enabled = nixCats("typescript"),
    for_cat = "typescript",
    lsp = {},
  },
  {
    "jqls",
    enabled = nixCats("general"),
    for_cat = "general",
    lsp = {},
  },
  {
    "scheme_langserver",
    enabled = nixCats("lisp"),
    for_cat = "lisp",
    lsp = {},
  },
  {
    "nixd",
    enabled = catUtils.isNixCats and nixCats("nix"),
    lsp = {
      settings = {
        nixd = {
          -- nixd requires some configuration.
          -- luckily, the nixCats plugin is here to pass whatever we need!
          -- we passed this in via the `extra` table in our packageDefinitions
          -- for additional configuration options, refer to:
          -- https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
          nixpkgs = {
            -- in the extras set of your package definition:
            -- nixdExtras.nixpkgs = ''import ${pkgs.path} {}''
            expr = nixCats.extra("nixdExtras.nixpkgs")
              or [[import <nixpkgs> {}]],
          },
          options = {
            -- If you integrated with your system flake,
            -- you should use inputs.self as the path to your system flake
            -- that way it will ALWAYS work, regardless
            -- of where your config actually was.
            nixos = {
              -- nixdExtras.nixos_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").nixosConfigurations.configname.options''
              expr = nixCats.extra("nixdExtras.nixos_options"),
            },
            -- If you have your config as a separate flake, inputs.self would be referring to the wrong flake.
            -- You can override the correct one into your package definition on import in your main configuration,
            -- or just put an absolute path to where it usually is and accept the impurity.
            ["home-manager"] = {
              -- nixdExtras.home_manager_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").homeConfigurations.configname.options''
              expr = nixCats.extra("nixdExtras.home_manager_options"),
            },
          },
          formatting = {
            command = { "alejandra" },
          },
          diagnostic = {
            suppress = {
              "sema-escaping-with",
            },
          },
        },
      },
    },
  },
})
