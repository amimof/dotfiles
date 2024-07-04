local options = {
	formatters_by_ft = {
		-- lua = { "stylua" },
		go = { "goimports", "gofumpt" },
		css = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		["markdown"] = { { "prettierd", "prettier" }, "markdownlint", "markdown-toc" },
		["markdown.mdx"] = { { "prettierd", "prettier" }, "markdownlint", "markdown-toc" },
	},

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
}

require("conform").setup(options)
