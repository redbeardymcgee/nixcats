local colorschemeName = nixCats("colorscheme")
if not require("nixCatsUtils").isNixCats then
  colorschemeName = "onedark"
end
-- Could I lazy load on colorscheme with lze?
-- sure. But I was going to call vim.cmd.colorscheme() during startup anyway
-- this is just an example, feel free to do a better job!
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

-- auto-session
vim.o.sessionoptions =
  "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
require("auto-session").setup({
  allowed_dirs = {
    "~/src/redbeardymcgee/*",
    "~/src/forks/*",
  },
  suppressed_dirs = {
    "~/src/redbeardymcgee/leetcode",
  },
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

if nixCats("general.extra") then
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
  -- Exclude whitespace and the middle of alphabetic words from preview:
  --   foobar[baaz] = quux
  --   ^----^^^--^^-^-^--^
  require("leap").opts.preview = function(ch0, ch1, ch2)
    return not (
      ch1:match("%s")
      or (ch0:match("%a") and ch1:match("%a") and ch2:match("%a"))
    )
  end

  -- Define equivalence classes for brackets and quotes, in addition to
  -- the default whitespace group:
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
  { import = "myLuaConf.plugins.comments" },
  { import = "myLuaConf.plugins.completion" },
  { import = "myLuaConf.plugins.edit" },
  { import = "myLuaConf.plugins.focus" },
  { import = "myLuaConf.plugins.leetcode" },
  { import = "myLuaConf.plugins.markdown" },
  { import = "myLuaConf.plugins.tasks" },
  { import = "myLuaConf.plugins.telescope" },
  { import = "myLuaConf.plugins.treesitter" },
  { import = "myLuaConf.plugins.typescript" },
  { import = "myLuaConf.plugins.ui" },
  {
    "aoc.nvim",
    for_cat = "general.extra",
    cmd = {
      "AocGetPuzzleInput",
      "AocGetTodayPuzzleInput",
      "AocClearCache",
      "AocInspectConfig",
      "AocReloadSessionToken",
    },
    after = function()
      require("aoc").setup({
        session_filepath = vim.fn.expand(
          "~/src/redbeardymcgee/aoc/session.txt"
        ),
      })
    end,
  },
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
    -- cmd = { "" },
    event = "DeferredUIEnter",
    -- ft = "",
    -- keys = "",
    -- colorscheme = "",
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
        { "<leader>d", group = "[d]ocument" },
        { "<leader>d_", hidden = true },
        { "<leader>g", group = "[g]it" },
        { "<leader>g_", hidden = true },
        { "<leader>m", group = "[m]arkdown" },
        { "<leader>m_", hidden = true },
        { "<leader>r", group = "[r]ename" },
        { "<leader>r_", hidden = true },
        { "<leader>s", group = "[s]earch" },
        { "<leader>s_", hidden = true },
        { "<leader>t", group = "[t]asks" },
        { "<leader>t_", hidden = true },
        { "<leader>W", group = "[W]orkspace" },
        { "<leader>W_", hidden = true },
        { "<leader>x", group = "Debug" },
        { "<leader>x_", hidden = true },
        {
          "<leader>w",
          function()
            return require("which-key").show({
              keys = "<c-w>",
              loop = true,
            })
          end,
          group = "[w]indows",
        },
        { "<leader>w_", hidden = true },
      })
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
    "nvim-colorizer-lua",
    for_cat = "general.extra",
    event = "BufReadPre",
    after = function()
      require("colorizer").setup({
        lazy_load = true,
        names_opts = {
          uppercase = true,
        },
        css = true,
        tailwind = "both",
        tailwind_opts = {
          update_names = true,
        },
        xterm = true,
      })
    end,
  },
})
