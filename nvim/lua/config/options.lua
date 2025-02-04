-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Add rounded borders to hover and signature help floats
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- Disable spelling
vim.opt_local.spell = false

-- Remove whitespaces
vim.cmd([[set nolist]])

vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})
