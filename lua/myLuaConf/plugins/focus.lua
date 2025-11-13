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
      require("twilight").setup()
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
