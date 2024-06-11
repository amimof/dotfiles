return {

	-- Auto-completion
	{
		"hrsh7th/nvim-cmp",
		opts = {
			completion = {
				autocomplete = false,
			},
		},
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		event = "BufWritePre", -- uncomment for format on save
		config = function()
			require("configs.conform")
		end,
	},

	-- LSP configuration
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("configs.lspconfig")
		end,
	},

	-- Package manager for LSP servers
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"lua-language-server",
				"stylua",
				"gopls",
				"yaml-language-server",
				"markdownlint",
				"marksman",
				"typescript-language-server",
				"prettier",
				"vue-language-server",
			},
		},
	},

	-- Syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"vimdoc",
				"html",
				"css",
				"go",
				"yaml",
				"markdown",
				"markdown_inline",
				"vue",
				"javascript",
				"typescript",
			},
		},
	},
	{
		"b0o/SchemaStore.nvim",
		lazy = true,
		version = false, -- last release is way too old
	},
	-- File explorer
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				update_focused_file = {
					enable = true,
					update_root = true,
					ignore_list = {},
				},
				filters = {
					git_ignored = false,
				},
				diagnostics = {
					enable = true,
				},
				renderer = {
					highlight_git = "name",
					highlight_diagnostics = "all",
					icons = {
						git_placement = "signcolumn",
						glyphs = {
							git = {
								untracked = "┃",
								unstaged = "┃",
								staged = "┃",
								unmerged = "┃",
								renamed = "┃",
								deleted = "┃",
								ignored = "",
							},
						},
					},
				},
			})
			-- Setup custom colors for highlighting Git statuses.
			-- Follows catppuccin-mocha color palette. See https://github.com/catppuccin/catppuccin
			vim.cmd([[
        :hi NvimTreeGitFileNewHL guifg=#a6e3a1
        :hi NvimTreeGitNewIcon guifg=#a6e3a1
        :hi NvimTreeGitFolderNewHL guifg=#a6e3a1
        
        :hi NvimTreeGitFileDirtyHL guifg=#f9e2af
        :hi NvimTreeGitDirtyIcon guifg=#f9e2af
        :hi NvimTreeGitFolderDirtyFolder guifg=#f9e2af
        
        :hi NvimTreeGitFileIgnoredHL guifg=#585b70
        :hi NvimTreeGitFolderIgnoredHL guifg=#585b70
        :hi NvimTreeGitIgnoredIcon guifg=#585b70
       
        :hi NvimTreeGitStagedIcon guifg=#a6e3a1 gui=bold
        :hi NvimTreeGitFileStagedHL guifg=#a6e3a1 gui=bold
        :hi NvimTreeGitFolderStagedHL guifg=#a6e3a1 gui=bold
      ]])
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		config = function() -- This is the function that runs, AFTER loading
			require("which-key").setup()

			-- Document existing key chains
			require("which-key").register({
				["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
				["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
				["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
				["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
				["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
				["<leader>b"] = { name = "[B]uffer", _ = "which_key_ignore" },
				["<leader>g"] = { name = "[G]oto", _ = "which_key_ignore" },
			})
		end,
	},
	-- Markdown preview in the browser
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},

	-- Go debugging
	{
		"mfussenegger/nvim-dap",
	},
	{
		"leoluz/nvim-dap-go",
		ft = "go",
		dependencies = "mfussenegger/nvim-dap",
		config = function()
			require("dap-go").setup({
				dap_configurations = {
					{
						type = "go",
						name = "Attach remote",
						mode = "remote",
						request = "attach",
					},
				},
			})
		end,
	},

	-- Greeter
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VimEnter",
		cmd = "Alpha",
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},

	-- Multi-cursor
	{
		"mg979/vim-visual-multi",
		branch = "master",
		lazy = false,
		init = function()
			vim.g.VM_maps = {
				["Find Under"] = "<C-l>",
			}
		end,
	},
}
