-- require "nvchad.mappings"
local map = vim.keymap.set
-- local nomap = vim.keymap.del
local builtin = require("telescope.builtin")

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move Lines
map("n", "<M-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<M-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<M-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<M-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<M-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<M-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Toggle NvimTree
map("n", "<C-b>", "<Cmd>NvimTreeToggle<CR>")

-- Go-to lsp mappings
map("n", "<leader>gd", builtin.lsp_definitions, { desc = "[G]oto [D]efinition" })
map("n", "<leader>gr", builtin.lsp_references, { desc = "[G]oto [R]eferences" })
map("n", "<leader>gI", builtin.lsp_implementations, { desc = "[G]oto [I]mplementation" })
map("n", "<leader>gD", builtin.lsp_type_definitions, { desc = "[G]oto Type [D]efinition" })

-- LSP rename, uses NvChad renamer: NvRenamer
map("n", "<leader>ra", function()
  require("nvchad.lsp.renamer")()
end, { desc = "LSP NvRenamer" })

-- LSP hover information
map("n", "K", vim.lsp.buf.hover, { desc = "LSP hover information" })

-- LSP Function Signature Help
map({ "n", "i" }, "<C-V>", vim.lsp.buf.signature_help, { desc = "[G]oto Signature Help" })

-- LSP Code Action
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })

-- LSP Code Lens
map("n", "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
map("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })

-- Search through keymappings with telescope
map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
map("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
map("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
map("n", "<leader>st", builtin.builtin, { desc = "[S]earch [T]elescope" })
map("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
map("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
map("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
map("n", "<leader>sc", builtin.git_commits, { desc = "[S]earch Git [C]ommits" })
map("n", "<leader>ss", builtin.lsp_document_symbols, { desc = "[S]earch Document [S]ymbols" })

-- Replace all occurenses of word under cursor
-- map("v", "<leader>cr", '"hy:%s/<C-r>h//g<left><left>', { noremap = true, silent = false, desc = "[R]eplace Selection" })
map(
  "n",
  "<C-l>",
  '"hy:%s/<C-r><C-w>/<C-r><C-w>/g<left><left>',
  { noremap = true, silent = false, desc = "[R]eplace Word" }
)

-- Buffer manipulation
map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "[B]uffer [D]elete" })
map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "[B]uffer [N]ext" })
map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "[B]uffer [P]revious" })

-- Fuzzy search current opened buffer, without preview pane
map("n", "<leader>/", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })

-- Fuzzy search all open files (requires ripgrep)
map("n", "<leader>s/", function()
  builtin.live_grep({
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  })
end, { desc = "[S]earch [/] in Open Files" })

-- Debugging
-- map("n", "<leader>dc", "<cmd> DapContinue <CR>", { desc = "[D]ebug [C]ontinue" })
-- map("n", "<leader>dt", "<cmd> DapTerminate <CR>", { desc = "[D]ebug [T]erminate" })
-- map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "[D]ebug [B]reakpoint Toggle" })
-- map("n", "<leader>di", "<cmd> DapStepInto <CR>", { desc = "[D]ebug Step [I]n" })
-- map("n", "<leader>do", "<cmd> DapStepOut <CR>", { desc = "[D]ebug Step [O]ut" })
-- map("n", "<leader>dO", "<cmd> DapStepOver <CR>", { desc = "[D]ebug Step [O]ver" })
--
-- -- Open debug sidebar
-- map("n", "<leader>dus", function()
--   local widgets = require("dap.ui.widgets")
--   local sidebar = widgets.sidebar(widgets.scopes)
--   sidebar.toggle()
-- end, { desc = "Open Debug Sidebar" })
--
-- map("n", "<leader>dt", require("dap-go").debug_test, { desc = "Debug [T]est" })
-- map("n", "<leader>dl", require("dap-go").debug_last_test, { desc = "Debug [L]ast [T]est" })

-- URL handling
if vim.fn.has("mac") == 1 then
  map("", "gx", '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>', { desc = "Open" })
elseif vim.fn.has("unix") == 1 then
  map("", "gx", '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>', { desc = "Open" })
else
  map("", "gx", '<Cmd>lua print("Error: gx is not supported on this OS!")<CR>', { desc = "Open" })
end
