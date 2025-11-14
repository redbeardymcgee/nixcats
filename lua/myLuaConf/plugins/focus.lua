return {
  {
    "twilight.nvim",
    for_cat = "general.extra",
    event = "BufEnter",
    keys = {
      {
        "<leader>zt",
        "<cmd>Twilight<cr>",
        desc = "Toggle Twilight",
      },
    },
    after = function()
      require("twilight").setup({
        expand = {
          "class_definition",
          "for_statement",
          "function",
          "function_declaration",
          "function_definition",
          "if_expression",
          "if_statement",
          "method",
          "table",
          "while_statement",
        },
      })
    end,
  },
  {
    "zen-mode.nvim",
    for_cat = "general.extra",
    keys = {
      {
        "<leader>zz",
        function()
          require("zen-mode").toggle()
        end,
        desc = "Zen Toggle",
      },
    },
    after = function()
      require("zen-mode").setup({
        plugins = {
          tmux = {
            enabled = false, -- fails to restore statusline
          },
        },
      })
    end,
  },
}
