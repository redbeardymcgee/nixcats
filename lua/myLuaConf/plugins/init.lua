local km = vim.keymap

local colorschemeName = nixCats('colorscheme')
if not require('nixCatsUtils').isNixCats then
  colorschemeName = 'onedark'
end
vim.cmd.colorscheme(colorschemeName)

require('myLuaConf.plugins.telescope')
require('myLuaConf.plugins.treesitter')
require('myLuaConf.plugins.completion')

require('zk').setup()
km.set("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
  { noremap = true, silent = false, desc = "New note (input title)", })

vim.g.undotree_WindowLayout = 1
vim.g.undotree_SplitWidth = 40
km.set('n', '<leader>U', vim.cmd.UndotreeToggle, { desc = "Undo Tree" })

require('hlargs').setup {
  color = '#32a88f',
}
vim.cmd([[hi clear @lsp.type.parameter]])
vim.cmd([[hi link @lsp.type.parameter Hlargs]])

require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = colorschemeName,
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_c = {
      {
        'filename', path = 1, status = true,
      },
    },
  },
  inactive_sections = {
    lualine_b = {
      {
        'filename', path = 3, status = true,
      },
    },
    lualine_x = { 'filetype' },
  },
  tabline = {
    lualine_a = { 'buffers' },
    -- if you use lualine-lsp-progress, I have mine here instead of fidget
    -- lualine_b = { 'lsp_progress', },
    lualine_z = { 'tabs' }
  },
})
require('fidget').setup({})

-- indent-blank-line
local highlight = {
  "CursorColumn",
  "Whitespace",
}
require("ibl").setup({

  indent = { highlight = highlight, char = "" },
  whitespace = {
    highlight = highlight,
    remove_blankline_trail = false,
  },
  scope = { enabled = true },
})

require('gitsigns').setup({
  -- See `:help gitsigns.txt`
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      km.set(mode, l, r, opts)
    end

    -- Navigation
    map({ 'n', 'v' }, ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end, { expr = true, desc = 'Jump to next hunk' })

    map({ 'n', 'v' }, '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end, { expr = true, desc = 'Jump to previous hunk' })

    -- Actions
    -- visual mode
    map('v', '<leader>hs', function()
      gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'stage git hunk' })
    map('v', '<leader>hr', function()
      gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'reset git hunk' })
    -- normal mode
    map('n', '<leader>gs', gs.stage_hunk, { desc = 'git stage hunk' })
    map('n', '<leader>gr', gs.reset_hunk, { desc = 'git reset hunk' })
    map('n', '<leader>gS', gs.stage_buffer, { desc = 'git Stage buffer' })
    map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
    map('n', '<leader>gR', gs.reset_buffer, { desc = 'git Reset buffer' })
    map('n', '<leader>gp', gs.preview_hunk, { desc = 'preview git hunk' })
    map('n', '<leader>gb', function() gs.blame_line { full = false } end, { desc = 'git blame line' })
    map('n', '<leader>gd', gs.diffthis, { desc = 'git diff against index' })
    map('n', '<leader>gD', function() gs.diffthis '~' end, { desc = 'git diff against last commit' })

    -- Toggles
    map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
    map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
  end,
})
vim.cmd([[hi GitSignsAdd guifg=#04de21]])
vim.cmd([[hi GitSignsChange guifg=#83fce6]])
vim.cmd([[hi GitSignsDelete guifg=#fa2525]])

require('which-key').setup({
})
require('which-key').add {
  {
    "<leader>b",
    group = "[b]uffer",
    proxy = "<leader><leader>",
    expand = function()
      return require("which-key.extras").expand.buf()
    end,
  },
  {
    "<leader>w",
    group = "[w]indows",
    proxy = "<c-w>",
    expand = function()
      return require("which-key.extras").expand.win()
    end,
  },
  { "<leader>c", group = "[c]ode" },
  { "<leader>d", group = "[d]ocument" },
  { "<leader>g", group = "[g]it" },
  { "<leader>m", group = "[m]arkdown" },
  { "<leader>r", group = "[r]ename" },
  { "<leader>s", group = "[s]earch" },
  { "<leader>t", group = "[t]oggles" },
  { "<leader>W", group = "[W]orkspace" },
  { "<leader>z", group = "[z]ettelkasten" },
  { "<leader>x", group = "debug" },
  { "[",         group = "prev" },
  { "]",         group = "next" },
  { "g",         group = "[g]oto" },
  { "gx",        desc = "Open with system app" },
  { "z",         group = "fold" },
  { "gs",        group = "surround" },
  { 'gsa',       desc = "Add surrounding in Normal and Visual modes" },
  { 'gsd',       desc = "Delete surrounding" },
  { 'gsf',       desc = "Find surrounding (to the right)" },
  { 'gsF',       desc = "Find surrounding (to the left)" },
  { 'gsh',       desc = "Highlight surrounding" },
  { 'gsr',       desc = "Replace surrounding" },
  { 'gsn',       desc = "Update `n_lines`" },
}

require('yazi').setup({
  open_multiple_tabs = true,
  open_for_directories = true,
  log_level = vim.log.levels.OFF,
})
km.set("n", "-", "<cmd>Yazi<cr>",
  {
    noremap = true,
    desc = 'Browse parent directory'
  }
)
km.set("n", "<leader>-", "<cmd>Yazi cwd<cr>",
  {
    noremap = true,
    desc = 'Browse current working directory'
  }
)

require('grug-far').setup()

local augend = require("dial.augend")
require("dial.config").augends:register_group {
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.decimal_int,
    augend.integer.alias.hex,
    augend.integer.alias.octal,
    augend.integer.alias.binary,
    augend.date.alias["%Y/%m/%d"],
    augend.date.alias["%m/%d/%Y"],
    augend.date.alias["%d/%m/%Y"],
    augend.date.alias["%m/%d/%y"],
    augend.date.alias["%d/%m/%y"],
    augend.date.alias["%m/%d"],
    augend.date.alias["%-m/%-d"],
    augend.date.alias["%Y-%m-%d"],
    augend.date.alias["%d.%m.%Y"],
    augend.date.alias["%d.%m.%y"],
    augend.date.alias["%d.%m."],
    augend.date.alias["%-d.%-m."],
    augend.date.alias["%H:%M:%S"],
    augend.date.alias["%H:%M"],
    augend.constant.alias.bool,
    augend.constant.alias.alpha,
    augend.constant.alias.Alpha,
    augend.semver.alias.semver,
  },
  typescript = {
    augend.constant.new { elements = { "let", "const" } },
  },
}
km.set("n", "<C-a>", function()
  require("dial.map").manipulate("increment", "normal")
end)
km.set("n", "<C-x>", function()
  require("dial.map").manipulate("decrement", "normal")
end)
km.set("n", "g<C-a>", function()
  require("dial.map").manipulate("increment", "gnormal")
end)
km.set("n", "g<C-x>", function()
  require("dial.map").manipulate("decrement", "gnormal")
end)
km.set("v", "<C-a>", function()
  require("dial.map").manipulate("increment", "visual")
end)
km.set("v", "<C-x>", function()
  require("dial.map").manipulate("decrement", "visual")
end)
km.set("v", "g<C-a>", function()
  require("dial.map").manipulate("increment", "gvisual")
end)
km.set("v", "g<C-x>", function()
  require("dial.map").manipulate("decrement", "gvisual")
end)

require("mini.surround").setup({
  mappings = {
    add = 'gsa',            -- Add surrounding in Normal and Visual modes
    delete = 'gsd',         -- Delete surrounding
    find = 'gsf',           -- Find surrounding (to the right)
    find_left = 'gsF',      -- Find surrounding (to the left)
    highlight = 'gsh',      -- Highlight surrounding
    replace = 'gsr',        -- Replace surrounding
    update_n_lines = 'gsn', -- Update `n_lines`
  },
})
require("mini.pairs").setup({
  modes = { insert = true, command = true, terminal = false },
  -- skip autopair when next character is one of these
  skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
  -- skip autopair when the cursor is inside these treesitter nodes
  skip_ts = { "string" },
  -- skip autopair when next character is closing pair
  -- and there are more closing pairs than opening pairs
  skip_unbalanced = true,
  -- better deal with markdown code blocks
  markdown = true,
})

require("todo-comments").setup()
km.set("n", "]t", function() require("todo-comments").jump_next() end,
  { noremap = true, silent = false, desc = "Next todo comment" })
km.set("n", "[t", function() require("todo-comments").jump_prev() end,
  { noremap = true, silent = false, desc = "Previous todo comment" })
km.set("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>",
  { noremap = true, silent = false, desc = "Todo (Trouble)" })
km.set("n", "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
  { noremap = true, silent = false, desc = "Todo/Fix/Fixme (Trouble)" })
km.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { noremap = true, silent = false, desc = "Todo" })
km.set("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
  { noremap = true, silent = false, desc = "Todo/Fix/Fixme" })

require("trouble").setup()
km.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",
  { noremap = true, silent = false, desc = "Diagnostics (Trouble)" })
km.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  { noremap = true, silent = false, desc = "Buffer Diagnostics (Trouble)" })
km.set("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>",
  { noremap = true, silent = false, desc = "Symbols (Trouble)" })
km.set("n", "<leader>cS", "<cmd>Trouble lsp toggle<cr>",
  { noremap = true, silent = false, desc = "LSP references/definitions/... (Trouble)" })
km.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>",
  { noremap = true, silent = false, desc = "Location List (Trouble)" })
km.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",
  { noremap = true, silent = false, desc = "Quickfix List (Trouble)" })

require("typescript-tools").setup({
  settings = {
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
      includeCompletionsForModuleExports = true,
      quotePreference = "auto",
    },
    tsserver_format_options = {
      allowIncompleteCompletions = false,
      allowRenameOfImportPath = false,
    }
  },
})

require("flash").setup({
  modes = {
    char = {
      jump_labels = true
    }
  }
})
km.set({ "n", "x", "o" }, "<C-f>", function() require("flash").treesitter() end, { desc = "Flash Treesitter", })
km.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

require("snacks").setup({
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      }
    }
})

-- vim.api.nvim_create_autocmd("User", {
--   pattern = "VeryLazy",
--   callback = function()
--     -- Setup some globals for debugging (lazy-loaded)
--     _G.dd = function(...)
--       Snacks.debug.inspect(...)
--     end
--     _G.bt = function()
--       Snacks.debug.backtrace()
--     end
--     vim.print = _G.dd -- Override print to use snacks for `:=` command
--
--     -- Create some toggle mappings
--     Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
--     Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
--     Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
--     Snacks.toggle.diagnostics():map("<leader>ud")
--     Snacks.toggle.line_number():map("<leader>ul")
--     Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
--     Snacks.toggle.treesitter():map("<leader>uT")
--     Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
--     Snacks.toggle.inlay_hints():map("<leader>uh")
--     Snacks.toggle.indent():map("<leader>ug")
--     Snacks.toggle.dim():map("<leader>uD")
--   end,
-- })

require('yanky').setup()
km.set({ "n", "x" }, "<leader>p",
  function()
    require("telescope").extensions.yank_history.yank_history()
  end,
  { desc = "Open Yank History" })
km.set({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank Text" })
km.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put Text After Cursor" })
km.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put Text Before Cursor" })
km.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Put Text After Selection" })
km.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Put Text Before Selection" })
km.set("n", "[y", "<Plug>(YankyCycleForward)", { desc = "Cycle Forward Through Yank History" })
km.set("n", "]y", "<Plug>(YankyCycleBackward)", { desc = "Cycle Backward Through Yank History" })
km.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put Indented After Cursor (Linewise)" })
km.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put Indented Before Cursor (Linewise)" })
km.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put Indented After Cursor (Linewise)" })
km.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put Indented Before Cursor (Linewise)" })
km.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)", { desc = "Put and Indent Right" })
km.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", { desc = "Put and Indent Left" })
km.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", { desc = "Put Before and Indent Right" })
km.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", { desc = "Put Before and Indent Left" })
km.set("n", "=p", "<Plug>(YankyPutAfterFilter)", { desc = "Put After Applying a Filter" })
km.set("n", "=P", "<Plug>(YankyPutBeforeFilter)", { desc = "Put Before Applying a Filter" })

require('multicursors').setup {
  hint_config = {
    float_opts = {
      border = 'rounded',
    },
    position = 'bottom-right',
  },
  generate_hints = {
    normal = true,
    insert = true,
    extend = true,
    config = {
      column_count = 1,
    },
  },
}
km.set("n", "<leader>mc", "<cmd>MCstart<cr>", { desc = "Multicursor" })
km.set("n", "<leader>mC", "<cmd>MCpattern<cr>", { desc = "Multicursor pattern" })
km.set("v", "<leader>mc", "<cmd>MCvisual<cr>", { desc = "Multicursor" })
km.set("v", "<leader>mC", "<cmd>MCvisualPattern<cr>", { desc = "Multicursor pattern" })

require("guess-indent").setup({})

local rainbow_delimiters = require 'rainbow-delimiters'
require('rainbow-delimiters.setup').setup {
  strategy = {
    [''] = rainbow_delimiters.strategy['local'],
    -- vim = rainbow_delimiters.strategy['local'],
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',

    query = function(bufnr)
      -- Use blocks for read-only buffers like in `:InspectTree`
      local is_nofile = vim.bo[bufnr].buftype == 'nofile'
      return is_nofile and 'rainbow-blocks' or 'rainbow-delimiters'
    end

  },
  priority = {
    [''] = 110,
    lua = 210,
  },
  highlight = {
    'RainbowDelimiterRed',
    'RainbowDelimiterYellow',
    'RainbowDelimiterBlue',
    'RainbowDelimiterOrange',
    'RainbowDelimiterGreen',
    'RainbowDelimiterViolet',
    'RainbowDelimiterCyan',
  },

}

require('ts_context_commentstring').setup {
  enable_autocmd = false,
}
require('Comment').setup {
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}

-- require('mini-animate').setup()
-- require('mini-align').setup()

-- require('image').setup()


