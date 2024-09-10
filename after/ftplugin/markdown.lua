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

  -- Add the key mappings only for Markdown files in a zk notebook.
  if require("zk.util").notebook_root(vim.fn.expand('%:p')) ~= nil then
    local map = vim.keymap.set

    -- Open the link under the caret.
    map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", {
      noremap = true,
      silent = false,
    })

    -- Create a new note after asking for its title.
    -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
    map("n", "<leader>zn", "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", {
      noremap = true,
      silent = false,
      desc = "New note (input title)"
    })

    -- Create a new note in the same directory as the current buffer, using the current selection for title.
    map("v", "<leader>znt", ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>", {
      noremap = true,
      silent = false,
      desc = "New note with title from selection"
    })

    -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
    map("v", "<leader>znc",
      ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", {
        noremap = true,
        silent = false,
        desc = "New note with content from selection"
      })

    -- Open notes linking to the current buffer.
    map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", {
      noremap = true,
      silent = false,
      desc = "Open notes linking to current note"
    })

    -- Alternative for backlinks using pure LSP and showing the source context.
    --map('n', '<leader>zb', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- Open notes linked by the current buffer.
    map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", {
      noremap = true,
      silent = false,
      desc = "Open notes linked by the current note"
    })

    -- Preview a linked note.
    map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = false })

    -- Open the code actions for a visual selection.
    map("v", "<leader>za", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", {
      noremap = true,
      silent = false,
      desc = "Code action for selection"
    })
  end
