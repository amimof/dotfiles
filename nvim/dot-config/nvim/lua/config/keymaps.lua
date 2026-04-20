local map = vim.keymap.set

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
	Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- better indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- diagnostic
local diagnostic_goto = function(next, severity)
	return function()
		vim.diagnostic.jump({
			count = (next and 1 or -1) * vim.v.count1,
			severity = severity and vim.diagnostic.severity[severity] or nil,
			float = true,
		})
	end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Adds new-lines and stays in Normal mode
map("n", "<leader>o", "o<Esc>", { desc = "New line below (stay in normal mode)" })
map("n", "<leader>O", "O<Esc>", { desc = "New below below (stay in normal mode)" })

-- Prompts the user for a directory and fuzzy searches for files in there
local function search_files_in_directory()
	local fzf = require("fzf-lua")
	vim.ui.input({ prompt = "Search files in directory: ", completion = "dir" }, function(dir)
		if dir and dir ~= "" then
			fzf.files({ cwd = dir })
		else
			print("No directory specified")
		end
	end)
end
map("n", "<leader>fa", search_files_in_directory, { desc = "Search files in any directory" })

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

local Snacks = require("snacks")

map("n", "<leader>,", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>/", function()
	Snacks.picker.grep()
end, { desc = "Grep (Root Dir)" })
map("n", "<leader>:", function()
	Snacks.picker.command_history()
end, { desc = "Command History" })
map("n", "<leader><leader>", function()
	Snacks.picker.files()
end, { desc = "Find Files (Root Dir)" })
map("n", "<leader>n", function()
	Snacks.picker.notifications()
end, { desc = "Notification History" })

-- find
map("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fB", function()
	Snacks.picker.buffers({ hidden = true, nofile = true })
end, { desc = "Buffers (all)" })

map("n", "<leader>fc", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
-- { "<leader>fF", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
map("n", "<leader>fg", function()
	Snacks.picker.git_files()
end, { desc = "Find Files (git-files)" })
map("n", "<leader>fr", function()
	Snacks.picker.recent()
end, { desc = "Recent" })
map("n", "<leader>fR", function()
	Snacks.picker.recent({ filter = { cwd = true } })
end, { desc = "Recent (cwd)" })
map("n", "<leader>fp", function()
	Snacks.picker.projects()
end, { desc = "Projects" })

-- git
map("n", "<leader>gd", function()
	Snacks.picker.git_diff()
end, { desc = "Git Diff (hunks)" })
map("n", "<leader>gD", function()
	Snacks.picker.git_diff({ base = "origin", group = true })
end, { desc = "Git Diff (origin)" })
map("n", "<leader>gs", function()
	Snacks.picker.git_status()
end, { desc = "Git Status" })
map("n", "<leader>gS", function()
	Snacks.picker.git_stash()
end, { desc = "Git Stash" })
map("n", "<leader>gi", function()
	Snacks.picker.gh_issue()
end, { desc = "GitHub Issues (open)" })
map("n", "<leader>gI", function()
	Snacks.picker.gh_issue({ state = "all" })
end, { desc = "GitHub Issues (all)" })
map("n", "<leader>gp", function()
	Snacks.picker.gh_pr()
end, { desc = "GitHub Pull Requests (open)" })
map("n", "<leader>gP", function()
	Snacks.picker.gh_pr({ state = "all" })
end, { desc = "GitHub Pull Requests (all)" })
map("n", "<leader>gP", function()
	vim.cmd([[
    :Git pu
  ]])
end, { desc = "Git push" })
map("n", "<leader>gg", ":tab Git<CR>", { desc = "Git Status (Fugitive)" })
map("n", "<leader>gv", ":DiffviewOpen<CR>", { desc = "Diffview Open" })

-- Grep
map("n", "<leader>sb", function()
	Snacks.picker.lines()
end, { desc = "Buffer Lines" })
map("n", "<leader>sB", function()
	Snacks.picker.grep_buffers()
end, { desc = "Grep Open Buffers" })
map("n", "<leader>sg", function()
	Snacks.picker.grep()
end, { desc = "Grep (Root Dir)" })
-- { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
map("n", "<leader>sp", function()
	Snacks.picker.lazy()
end, { desc = "Search for Plugin Spec" })
map("n", "<leader>sw", function()
	Snacks.picker.grep_word()
end, { desc = "Visual selection or word (Root Dir)" })
-- { "<leader>sW", LazyVim.pick("grep_word", { root = false }), desc = "Visual selection or word (cwd)", mode = { "n", "x" } },

-- search
map("n", '<leader>s"', function()
	Snacks.picker.registers()
end, { desc = "Registers" })
map("n", "<leader>s/", function()
	Snacks.picker.search_history()
end, { desc = "Search History" })
map("n", "<leader>sa", function()
	Snacks.picker.autocmds()
end, { desc = "Autocmds" })
map("n", "<leader>sc", function()
	Snacks.picker.command_history()
end, { desc = "Command History" })
map("n", "<leader>sC", function()
	Snacks.picker.commands()
end, { desc = "Commands" })
map("n", "<leader>sd", function()
	Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("n", "<leader>sD", function()
	Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer Diagnostics" })
map("n", "<leader>sh", function()
	Snacks.picker.help()
end, { desc = "Help Pages" })
map("n", "<leader>sH", function()
	Snacks.picker.highlights()
end, { desc = "Highlights" })
map("n", "<leader>si", function()
	Snacks.picker.icons()
end, { desc = "Icons" })
map("n", "<leader>sj", function()
	Snacks.picker.jumps()
end, { desc = "Jumps" })
map("n", "<leader>sk", function()
	Snacks.picker.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>sl", function()
	Snacks.picker.loclist()
end, { desc = "Location List" })
map("n", "<leader>sM", function()
	Snacks.picker.man()
end, { desc = "Man Pages" })
map("n", "<leader>sm", function()
	Snacks.picker.marks()
end, { desc = "Marks" })
map("n", "<leader>sR", function()
	Snacks.picker.resume()
end, { desc = "Resume" })
map("n", "<leader>sq", function()
	Snacks.picker.qflist()
end, { desc = "Quickfix List" })
map("n", "<leader>su", function()
	Snacks.picker.undo()
end, { desc = "Undotree" })

-- ui
map("n", "<leader>uC", function()
	Snacks.picker.colorschemes()
end, { desc = "Colorschemes" })

-- Toggle
Snacks.toggle.diagnostics():map("<leader>ud")

local gs = require("gitsigns")

map("n", "]h", function()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		gs.nav_hunk("next")
	end
end, { desc = "Next Hunk" })
map("n", "[h", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		gs.nav_hunk("prev")
	end
end, { desc = "Prev Hunk" })
map("n", "]H", function()
	gs.nav_hunk("last")
end, { desc = "Last Hunk" })
map("n", "[H", function()
	gs.nav_hunk("first")
end, { desc = "First Hunk" })
map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage Buffer" })
map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset Buffer" })
map("n", "<leader>ghp", gs.preview_hunk_inline, { desc = "Preview Hunk Inline" })
map("n", "<leader>ghb", function()
	gs.blame_line({ full = true })
end, { desc = "Blame Line" })
map("n", "<leader>ghB", function()
	gs.blame()
end, { desc = "Blame Buffer" })
map("n", "<leader>ghd", gs.diffthis, { desc = "Diff This" })
map("n", "<leader>ghD", function()
	gs.diffthis("~")
end, { desc = "Diff This ~" })
map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "GitSigns Select Hunk" })
