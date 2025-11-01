local km = vim.keymap

if os.getenv('WAYLAND_DISPLAY') and vim.fn.executable('wl-copy') then
  vim.g.clipboard = {
    name = 'wl-clipboard',
    copy = {
      ['+'] = 'wl-copy',
      ['*'] = 'wl-copy',
    },
    paste = {
      ['+'] = 'wl-paste',
      ['*'] = 'wl-paste',
    },
    cache_enabled = 1,
  }
end

-- [[ Setting options ]]
-- See `:help vim.o`

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Set highlight on search
vim.opt.hlsearch = true
km.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Indent
vim.o.smarttab = true
-- NOTE: if you dont append to the previous cpoptions, which-key will throw many errors
vim.o.cpoptions = (vim.o.cpoptions or '') .. 'I'
vim.o.expandtab = true

-- stops line wrapping from being confusing
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'
vim.wo.relativenumber = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,preview,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Disable auto comment on enter ]]
-- See :help formatoptions
vim.api.nvim_create_autocmd("FileType", {
  desc = "remove formatoptions",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help km.set()`
km.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Moves Line Down' })
km.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Moves Line Up' })
km.set("n", "<C-d>", "<C-d>zz", { desc = 'Scroll Down' })
km.set("n", "<C-u>", "<C-u>zz", { desc = 'Scroll Up' })
km.set("n", "n", "nzzzv", { desc = 'Next Search Result' })
km.set("n", "N", "Nzzzv", { desc = 'Previous Search Result' })

km.set("n", "<leader><leader>[", "<cmd>bprev<CR>", { desc = 'Previous buffer' })
km.set("n", "<leader><leader>]", "<cmd>bnext<CR>", { desc = 'Next buffer' })
km.set("n", "<leader><leader>l", "<cmd>b#<CR>", { desc = 'Last buffer' })
km.set("n", "<leader><leader>d", "<cmd>bdelete<CR>", { desc = 'delete buffer' })

-- see help sticky keys on windows
vim.cmd([[command! W w]])
vim.cmd([[command! Wq wq]])
vim.cmd([[command! WQ wq]])
vim.cmd([[command! Q q]])

-- Remap for dealing with word wrap
km.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
km.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- km.set("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
-- km.set("n", "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse" })
-- km.set("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Git Blame Line" })
-- km.set("n", "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit Current File History" })

-- Set floaterm window foreground to gray once the cursor moves out from it
-- FIXME: What is the lua native version?
-- hi FloatermNC guifg=gray

km.set("n", "<leader>gg", "<cmd>FloatermNew lazygit<cr>", { desc = "Lazygit" })
km.set("n", "<leader>gl", "<cmd>FloatermNew lazygit log<cr>", { desc = "Lazygit Log (cwd )" })
km.set("n", "<c-/>", "<cmd>FloatermToggle<cr>", { desc = "Toggle Terminal" })

km.set("n", "-", "<cmd>FloatermNew yazi<cr>",
  {
    noremap = true,
    desc = 'Browse parent directory'
  }
)
