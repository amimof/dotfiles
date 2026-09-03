-- @type vim.lsp.Config
return {
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
				loadOutDirsFromCheck = true,
				buildScripts = {
					enable = true,
				},
			},
			-- Add clippy lints for Rust if using rust-analyzer
			checkOnSave = true,
			-- Enable diagnostics if using rust-analyzer
			diagnostics = {
				enable = true,
			},
			procMacro = {
				enable = true,
			},
			files = {
				exclude = {
					".direnv",
					".git",
					".jj",
					".github",
					".gitlab",
					"bin",
					"node_modules",
					"target",
					"venv",
					".venv",
				},
				-- Avoid Roots Scanned hanging, see https://github.com/rust-lang/rust-analyzer/issues/12613#issuecomment-2096386344
				watcher = "client",
			},
		},
	}
}
