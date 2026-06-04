local icons = require("config.icons")

vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/nvim-mini/mini.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/folke/which-key.nvim",
	{
		src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
		version = vim.version.range("3"),
	},
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("^1"),
	},
	"https://github.com/bluz71/vim-moonfly-colors",
	"https://github.com/sindrets/diffview.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/akinsho/bufferline.nvim",
	"https://github.com/folke/snacks.nvim",
	"https://github.com/lukas-reineke/indent-blankline.nvim",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/mrjones2014/smart-splits.nvim",


	"https://github.com/EdenEast/nightfox.nvim",
	"https://github.com/eldritch-theme/eldritch.nvim",
	"https://github.com/nyoom-engineering/oxocarbon.nvim"

})

require("mason").setup()

require("nvim-treesitter").setup({
	indent = { enable = true }, ---@type lazyvim.TSFeat
	highlight = { enable = true }, ---@type lazyvim.TSFeat
	folds = { enable = true }, ---@type lazyvim.TSFeat
	install_dir = vim.fn.stdpath("data") .. "/site",
})

require("nvim-treesitter").install({
	"bash",
	"c",
	"diff",
	"go",
	"gomod",
	"gowork",
	"gosum",
	"typescript",
	"vue",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"printf",
	"proto",
	"python",
	"query",
	"regex",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
}):wait(300000) -- wait max. 5 minutes


require("nvim-autopairs").setup()

require("neo-tree").setup({
	default_component_configs = {
		git_status = {
			symbols = {
				modified = icons.git.modified,
				unstaged = icons.git.unstaged,
				staged = icons.git.staged,
			},
		},
		modified = {
			symbol = icons.git.modified,
		},
		indent = {
			with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
			expander_collapsed = "",
			expander_expanded = "",
			expander_highlight = "NeoTreeExpander",
		},
	},
	filesystem = {
		use_libuv_file_watcher = true,
		follow_current_file = {
			leave_dirs_open = true,
			enabled = true,
			show_unloaded = false,
			group_empty_dirs = true,
		},
	},
	buffers = {
		show_unloaded = false,
		group_empty_dirs = false,
		follow_current_file = {
			leave_dirs_open = true,
			enabled = true,
		},
	},
	window = {
		width = 30,
	},
})

require("ibl").setup({
	indent = {
		char = "│",
		tab_char = "│",
	},
	scope = { show_start = false, show_end = false },
	exclude = {
		filetypes = {
			"Trouble",
			"alpha",
			"dashboard",
			"help",
			"lazy",
			"mason",
			"neo-tree",
			"notify",
			"snacks_dashboard",
			"snacks_notif",
			"snacks_terminal",
			"snacks_win",
			"toggleterm",
			"trouble",
		},
	},
})

require("which-key").setup({
	preset = "helix",
})

require("mini.ai").setup()
require("mini.basics").setup()
require("mini.surround").setup({
	mappings = {
		add = "gsa",     -- Add surrounding in Normal and Visual modes
		delete = "gsd",  -- Delete surrounding
		find = "gsf",    -- Find surrounding (to the right)
		find_left = "gsF", -- Find surrounding (to the left)
		highlight = "gsh", -- Highlight surrounding
		replace = "gsr", -- Replace surrounding

		suffix_last = "l", -- Suffix to search with "prev" method
		suffix_next = "n", -- Suffix to search with "next" method
	},
})

require("snacks").setup({
	statuscolumn = {},
	input = { enabled = true }, -- for vim.ui.input
	picker = {
		enabled = true,
		ui_select = true, -- replaces vim.ui.select
		sources = {
			select = {
				layout = { preset = "select" },
			},
		},
		win = {
			-- input window
			input = {
				keys = {
					-- to close the picker on ESC instead of going to normal mode,
					-- add the following keymap to your config
					["<Esc>"] = { "close", mode = { "n", "i" } },
				}
			}
		}
	},
	dashboard = {
		enabled = true,
		sections = {
			{ section = "header" },
			{
				icon = " ",
				title = "Keymaps",
				section = "keys",
				indent = 2,
				padding = 1,
			},
			{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
			{
				pane = 1,
				icon = " ",
				title = "Git Status",
				section = "terminal",
				enabled = function()
					return Snacks.git.get_root() ~= nil
				end,
				cmd = "git status --short --branch --renames",
				height = 5,
				padding = 1,
				ttl = 5 * 60,
				indent = 3,
			},
		},
		change_to_vcs_root = true,
		preset = {
			header = [[
		        ⢰⣶⣶⣶⣶⣶⣶⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣶⣶⣶⣶⣶⣶
		        ⢸⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿
		        ⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿
		        ⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿
		        ⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿
		        ⢸⣿⣿⣿⠀⠀⠀⠀⠀⢰⣶⣶⣶⠀⠀⠀⢰⣶⣶⣶⡆⠀⣿⣿⣿
		        ⢸⣿⣿⣿⠀⠀⠀⠀⠀⢸⣿⣿⣿⠀⠀⠀⢸⣿⣿⣿⡇⠀⣿⣿⣿
		        ⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿
		        ⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿
		        ⢸⣿⣿⣿⣶⣶⣶⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣶⣶⣶⣿⣿⣿
		        ⢸⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿
		        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
		        ⠀⠀⠀⠀⣿⣿⣿⡇⠀⠀⠀⣿⣿⣿⣿⠀⠀⠀⢸⣿⣿⣿⠀⠀⠀
		        ⠀⠀⠀⠀⣿⣿⣿⡇⠀⠀⠀⣿⣿⣿⣿⠀⠀⠀⢸⣿⣿⣿⡀⠀⠀
		        ⠀⠀⠀⣸⣿⣿⣿⠇⠀⠀⠀⣿⣿⣿⣿⠀⠀⠀⠘⣿⣿⣿⣇⠀⠀
		        ⢠⣤⣶⣿⣿⣿⡟⠀⠀⠀⠀⣿⣿⣿⣿⠀⠀⠀⠀⠹⣿⣿⣿⣶⣤
		        ⢸⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⣿⣿⣿⣿⠀⠀⠀⠀⠀⠙⠿⣿⣿⣿
		        ]],
		},
	}
})

require("gitsigns").setup({
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
		untracked = { text = "▎" },
	},
	signs_staged = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
	},
})

require("bufferline").setup({
	highlights = {
		fill = { bg = "#16161e" },
		background = { bg = "#16161e" },

		buffer = { bg = "#16161e" },
		buffer_visible = { bg = "#0b0d11" },
		buffer_selected = { bg = "#0b0d11" },

		-- separator = { bg = "#0b0d11" },
		-- separator_visible = { bg = "#0b0d11" },
		-- separator_selected = { bg = "#0b0d11" },

		numbers = { bg = "#0b0d11" },
		numbers_visible = { bg = "#0b0d11" },
		numbers_selected = { bg = "#0b0d11" },

		indicator_visible = { bg = "#0b0d11" },
		indicator_selected = { bg = "#0b0d11" },

		pick = { bg = "#0b0d11" },
		pick_visible = { bg = "#0b0d11" },

		offset_separator = { bg = "#0b0d11" },
		trunc_marker = { bg = "#0b0d11" },

		error = { bg = "#16161e" },
		error_visible = { bg = "#0b0d11" },
		error_selected = { bg = "#0b0d11" },

		warning = { bg = "#16161e" },
		warning_visible = { bg = "#0b0d11" },
		warning_selected = { bg = "#0b0d11" },

		info = { bg = "#16161e" },
		info_visible = { bg = "#0b0d11" },
		info_selected = { bg = "#0b0d11" },

		hint = { bg = "#16161e" },
		hint_visible = { bg = "#0b0d11" },

		diagnostic = { bg = "#16161e" },
		diagnostic_visible = { bg = "#0b0d11" },

		modified = { bg = "#16161e" },
		modified_visible = { bg = "#0b0d11" },
		modified_selected = { bg = "#0b0d11" },

		error_diagnostic = { bg = "#16161e" },
		warning_diagnostic = { bg = "#16161e" },
		info_diagnostic = { bg = "#16161e" },
		hint_diagnostic = { bg = "#16161e" },
		close_button = { bg = "#16161e" },
		close_button_visible = { bg = "#16161e" },
		close_button_selected = { bg = "#0b0d11" },
	},
	options = {
		separator_style = { "│", "│" },
		diagnostics = "nvim_lsp",
		indicator = {
			style = "none",
			-- icon = "▎",

		},
		style_preset = require("bufferline").style_preset.no_italic,
		offsets = {
			{
				filetype = "neo-tree",
				text = "",
				highlight = "BufferLineBackground",
				text_align = "left",
			},
		},
		sort_by = "insert_at_end",
	},
})

require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = vim.o.laststatus == 3,
		disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
	},
	sections = {
		lualine_a = {
			{
				"mode",
				fmt = function(res)
					return " " .. res
				end,
			},
		},
		lualine_b = { "branch" },
		lualine_c = {
			{
				"diagnostics",
				symbols = {
					error = icons.diagnostics.Error,
					warn = icons.diagnostics.Warn,
					info = icons.diagnostics.Info,
					hint = icons.diagnostics.Hint,
				},
			},
			{
				"filetype",
				icon_only = true,
				separator = "",
				padding = { left = 1, right = 0 },
			},
			{ "filename" },
		},
		lualine_x = {
			{
				"diff",
				symbols = {
					added = icons.git.added,
					modified = icons.git.modified,
					removed = icons.git.removed,
				},
				source = {
					added = icons.git.added,
					modified = icons.git.changed,
					removed = icons.git.removed,
				},
			},
		},
		lualine_y = { "encoding", "filetype", "progress" },
		lualine_z = { "location" },
	},
})

require("blink.cmp").setup({
	keymap = {
		preset = "enter",
		["<C-y>"] = { "select_and_accept" },
	},
	fuzzy = {
		implementation = "lua",
	},
	appearance = {
		nerd_font_variant = "mono",
		use_nvim_cmp_as_default = false,
	},
	completion = {
		trigger = {
			show_on_trigger_character = true,
			show_on_keyword = false,
		},
		ghost_text = { enabled = false },
		menu = {
			--auto_show = false,
			-- winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
			draw = {
				treesitter = { "lsp" },
				columns = {
					{ "label",     "label_description", gap = 2 },
					{ "kind_icon", "kind" },
				},
			},
		},
		documentation = {
			auto_show_delay_ms = 500,
			auto_show = false,
			window = {
				border = "rounded",
			},
		},
	},
	cmdline = {
		enabled = true,
		keymap = {
			preset = "cmdline",
			["<Right>"] = false,
			["<Left>"] = false,
		},
		completion = {
			list = { selection = { preselect = false } },
			menu = {
				auto_show = function(ctx)
					return vim.fn.getcmdtype() == ":"
				end,
			},
			ghost_text = { enabled = true },
		},
	},
})

require('nightfox').setup({
	options = {
		transparent = true
	}
})

require('eldritch').setup({
	transparent = true
})

require("smart-splits").setup({
	disable_multiplexer_nav_when_zoomed = false,
})
