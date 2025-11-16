return {
  {
    "markdown-preview.nvim",
    -- NOTE: for_cat is a custom handler that just sets enabled value for us,
    -- based on result of nixCats('cat.name') and allows us to set a different default if we wish
    -- it is defined in luaUtils template in lua/nixCatsUtils/lzUtils.lua
    -- you could replace this with enabled = nixCats('cat.name') == true
    -- if you didnt care to set a different default for when not using nix than the default you already set
    for_cat = "markdown",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = "markdown",
    keys = {
      {
        "<leader>mp",
        "<cmd>MarkdownPreview <CR>",
        mode = { "n" },
        noremap = true,
        desc = "markdown preview",
      },
      {
        "<leader>ms",
        "<cmd>MarkdownPreviewStop <CR>",
        mode = { "n" },
        noremap = true,
        desc = "markdown preview stop",
      },
      {
        "<leader>mt",
        "<cmd>MarkdownPreviewToggle <CR>",
        mode = { "n" },
        noremap = true,
        desc = "markdown preview toggle",
      },
    },
    before = function(plugin)
      vim.g.mkdp_auto_close = 0
    end,
  },
  {
    "render-markdown.nvim",
    for_cat = "markdown",
    ft = { "markdown", "mdx" },
    after = function(plugin)
      require("render-markdown").setup({
        completions = { lsp = { enabled = true } },
        file_types = { "markdown", "mdx" },
      })
    end,
  },
  {
    "mdx-nvim",
    for_cat = "markdown",
    event = "BufEnter *.mdx",
    after = function()
      require("mdx").setup()
    end,
  },
}
