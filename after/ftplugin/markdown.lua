  require('glow').setup()
  require('render-markdown').setup()

  vim.g.mkdp_auto_close = 0
  vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview <CR>',
    { noremap = true, desc = 'markdown preview' })
  vim.keymap.set('n', '<leader>ms', '<cmd>MarkdownPreviewStop <CR>',
    { noremap = true, desc = 'markdown preview stop' })
  vim.keymap.set('n', '<leader>mt', '<cmd>MarkdownPreviewToggle <CR>',
    { noremap = true, desc = 'markdown preview toggle' })

  require('markdown').setup({
    on_attach = function(bufnr)
      local map = vim.keymap.set
      local opts = { buffer = bufnr }
      map({ 'n', 'i' }, '<leader>ml', '<Cmd>MDListItemBelow<CR>', opts)
      map({ 'n', 'i' }, '<leader>mL', '<Cmd>MDListItemAbove<CR>', opts)
      map('n', '<leader>mc', '<Cmd>MDTaskToggle<CR>', opts)
      map('x', '<leader>mc', ':MDTaskToggle<CR>', opts)
    end,
  })

  if require("zk.util").notebook_root(vim.fn.expand('%:p')) ~= nil then
    local map = vim.keymap.set

    map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", {
      noremap = true,
      silent = false,
    })

    map("n", "<leader>zn", "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", {
      noremap = true,
      silent = false,
      desc = "New note in buffer's parent dir with title from input"
    })

    map("v", "<leader>znt", ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>", {
      noremap = true,
      silent = false,
      desc = "New note in buffer's parent dir with title from selection"
    })

    map("v", "<leader>znc",
      ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", {
        noremap = true,
        silent = false,
        desc = "New note in buffer's parent dir with content from selection"
      })

    map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", {
      noremap = true,
      silent = false,
      desc = "Open notes linking to current note"
    })
    -- Alternative for backlinks using pure LSP and showing the source context.
    --map('n', '<leader>zb', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)

    map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", {
      noremap = true,
      silent = false,
      desc = "Open notes linked by the current note"
    })

    map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = false })

    map("v", "<leader>za", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", {
      noremap = true,
      silent = false,
      desc = "Code action for selection"
    })
  end
