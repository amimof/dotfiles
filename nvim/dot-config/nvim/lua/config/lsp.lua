local icons = require("config.icons")

vim.lsp.config("lua_ls", require("lsp.lua_ls"))
vim.lsp.config("vtsls", require("lsp.vtsls"))
vim.lsp.config("vue_ls", require("lsp.vue_ls"))

vim.lsp.config("gopls", require("lsp.gopls"))
vim.lsp.config("gofumpt", require("lsp.gofumpt"))
vim.lsp.config("goimports", require("lsp.goimports"))
vim.lsp.config("golangci-lint", require("lsp.golangci-lint"))

vim.lsp.config("buf_ls", require("lsp.buf_ls"))

vim.lsp.enable({
	"lua_ls",
	"gopls",
	"gofumpt",
	"goimports",
	"golangci-lint",
	"ts_ls",
	"vtsls",
	"vue_ls",
	"buf_ls",
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my-lsp-autosave", {}),
	callback = function(ev)
		-- Auto-format ("lint") on save.
		-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		if
			not client:supports_method("textDocument/willSaveWaitUntil")
			and client:supports_method("textDocument/formatting")
		then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
				buffer = ev.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my-lsp-keymaps", {}),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local opts = { buffer = ev.buf, silent = true }

		vim.keymap.set("n", "gd", function()
			Snacks.picker.lsp_definitions()
		end, { desc = "Goto Definition" })
		vim.keymap.set("n", "gD", function()
			Snacks.picker.lsp_declarations()
		end, { desc = "Goto Declaration" })
		vim.keymap.set("n", "gr", function()
			Snacks.picker.lsp_references()
		end, { desc = "References", nowait = true })
		vim.keymap.set("n", "gI", function()
			Snacks.picker.lsp_implementations()
		end, { desc = "Goto Implementation" })
		vim.keymap.set("n", "gy", function()
			Snacks.picker.lsp_type_definitions()
		end, { desc = "Goto T[y]pe Definition" })
		vim.keymap.set("n", "K", function()
			return vim.lsp.buf.hover({ border = "rounded" })
		end, { desc = "Hover" })
		vim.keymap.set({ "n", "i" }, "<C-V>", function()
			vim.lsp.buf.signature_help({ border = "rounded" })
		end, { desc = "Signature Help" })
		vim.keymap.set("n", "<leader>ss", function()
			Snacks.picker.lsp_symbols()
		end, { desc = "LSP Symbols" })
		vim.keymap.set("n", "<leader>sS", function()
			Snacks.picker.lsp_workspace_symbols()
		end, { desc = "LSP Workspace Symbols" })

		vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
		vim.keymap.set({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
		vim.keymap.set("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
		vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format Code" })
	end,
})

vim.diagnostic.config({ signs = true })

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
			[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
			[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
		},
	},
})
