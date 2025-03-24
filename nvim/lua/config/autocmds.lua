-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Disable spelling
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- Disable automatic new line commenting
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable New Line Comment",
})

-- vim.api.nvim_create_autocmd("BufEnter", {
--   callback = function()
--     vim.bo.expandtab = true
--     vim.bo.shiftwidth = 4
--     vim.bo.tabstop = 4
--     vim.bo.softtabstop = 4
--     vim.bo.commentstring = "#%s"
--   end,
--   desc = "Fix tabstop",
-- })
