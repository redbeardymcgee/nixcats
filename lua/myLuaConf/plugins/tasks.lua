return {
  {
    "overseer.nvim",
    for_cat = "general.extra",
    cmd = {
      "OverseerOpen",
      "OverseerRun",
      "OverseerShell",
      "OverseerTaskAction",
      "OverseerToggle",
    },
    keys = {
      {
        "<leader>tr",
        "<cmd>OverseerRun<cr>",
        desc = "[T]ask [R]unner",
      },
      {
        "<leader>ts",
        "<cmd>OverseerShell<cr>",
        desc = "[T]ask [S]hell",
      },
      {
        "<leader>tt",
        "<cmd>OverseerToggle<cr>",
        desc = "[T]ask [T]oggle",
      },
    },
    after = function()
      require("overseer").setup()
    end,
  },
  {
    "toggleterm.nvim",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    keys = {
      {
        "<leader>gg",
        "<cmd>lua _lazygit_toggle()<cr>",
        mode = { "n", "t" },
        desc = "Toggle lazygit",
      },
    },
    after = function(plugin)
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return math.floor(vim.o.lines * 0.4)
          elseif term.direction == "vertical" then
            return math.floor(vim.o.columns * 0.4)
          end
        end,
        open_mapping = [[<c-\>]],
        direction = "vertical",
        float_opts = {
          border = "curved",
          width = math.floor(vim.o.columns * 0.8),
          height = math.floor(vim.o.lines * 0.8),
          title_pos = "center",
        },
      })

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<A-esc>", [[<C-\><C-n>]], opts)
        -- vim.keymap.set("t", "<A-h>", [[<Cmd>wincmd h<CR>]], opts)
        -- vim.keymap.set("t", "<A-j>", [[<Cmd>wincmd j<CR>]], opts)
        -- vim.keymap.set("t", "<A-k>", [[<Cmd>wincmd k<CR>]], opts)
        -- vim.keymap.set("t", "<A-l>", [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end

      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "curved",
          width = math.floor(vim.o.columns * 0.8),
          height = math.floor(vim.o.lines * 0.8),
          title_pos = "center",
        },
      })

      function _lazygit_toggle()
        lazygit:toggle()
      end
    end,
  },
}
