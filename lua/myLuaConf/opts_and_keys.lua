-- NOTE: These 2 need to be set up before any plugins are loaded.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Set highlight on search
vim.opt.hlsearch = true
vim.keymap.set(
  "n",
  "<Esc>",
  vim.cmd("nohlsearch"),
  { desc = "Clear search highlight" }
)

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Indent
vim.o.smarttab = true
vim.opt.cpoptions:append("I")
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 2

-- stops line wrapping from being confusing
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"
vim.wo.relativenumber = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,preview,noselect"

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

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group =
  vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0
-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Moves Line Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Moves Line Up" })
vim.keymap.set(
  "n",
  "<C-d>",
  "<cmd>lua vim.cmd('normal! <C-d>'); MiniAnimate.execute_after('scroll', 'normal! zz')<cr>",
  { desc = "Scroll Down" }
)
vim.keymap.set(
  "n",
  "<C-u>",
  "<cmd>lua vim.cmd('normal! <C-u>'); MiniAnimate.execute_after('scroll', 'normal! zz')<cr>",
  { desc = "Scroll Up" }
)
vim.keymap.set(
  "n",
  "n",
  "<cmd>lua vim.cmd('normal! n'); MiniAnimate.execute_after('scroll', 'normal! zzzv')<cr>",
  { desc = "Next Search Result" }
)
vim.keymap.set(
  "n",
  "N",
  "<cmd>lua vim.cmd('normal! N'); MiniAnimate.execute_after('scroll', 'normal! zzzv')<cr>",
  { desc = "Previous Search Result" }
)
vim.keymap.set(
  "n",
  "<leader><leader>[",
  "<cmd>bprev<cr>",
  { desc = "Previous buffer" }
)
vim.keymap.set(
  "n",
  "<leader><leader>]",
  "<cmd>bnext<cr>",
  { desc = "Next buffer" }
)
vim.keymap.set(
  "n",
  "<leader><leader>l",
  "<cmd>b#<cr>",
  { desc = "Last buffer" }
)
vim.keymap.set(
  "n",
  "<leader><leader>d",
  "<cmd>bdelete<cr>",
  { desc = "delete buffer" }
)

-- see help sticky keys on windows
vim.cmd([[command! W w]])
vim.cmd([[command! Wq wq]])
vim.cmd([[command! WQ wq]])
vim.cmd([[command! Q q]])

-- Remap for dealing with word wrap
vim.keymap.set(
  "n",
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)
vim.keymap.set(
  "n",
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)

-- Diagnostic keymaps
vim.diagnostic.config({ jump = { float = true } })
vim.keymap.set(
  "n",
  "<leader>e",
  vim.diagnostic.open_float,
  { desc = "Open floating diagnostic message" }
)
vim.keymap.set(
  "n",
  "<leader>q",
  vim.diagnostic.setloclist,
  { desc = "Open diagnostics list" }
)

-- kickstart.nvim starts you with this.
-- But it constantly clobbers your system clipboard whenever you delete anything.

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.o.clipboard = 'unnamedplus'

-- You should instead use these keybindings so that they are still easy to use, but dont conflict
vim.keymap.set(
  { "v", "x", "n" },
  "<leader>y",
  '"+y',
  { noremap = true, silent = true, desc = "Yank to clipboard" }
)
vim.keymap.set(
  { "n", "v", "x" },
  "<leader>Y",
  '"+yy',
  { noremap = true, silent = true, desc = "Yank line to clipboard" }
)
vim.keymap.set(
  { "n", "v", "x" },
  "<leader>p",
  '"+p',
  { noremap = true, silent = true, desc = "Paste from clipboard" }
)
vim.keymap.set("i", "<C-p>", "<C-r><C-p>+", {
  noremap = true,
  silent = true,
  desc = "Paste from clipboard from within insert mode",
})
vim.keymap.set("x", "<leader>P", '"_dP', {
  noremap = true,
  silent = true,
  desc = "Paste over selection without erasing unnamed register",
})

-- File operations
vim.keymap.set(
  "n",
  "<leader>fs",
  ":write<cr>",
  { noremap = true, silent = true, desc = "[F]ile [S]ave" }
)
vim.keymap.set(
  "n",
  "<leader>fS",
  ":wall<cr>",
  { noremap = true, silent = true, desc = "[F]ile [S]ave all" }
)
