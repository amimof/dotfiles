require("config.autocmds")
require("config.options")
require("config.lsp")
require("plugins")
require("config.keymaps")
vim.cmd.colorscheme("moonfly")
vim.cmd([[
  :hi NeoTreeNormal guibg=#08090c
  :hi NeoTreeNormalNC guibg=#08090c
  :hi NeoTreeEndOfBuffer guibg=#08090c
]])
