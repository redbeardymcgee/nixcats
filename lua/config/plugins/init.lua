local colorschemeName = nixCats("colorscheme")
if not require("nixCatsUtils").isNixCats then
  colorschemeName = "onedark"
end
-- Could I lazy load on colorscheme with lze?
-- sure. But I was going to call vim.cmd.colorscheme() during startup anyway
-- this is only an example, feel free to do a better job!
vim.cmd.colorscheme(colorschemeName)

local ok, notify = pcall(require, "notify")
if ok then
  notify.setup({
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { focusable = false })
    end,
  })
  vim.notify = notify
  vim.keymap.set("n", "<Esc>", function()
    notify.dismiss({ silent = true })
    vim.cmd("nohlsearch")
  end, { desc = "dismiss notify popup and clear hlsearch" })
end

require("direnv").setup({
  autoload_direnv = true,
  statusline = {
    enabled = true,
  },
  keybindings = {
    allow = "<leader>cda",
    deny = "<leader>cdd",
    reload = "<leader>cdr",
    edit = "<leader>cde",
  },
})

require("smart-splits").setup({
  ignored_filetypes = {
    "fyler",
  },
  log_level = "trace",
})
vim.keymap.set({ "n", "i" }, "<C-A-h>", require("smart-splits").resize_left)
vim.keymap.set({ "n", "i" }, "<C-A-j>", require("smart-splits").resize_down)
vim.keymap.set({ "n", "i" }, "<C-A-k>", require("smart-splits").resize_up)
vim.keymap.set({ "n", "i" }, "<C-A-l>", require("smart-splits").resize_right)
vim.keymap.set({ "n", "i" }, "<A-h>", require("smart-splits").move_cursor_left)
vim.keymap.set({ "n", "i" }, "<A-j>", require("smart-splits").move_cursor_down)
vim.keymap.set({ "n", "i" }, "<A-k>", require("smart-splits").move_cursor_up)
vim.keymap.set({ "n", "i" }, "<A-l>", require("smart-splits").move_cursor_right)
vim.keymap.set(
  { "n", "i" },
  "<A-\\>",
  require("smart-splits").move_cursor_previous
)
vim.keymap.set({ "n", "i" }, "<A-H>", require("smart-splits").swap_buf_left)
vim.keymap.set({ "n", "i" }, "<A-J>", require("smart-splits").swap_buf_down)
vim.keymap.set({ "n", "i" }, "<A-K>", require("smart-splits").swap_buf_up)
vim.keymap.set({ "n", "i" }, "<A-L>", require("smart-splits").swap_buf_right)

if nixCats("general.extra") then
  -- Dashboard
  require("dashboard").setup({
    theme = "hyper",
    config = {
      week_header = {
        enable = true,
      },
      shortcut = {
        {
          key = "L",
          group = "DiagnosticHint",
          action = "Leet",
          desc = "Leetcode",
        },
        {
          key = "S",
          group = "@property",
          action = "AutoSession search",
          desc = "Sessions",
        },
      },
    },
  })

  -- AutoSession
  vim.o.sessionoptions =
    "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  require("auto-session").setup({
    auto_create = function()
      local cmd = "git rev-parse --show-cdup"
      return vim.fn.system(cmd) == "\n"
    end,
    bypass_save_filetypes = { "dashboard" },
  })

  vim.keymap.set(
    "n",
    "<leader>Ss",
    "<cmd>AutoSession search<CR>",
    { desc = "Session search" }
  )

  vim.keymap.set(
    "n",
    "<leader>SS",
    "<cmd>AutoSession save<CR>",
    { desc = "Save session" }
  )

  -- require("systemd")

  -- Fyler
  vim.g.loaded_netrwPlugin = 1
  local fyler = require("fyler")

  fyler.setup({
    integrations = {
      icon = "nvim_web_devicons",
    },
    views = {
      finder = {
        default_explorer = true,
        delete_to_trash = true,
        watcher = {
          enabled = true,
        },
      },
    },
  })

  vim.keymap.set("n", "-", function()
    fyler.toggle({
      kind = "split_left_most",
    })
  end, { noremap = true, desc = "Open parent directory" })

  vim.keymap.set("n", "<leader>-", function()
    fyler.toggle({
      kind = "split_left_most",
      dir = vim.fn.getcwd(),
    })
  end, { noremap = true, desc = "Open working directory" })

  -- leap.nvim
  vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
  vim.keymap.set("n", "S", "<Plug>(leap-from-window)")

  -- Highly recommended: define a preview filter to reduce visual noise
  -- and the blinking effect after the first keypress
  -- (`:h leap.opts.preview`). You can still target any visible
  -- positions if needed, but you can define what is considered an
  -- exceptional case.
  -- Exclude blank space and the middle of alphabetic words from preview:
  --   foobar[baaz] = quux
  --   ^----^^^--^^-^-^--^
  require("leap").opts.preview = function(ch0, ch1, ch2)
    return not (
      ch1:match("%s")
      or (ch0:match("%a") and ch1:match("%a") and ch2:match("%a"))
    )
  end

  -- Define equivalence classes for brackets and quotes, in addition to
  -- the default blank space group:
  require("leap").opts.equivalence_classes = {
    " \t\r\n",
    "([{",
    ")]}",
    "'\"`",
  }

  -- Use the traversal keys to repeat the previous motion without
  -- explicitly invoking Leap:
  require("leap.user").set_repeat_keys("<enter>", "<backspace>")

  -- Firenvim
  vim.g.firenvim_config = {
    globalSettings = {
      alt = "all",
      cmdlineTimeout = 3000,
    },
    localSettings = {
      -- NOTE: These are js patterns, not lua
      [".*"] = {
        cmdline = "firenvim",
        content = "text",
        priority = 0,
        selector = "textarea",
        takeover = "always", -- TODO: fix lounge regex, set this back to always
      },
      ["https?://lounge[.]mcgee[.]red/.*"] = {
        takeover = "never",
        priority = 1,
      },
    },
  }

  vim.api.nvim_create_autocmd({ "UIEnter" }, {
    callback = function(event)
      local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
      if client ~= nil and client.name == "Firenvim" then
        vim.o.laststatus = 0
        vim.g.auto_session_enabled = false
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "github.com_*.txt",
    command = "set filetype=markdown",
  })

  require("helpview").setup({
    preview = {
      icon_provider = "devicons",
    },
  })
end

require("lze").load({
  { import = "config.plugins.comments" },
  { import = "config.plugins.completion" },
  { import = "config.plugins.edit" },
  { import = "config.plugins.focus" },
  { import = "config.plugins.leetcode" },
  { import = "config.plugins.markdown" },
  { import = "config.plugins.tasks" },
  { import = "config.plugins.telescope" },
  { import = "config.plugins.treesitter" },
  { import = "config.plugins.typescript" },
  { import = "config.plugins.ui" },
  {
    "vim-startuptime",
    for_cat = "general.extra",
    cmd = { "StartupTime" },
    before = function(_)
      vim.g.startuptime_event_width = 0
      vim.g.startuptime_tries = 10
      vim.g.startuptime_exe_path = nixCats.packageBinPath
    end,
  },
  {
    "which-key.nvim",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("which-key").setup({})
      require("which-key").add({
        { "<leader><leader>", group = "buffer commands" },
        { "<leader><leader>_", hidden = true },
        {
          "<leader>b",
          group = "[b]uffers",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        { "<leader>b_", hidden = true },
        { "<leader>c", group = "[c]ode" },
        { "<leader>c_", hidden = true },
        { "<leader>cd", group = "[d]irenv" },
        { "<leader>cd_", hidden = true },
        { "<leader>d", group = "[d]ocument" },
        { "<leader>d_", hidden = true },
        { "<leader>f", group = "[f]ile" },
        { "<leader>f_", hidden = true },
        { "<leader>g", group = "[g]it" },
        { "<leader>g_", hidden = true },
        { "<leader>m", group = "[m]arkdown" },
        { "<leader>m_", hidden = true },
        { "<leader>n", group = "[n]otifications" },
        { "<leader>n_", hidden = true },
        { "<leader>cr", group = "[r]ename" },
        { "<leader>cr_", hidden = true },
        { "<leader>s", group = "[s]earch" },
        { "<leader>s_", hidden = true },
        { "<leader>S", group = "[S]essions" },
        { "<leader>S_", hidden = true },
        { "<leader>t", group = "[t]asks" },
        { "<leader>t_", hidden = true },
        { "<leader>W", group = "[W]orkspace" },
        { "<leader>W_", hidden = true },
        { "<leader>x", group = "Debug" },
        { "<leader>x_", hidden = true },
        { "<leader>z", group = "[z]en" },
        { "<leader>z_", hidden = true },
      })
    end,
  },
})
