local km = vim.keymap

vim.g.loaded_netrwPlugin = 1
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    require("yazi").setup({
      open_multiple_tabs = true,
      open_for_directories = true,

      highlight_groups = {
        hovered_buffer = true
      },

      -- log_level = vim.log.levels.OFF,
    })
  end,
})

km.set("n", "<leader>ff", "<cmd>Yazi<cr>",
  {
    noremap = true,
    desc = 'Browse parent directory'
  }
)

km.set("n", "<leader>fc", "<cmd>Yazi cwd<cr>",
  {
    noremap = true,
    desc = 'Browse current working directory'
  }
)

km.set("n", "<leader>ft", "<cmd>Yazi toggle<cr>",
  {
    noremap = true,
    desc = 'Toggle yazi'
  }
)
