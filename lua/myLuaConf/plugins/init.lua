local colorschemeName = nixCats('colorscheme')
if not require('nixCatsUtils').isNixCats then
  colorschemeName = 'onedark'
end
vim.cmd.colorscheme(colorschemeName)

require('myLuaConf.plugins.telescope')
require('myLuaConf.plugins.treesitter')
require('myLuaConf.plugins.completion')

require('zk').setup()
vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
  { noremap = true, silent = false, desc = "New note (input title)", })
vim.keymap.set("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
  { noremap = true, silent = false, desc = "Open notes", })
vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>", { noremap = true, silent = false, desc = "Search notes by tag", })
vim.keymap.set("n", "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
  { noremap = true, silent = false, desc = "Search notes", })
vim.keymap.set("v", "<leader>zf", ":'<,'>ZkMatch<CR>",
  { noremap = true, silent = false, desc = "Search notes with selection", })

vim.g.undotree_WindowLayout = 1
vim.g.undotree_SplitWidth = 40
vim.keymap.set('n', '<leader>U', vim.cmd.UndotreeToggle, { desc = "Undo Tree" })

-- require('hlargs').setup {
--   color = '#32a88f',
-- }
-- vim.cmd([[hi clear @lsp.type.parameter]])
-- vim.cmd([[hi link @lsp.type.parameter Hlargs]])
require('Comment').setup()
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
      vim.keymap.set(mode, l, r, opts)
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

require("oil").setup({
  columns = {
    "icon",
    "permissions",
    "size",
    -- "mtime",
  },
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-s>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },
})
vim.keymap.set("n", "_", "<cmd>Oil<CR>", { noremap = true, desc = 'Edit parent directory' })
vim.keymap.set("n", "<leader>_", "<cmd>Oil .<CR>", { noremap = true, desc = 'Edit current working directory' })

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
  { "z",         group = "Fold" },
  { "gs",        group = "Surround" },
  { 'gsa',       desc = "Add surrounding in Normal and Visual modes" },
  { 'gsd',       desc = "Delete surrounding" },
  { 'gsf',       desc = "Find surrounding (to the right)" },
  { 'gsF',       desc = "Find surrounding (to the left)" },
  { 'gsh',       desc = "Highlight surrounding" },
  { 'gsr',       desc = "Replace surrounding" },
  { 'gsn',       desc = "Update `n_lines`" },
  { 'l',         desc = "Suffix to search with 'prev' method" },
  { 'n',         desc = "Suffix to search with 'next' method" },
}

require('yazi').setup({
  -- open_for_directories = true,
  -- open_multiple_tabs = true,

  -- use_ya_for_events_reading = true,
  -- highlight_groups = {
  --   hovered_buffer_background = { bg = "#363a4f" },
  -- },
  -- hovered_buffer_in_same_directory = nil,
})
vim.keymap.set("n", "-",
  function()
    require("yazi").yazi()
  end,
  {
    noremap = true,
    desc = 'Browse parent directory'
  }
)
vim.keymap.set("n", "<leader>-",
  function()
    require("yazi").yazi(nil, vim.fn.getcwd())
  end,
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

require("mini.surround").setup({
  mappings = {
    add = 'gsa',            -- Add surrounding in Normal and Visual modes
    delete = 'gsd',         -- Delete surrounding
    find = 'gsf',           -- Find surrounding (to the right)
    find_left = 'gsF',      -- Find surrounding (to the left)
    highlight = 'gsh',      -- Highlight surrounding
    replace = 'gsr',        -- Replace surrounding
    update_n_lines = 'gsn', -- Update `n_lines`

    suffix_last = 'l',      -- Suffix to search with "prev" method
    suffix_next = 'n',      -- Suffix to search with "next" method
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
vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end,
  { noremap = true, silent = false, desc = "Next todo comment" })
vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end,
  { noremap = true, silent = false, desc = "Previous todo comment" })
vim.keymap.set("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>",
  { noremap = true, silent = false, desc = "Todo (Trouble)" })
vim.keymap.set("n", "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
  { noremap = true, silent = false, desc = "Todo/Fix/Fixme (Trouble)" })
vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { noremap = true, silent = false, desc = "Todo" })
vim.keymap.set("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
  { noremap = true, silent = false, desc = "Todo/Fix/Fixme" })

require("trouble").setup()
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",
  { noremap = true, silent = false, desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  { noremap = true, silent = false, desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle<cr>",
  { noremap = true, silent = false, desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>cS", "<cmd>Trouble lsp toggle<cr>",
  { noremap = true, silent = false, desc = "LSP references/definitions/... (Trouble)" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>",
  { noremap = true, silent = false, desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",
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
vim.keymap.set({ "n", "x", "o" }, "<C-f>", function() require("flash").treesitter() end, { desc = "Flash Treesitter", })
vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { noremap = true, silent = false, desc = "Lazygit" })
vim.keymap.set("n", "<leader>gf", "<cmd>LazyGitFilterCurrentFile<cr>",
  { noremap = true, silent = false, desc = "Lazygit filter current file" })

require('yanky').setup()
vim.keymap.set({ "n", "x" }, "<leader>p",
  function()
    require("telescope").extensions.yank_history.yank_history()
  end,
  { desc = "Open Yank History" })
vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank Text" })
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put Text After Cursor" })
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put Text Before Cursor" })
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Put Text After Selection" })
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Put Text Before Selection" })
vim.keymap.set("n", "[y", "<Plug>(YankyCycleForward)", { desc = "Cycle Forward Through Yank History" })
vim.keymap.set("n", "]y", "<Plug>(YankyCycleBackward)", { desc = "Cycle Backward Through Yank History" })
vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put Indented After Cursor (Linewise)" })
vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put Indented Before Cursor (Linewise)" })
vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put Indented After Cursor (Linewise)" })
vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put Indented Before Cursor (Linewise)" })
vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)", { desc = "Put and Indent Right" })
vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", { desc = "Put and Indent Left" })
vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", { desc = "Put Before and Indent Right" })
vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", { desc = "Put Before and Indent Left" })
vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)", { desc = "Put After Applying a Filter" })
vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)", { desc = "Put Before Applying a Filter" })

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
vim.keymap.set("n", "<c-d>", "<cmd>MCstart<cr>", { desc = "Multicursor" })
vim.keymap.set("n", "g<c-d>", "<cmd>MCpattern<cr>", { desc = "Multicursor pattern" })
vim.keymap.set("v", "<c-d>", "<cmd>MCvisual<cr>", { desc = "Multicursor" })
vim.keymap.set("v", "g<c-d>", "<cmd>MCvisualPattern<cr>", { desc = "Multicursor pattern" })

require("guess-indent").setup()

}
