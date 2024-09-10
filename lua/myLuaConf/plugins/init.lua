local colorschemeName = nixCats('colorscheme')
if not require('nixCatsUtils').isNixCats then
  colorschemeName = 'onedark'
end
vim.cmd.colorscheme(colorschemeName)

require('myLuaConf.plugins.telescope')

require('myLuaConf.plugins.treesitter')

require('myLuaConf.plugins.completion')

if nixCats('markdown') then
  vim.g.mkdp_auto_close = 0
  vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview <CR>', { noremap = true, desc = 'markdown preview' })
  vim.keymap.set('n', '<leader>ms', '<cmd>MarkdownPreviewStop <CR>', { noremap = true, desc = 'markdown preview stop' })
  vim.keymap.set('n', '<leader>mt', '<cmd>MarkdownPreviewToggle <CR>',
    { noremap = true, desc = 'markdown preview toggle' })

  require('markdown').setup({
    on_attach = function(bufnr)
      local map = vim.keymap.set
      local opts = { buffer = bufnr }
      map({ 'n', 'i' }, '<leader>ml', '<Cmd>MDListItemBelow<CR>', opts)
      map({ 'n', 'i' }, '<leader>mL', '<Cmd>MDListItemAbove<CR>', opts)
      map('n', '<leader>mc', '<Cmd>MDTaskToggle<CR>', opts)
      map('x', '<M-c>', ':MDTaskToggle<CR>', opts)
    end,
  })
  require('render-markdown').setup()
  require('zk').setup()

  -- Create a new note after asking for its title.
  vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
    {
      noremap = true,
      silent = false,
      desc = "New note (input title)",
    })

  -- Open notes.
  vim.keymap.set("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", {
    noremap = true,
    silent = false,
    desc = "Open notes",
  })
  -- Open notes associated with the selected tags.
  vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>", {
    noremap = true,
    silent = false,
    desc = "Search notes by tag",
  })

  -- Search for the notes matching a given query.
  vim.keymap.set("n", "<leader>zf",
    "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
    {
      noremap = true,
      silent = false,
      desc = "Search notes",
    })
  -- Search for the notes matching the current visual selection.
  vim.keymap.set("v", "<leader>zf", ":'<,'>ZkMatch<CR>", {
    noremap = true,
    silent = false,
    desc = "Search notes with selection",
  })
end

vim.keymap.set('n', '<leader>U', vim.cmd.UndotreeToggle, { desc = "Undo Tree" })
vim.g.undotree_WindowLayout = 1
vim.g.undotree_SplitWidth = 40

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

-- require('nvim-surround').setup()
require("mini.surround").setup()

-- indent-blank-line
require("ibl").setup()

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
    map('n', '<leader>gb', function()
      gs.blame_line { full = false }
    end, { desc = 'git blame line' })
    map('n', '<leader>gd', gs.diffthis, { desc = 'git diff against index' })
    map('n', '<leader>gD', function()
      gs.diffthis '~'
    end, { desc = 'git diff against last commit' })

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
    ["<C-s>"] = "actions.select_vsplit",
    ["<C-h>"] = "actions.select_split",
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
  { "<leader><leader>",  group = "buffer commands" },
  { "<leader><leader>_", hidden = true },
  { "<leader>c",         group = "[c]ode" },
  { "<leader>c_",        hidden = true },
  { "<leader>d",         group = "[d]ocument" },
  { "<leader>d_",        hidden = true },
  { "<leader>g",         group = "[g]it" },
  { "<leader>g_",        hidden = true },
  { "<leader>m",         group = "[m]arkdown" },
  { "<leader>m_",        hidden = true },
  { "<leader>r",         group = "[r]ename" },
  { "<leader>r_",        hidden = true },
  { "<leader>s",         group = "[s]earch" },
  { "<leader>s_",        hidden = true },
  { "<leader>t",         group = "[t]oggles" },
  { "<leader>t_",        hidden = true },
  { "<leader>w",         group = "[w]orkspace" },
  { "<leader>w_",        hidden = true },
  { "<leader>z",         group = "[z]k" },
  { "<leader>z_",        hidden = true },
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
vim.keymap.set("n", "-", function() require("yazi").yazi() end, { noremap = true, desc = 'Browse parent directory' })
vim.keymap.set("n", "<leader>-", function() require("yazi").yazi(nil, vim.fn.getcwd()) end,
  {
    noremap = true,
    desc = 'Browse current working directory'
  }
)

require('grug-far').setup({})
