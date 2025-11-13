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
      -- Convert the cwd to a simple file name
      local function get_cwd_as_name()
        local dir = vim.fn.getcwd(0)
        return dir:gsub("[^A-Za-z0-9]", "_")
      end

      local overseer = require("overseer")
      require("auto-session").setup({
        pre_save_cmds = {
          function()
            overseer.save_task_bundle(
              get_cwd_as_name(),
              -- Passing nil will use config.opts.save_task_opts. You can call list_tasks() explicitly and
              -- pass in the results if you want to save specific tasks.
              nil,
              { on_conflict = "overwrite" } -- Overwrite existing bundle, if any
            )
          end,
        },
        -- Optionally get rid of all previous tasks when restoring a session
        pre_restore_cmds = {
          function()
            for _, task in ipairs(overseer.list_tasks({})) do
              task:dispose(true)
            end
          end,
        },
        post_restore_cmds = {
          function()
            overseer.load_task_bundle(
              get_cwd_as_name(),
              { ignore_missing = true }
            )
          end,
        },
      })
      overseer.setup({
        strategy = {
          use_shell = true,
        },
      })
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
      })

      function _lazygit_toggle()
        lazygit:toggle()
      end
    end,
  },
}
