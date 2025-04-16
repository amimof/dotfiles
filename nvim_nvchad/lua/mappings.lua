-- require "nvchad.mappings"
local map = vim.keymap.set
local builtin = require("telescope.builtin")

-- Function to create a custom entry for LSP diagnostics in Telescope
local lspdiagnostics = function()
  local function make_entry(entry)
    local function capitalize(str)
      if #str == 0 then return str end                  -- Handle empty strings
      local first = string.upper(string.sub(str, 1, 1)) -- Uppercase the first character
      local rest = string.lower(string.sub(str, 2))     -- Lowercase the rest of the string
      return first .. rest
    end

    local icons = {
      INFO = '',
      ERROR = '',
      WARN = '',
      HINT = '󰛩',
    }
    local icon = icons[entry.type]
    local severity = entry.type
    local pos = string.format("%d:%d", entry.lnum, entry.col)
    local filename = string.format("%4s", vim.fn.fnamemodify(entry.filename, ":.")) -- Relative path
    local hl_group = "DiagnosticSign" .. capitalize(entry.type)

    local entry_display = require('telescope.pickers.entry_display')
    local display_items = {
      { width = 2 },
      { width = #filename },
      { width = 10 },
      { remaining = true },
    }

    local displayer = entry_display.create {
      separator = " ",
      items = display_items,
    }

    local make_display = function()
      return displayer {
        { icon,     hl_group },
        { filename, hl_group },
        { pos,      hl_group },
        entry.text,
      }
    end

    return {
      value = entry,
      ordinal = string.format("%s %s %s %s", severity, filename, pos, entry.text),
      display = make_display,
      filename = entry.filename,
      lnum = entry.lnum,
      col = entry.col,
      type = entry.type,
      text = entry.text
    }
  end


  builtin.diagnostics({
    path_display = { "tail" }, -- Show only the filename (not full path)
    layout_config = {
      preview_cutoff = 10,     -- Show preview only for small windows
      preview_width = 0.4
    },
    severity_sort = true, -- Sort by severity (Errors -> Warnings -> Info)
    line_with = "full",
    wrap_results = true,
    entry_maker = make_entry,
  })
end

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move lines
map("n", "<C-M-j>", function()
  vim.cmd('move .+1')   -- Moves the current line down
  vim.cmd('normal! ==') -- Indents the line correctly
end, { desc = "Move line down" })
map("n", "<C-M-k>", function()
  vim.cmd('move .-2')   -- Moves the current line down
  vim.cmd('normal! ==') -- Indents the line correctly
end, { desc = "Move line up" })
map("v", "<C-M-k>", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })
map("v", "<C-M-j>", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })

-- Clear search with <esc> and also reset cursors
map({ "n" }, "<esc>", function()
  local mc = require("multicursor-nvim")
  if not mc.cursorsEnabled() then
    mc.enableCursors()
  else
    mc.clearCursors()
  end
  vim.cmd('nohlsearch') -- Equivalent to <cmd>noh<cr>
  vim.cmd('stopinsert') -- Equivalent to <esc>, only needed if you're in insert mode
end, { desc = "Escape and Clear hlsearch" })

-- Toggle NvimTree
map("n", "<C-b>", "<Cmd>NvimTreeToggle<CR>")

-- Go-to lsp mappings
map("n", "<leader>gd", builtin.lsp_definitions, { desc = "[G]oto [D]efinition" })
map("n", "<leader>gr", builtin.lsp_references, { desc = "[G]oto [R]eferences" })
map("n", "<leader>gI", builtin.lsp_implementations, { desc = "[G]oto [I]mplementation" })
map("n", "<leader>gy", builtin.lsp_type_definitions, { desc = "[G]oto T[y]pe Definition" })
map("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })

-- LSP hover information
map("n", "K", vim.lsp.buf.hover, { desc = "LSP hover information" })

-- LSP Function Signature Help
map({ "n", "i" }, "<C-V>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

-- LSP Code Action
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })

-- LSP Code Lens
map("n", "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
map("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })

-- Search mappings
map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
map("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
map("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
map("n", "<leader>st", builtin.builtin, { desc = "[S]earch [T]elescope" })
map("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
map("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
map("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
map("n", "<leader>sc", builtin.git_commits, { desc = "[S]earch Git [C]ommits" })
map("n", "<leader>ss", builtin.lsp_document_symbols, { desc = "[S]earch Document [S]ymbols" })
map("n", "<leader>sm", builtin.marks, { desc = "[S]earch [M]arks" })
map("n", "<leader>sa", builtin.resume, { desc = "[S]earch [A]gain" })
map("n", "<leader>sp", function()
  builtin.find_files({ prompt_title = "Find Projects", cwd = "~/git/", hidden = false, find_command = { "find", ".", "-type", "d", "-maxdepth", "3", "-not", "-path", "pkg/" } })
end, { desc = "[S]earch [P]rojects (in ~/git/)" })

-- Buffer manipulation
local tabufline = require('nvchad.tabufline')
map("n", "<leader>bo", function() tabufline.closeAllBufs(false) end, { desc = "[B]uffer Delete [O]ther Buffers" })
map("n", "<leader>br", function() tabufline.closeBufs_at_direction { "right" } end,
  { desc = "[B]uffer Delete to [R]ight" })
map("n", "<leader>bl", function() tabufline.closeBufs_at_direction { "left" } end,
  { desc = "[B]uffer Delete to [L]eft" })
map("n", "<leader>bn", tabufline.next, { desc = "[B]uffer [N]ext" })
map("n", "<leader>bp", tabufline.prev, { desc = "[B]uffer [P]revious" })
map("n", "<leader>bN", "<cmd>enew<CR>", { desc = "[B]uffer [N]ew" })

-- Replace all occurenses of word under cursor
map(
  "n",
  "<leader>rw",
  '"hy:%s/\\C<C-r><C-w>/<C-r><C-w>/g<left><left>',
  { noremap = true, silent = false, desc = "[R]eplace [W]ord" }
)
-- LSP rename, uses NvChad renamer: NvRenamer
map("n", "<leader>rs", function()
  require("nvchad.lsp.renamer")()
end, { desc = "[R]ename LSP [S]ymbol" })

-- Replace selection in Visual mode
map("v", "<leader>r", '"hy:%s/\\C<C-r>h/<C-r>h/g<left><left>',
  { noremap = true, silent = false, desc = "[R]replace Selection" }
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
local dap = require('dap')
vim.keymap.set("n", "<F1>", dap.continue)
vim.keymap.set("n", "<F2>", dap.step_into)
vim.keymap.set("n", "<F3>", dap.step_over)
vim.keymap.set("n", "<F4>", dap.step_out)
vim.keymap.set("n", "<F5>", dap.step_back)
vim.keymap.set("n", "<F13>", dap.restart)

-- Eval var under cursor
vim.keymap.set("n", "<space>?", function()
  require("dapui").eval(nil, { enter = true })
end)


-- URL handling
if vim.fn.has("mac") == 1 then
  map("", "<space>o", '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>', { desc = "[O]pen Link" })
elseif vim.fn.has("unix") == 1 then
else
  map("", "<space>o", '<Cmd>lua print("Error: gx is not supported on this OS!")<CR>', { desc = "[O]pen Link" })
end

-- Multicursor
local mc = require("multicursor-nvim")
map({ "n", "v" }, "<c-n>", function() mc.addCursor("*") end)
map({ "n" }, "<M-j>", function() mc.addCursor("j") end, { desc = "Add cursor downwards" })
map({ "n" }, "<M-k>", function() mc.addCursor("k") end, { desc = "Add cursor upwards" })


-- Gitsigns hunk mappings
local gs = require("gitsigns")
map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "[H]unk [S]tage" })
map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "[H]unk [R]eset" })
map("n", "<leader>hS", gs.stage_buffer, { desc = "[H]unk [S]tage Buffer" })
map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "[H]unk [U]ndo Stage" })
map("n", "<leader>hR", gs.reset_buffer, { desc = "[H]unk [R]eset Buffer" })
map("n", "<leader>hp", gs.preview_hunk_inline, { desc = "[H]unk [P]review Inline" })
map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "[H]unk [B]lame Line" })
map("n", "<leader>hB", gs.blame, { desc = "[H]unk [B]lame [B]uffer" })
map("n", "<leader>hd", gs.diffthis, { desc = "[H]unk [D]iff This" })
-- map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Diff This ~" })
