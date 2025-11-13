return {
  {
    "ts-comments.nvim",
    for_cat = "general.extra",
    event = "BufEnter",
    after = function(plugin)
      require("ts-comments").setup()
    end,
  },
  {
    "todo-comments.nvim",
    for_cat = "general.extra",
    event = "BufEnter",
    keys = {
      {
        "<leader>st",
        "<cmd>:TodoTelescope<cr>",
        mode = { "n" },
        desc = "[S]earch [t]odos",
      },
      {
        "<leader>xt",
        "<cmd>:TodoQuickFix<cr>",
        mode = { "n" },
        desc = "Todo QuickFix",
      },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        mode = { "n" },
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        mode = { "n" },
        desc = "Previous todo comment",
      },
    },
    after = function(plugin)
      require("todo-comments").setup()
    end,
  },
}
