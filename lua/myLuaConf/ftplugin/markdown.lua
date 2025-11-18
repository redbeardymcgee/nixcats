vim.api.nvim_create_autocmd("Filetype", {
  pattern = "markdown|mdx",
  callback = function()
    local winid = vim.api.nvim_get_current_win()
    vim.wo[winid][0].colorcolumn = "80"
    vim.bo.textwidth = 80
  end,
})
