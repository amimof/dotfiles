-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

-- Toggle neo-tree file explorer
map("n", "<c-b>", "<cmd>Neotree toggle show<cr>", { desc = "Neotree Toggle" })

-- Clear search with <esc> and also reset cursors
map({ "n" }, "<esc>", function()
  local mc = require("multicursor-nvim")
  if not mc.cursorsEnabled() then
    mc.enableCursors()
  else
    mc.clearCursors()
  end
  vim.cmd("nohlsearch") -- Equivalent to <cmd>noh<cr>
  vim.cmd("stopinsert") -- Equivalent to <esc>, only needed if you're in insert mode
end, { desc = "Escape and Clear hlsearch" })

-- Signature help using ctrl-v in insert and normal
map({ "n", "i" }, "<C-V>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

-- Replace all occurenses of word under cursor in normal and selection in visual. Case (sensitive)
map(
  "n",
  "<leader>cw",
  '"hy:%s/\\C<C-r><C-w>/<C-r><C-w>/g<left><left>',
  { noremap = true, silent = false, desc = "[R]eplace [W]ord" }
)
map(
  "v",
  "<leader>cw",
  '"hy:%s/\\C<C-r>h/<C-r>h/g<left><left>',
  { noremap = true, silent = false, desc = "[R]replace [W]ord" }
)

-- Adds new-lines and stays in Normal mode
map("n", "<leader>o", "o<Esc>", { desc = "New line below (stay in normal mode)" })
map("n", "<leader>O", "O<Esc>", { desc = "New below below (stay in normal mode)" })
