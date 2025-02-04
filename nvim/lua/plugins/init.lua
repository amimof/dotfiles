return {

  -- Disable plugins
  { "ggandor/leap.nvim", enabled = false },
  { "folke/noice.nvim", enabled = false },
  { "folke/flash.nvim", enabled = false },
  { "echasnovski/mini.icons", enabled = false },
  -- { "MeanderingProgrammer/render-markdown.nvim", enabled = false },
  -- { "williamboman/mason-lspconfig.nvim", config = function(_, opts) end, enabled = true },

  { "nvim-tree/nvim-web-devicons" },

  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
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
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ui = {
        border = "rounded",
      }
      -- vim.list_extend(opts.ensure_installed, {
      --   "kcl",
      -- })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "markdown" })
        vim.treesitter.language.register("markdown", "mdx")
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kcl = {
          cmd = { "/usr/local/bin/kcl-language-server" },
          mason = false,
        },
      },
      diagnostics = {
        float = {
          border = "rounded",
        },
      },
      inlay_hints = {
        enabled = false,
      },
      setup = {
        -- kcl = function(_, opts)
        --   opts.capabilities = vim.lsp.protocol.make_client_capabilities()
        -- end,
        gopls = function(_, opts)
          opts.settings.gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = false,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
          }
        end,
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    config = function(_, opts)
      opts.default_component_configs.git_status.symbols.modified = "!"
      opts.default_component_configs.modified = {
        symbol = "",
      }
      require("neo-tree").setup(opts)
      vim.cmd([[
        :hi NeoTreeNormal guibg=#0c0d18
        :hi NeoTreeNormalNC guibg=#0c0d18
        :hi NeoTreeEndOfBuffer guibg=#0c0d18
      ]])
      vim.cmd([[
        " :hi NvimTreeGitFileNewHL guifg=#a6e3a1
        " :hi NvimTreeGitNewIcon guifg=#a6e3a1
        " :hi NvimTreeGitFolderNewHL guifg=#a6e3a1
        "
        " :hi NvimTreeGitFileDirtyHL guifg=#f9e2af
        " :hi NvimTreeGitDirtyIcon guifg=#f9e2af
        " :hi NvimTreeGitFolderDirtyFolder guifg=#f9e2af
        "
        " :hi NvimTreeGitFileIgnoredHL guifg=#585b70
        " :hi NvimTreeGitFolderIgnoredHL guifg=#585b70
        " :hi NvimTreeGitIgnoredIcon guifg=#585b70
        "
        " :hi NvimTreeGitStagedIcon guifg=#a6e3a1 gui=bold
        " :hi NvimTreeGitFileStagedHL guifg=#a6e3a1 gui=bold
        " :hi NvimTreeGitFolderStagedHL guifg=#a6e3a1 gui=bold
        "
        :hi NeoTreeGitModified guifg=#f9e2af
        :hi NeoTreeGitDeleted guifg=#ee6d85

        :hi NeoTreeGitAdded guifg=#a6e3a1
        " :hi NeoTreeDirectoryName guifg=cleared
        " :hi NeoTreeGitConflict guifg=#a6e3a1
        " :hi NeoTreeGitIgnored guifg=#a6e3a1
        :hi NeoTreeGitUnstaged guifg=#a6e3a1
        " :hi NeoTreeGitUntracked guifg=#a6e3a1
        " :hi NeoTreeGitStaged guifg=#a6e3a1
        " :hi NeoTreeHiddenByName guifg=#a6e3a1
        " :hi NeoTreeIndentMarker guifg=#a6e3a1


      ]])
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function(_, opts)
      require("gitsigns").setup(opts)
      vim.cmd([[
        :hi GitSignsChange guifg=#f9e2af
      ]])
    end,
  },

  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        style_preset = require("bufferline").style_preset.no_italic,
        offsets = {
          {
            filetype = "neo-tree",
            text = "",
            highlight = "BufferLineBackground",
            text_align = "left",
          },
        },
      },
    },
  },

  {
    "tiagovla/tokyodark.nvim",
    opts = {
      styles = {
        comments = { italic = true }, -- style for comments
        keywords = { italic = true }, -- style for keywords
        identifiers = { italic = true }, -- style for identifiers
        functions = {}, -- style for functions
        variables = {}, -- style for variables
      },
    },
    -- config = function(_, opts)
    --   opts.custom_palette = function(_)
    --     return {
    --       base00 = "#11121d",
    --       base01 = "#1b1c27",
    --       base02 = "#21222d",
    --       base03 = "#282934",
    --       base04 = "#30313c",
    --       base05 = "#abb2bf",
    --       base06 = "#b2b9c6",
    --       base07 = "#A0A8CD",
    --       base08 = "#ee6d85",
    --       base09 = "#7199ee",
    --       base0A = "#7199ee",
    --       base0B = "#dfae67",
    --       base0C = "#a485dd",
    --       base0D = "#95c561",
    --       base0E = "#a485dd",
    --       base0F = "#f3627a",
    --       darker_black = "#0c0d18",
    --     }
    --   end
    --   opts.custom_highlights = function(_, p)
    --     return {
    --       CursorLine = { bg = p.base02 },
    --       WinSeparator = { fg = p.darker_black },
    --       IndentBlanklineChar = { fg = p.bg4 },
    --       IndentBlanklineContextChar = { fg = p.fg },
    --       IblIndent = { fg = p.bg4 },
    --       IblScope = { fg = p.fg },
    --       LazyProgressDone = { bold = true, fg = p.magenta2 },
    --       LazyProgressTodo = { bold = true, fg = p.fg_gutter },
    --       GitSignsChange = { fg = p.yellow },
    --       GitSignsChangeLn = { fg = p.yellow },
    --       GitSignsChangeNr = { fg = p.yellow },
    --       GitGutterDelete = { fg = p.diff_red },
    --       DiagnosticSignError = { fg = p.red },
    --       DiagnosticError = { fg = p.red },
    --
    --       BlinkCmpKindConstant = { fg = p.base09 },
    --       BlinkCmpKindFunction = { fg = p.base0D },
    --       BlinkCmpKindIdentifier = { fg = p.base08 },
    --       BlinkCmpKindField = { fg = p.base08 },
    --       BlinkCmpKindVariable = { fg = p.base0E },
    --       BlinkCmpKindSnippet = { fg = p.red },
    --       BlinkCmpKindText = { fg = p.base0B },
    --       BlinkCmpKindStructure = { fg = p.base0E },
    --       BlinkCmpKindType = { fg = p.base0A },
    --       BlinkCmpKindKeyword = { fg = p.base07 },
    --       BlinkCmpKindMethod = { fg = p.base0D },
    --       BlinkCmpKindConstructor = { fg = p.blue },
    --       BlinkCmpKindFolder = { fg = p.base07 },
    --       BlinkCmpKindModule = { fg = p.base0A },
    --       BlinkCmpKindProperty = { fg = p.base08 },
    --       BlinkCmpKindEnum = { fg = p.blue },
    --       BlinkCmpKindUnit = { fg = p.base0E },
    --       BlinkCmpKindClass = { fg = p.teal },
    --       BlinkCmpKindFile = { fg = p.base07 },
    --       BlinkCmpKindInterface = { fg = p.green },
    --       BlinkCmpKindColor = { fg = p.white },
    --       BlinkCmpKindReference = { fg = p.base05 },
    --       BlinkCmpKindEnumMember = { fg = p.purple },
    --       BlinkCmpKindStruct = { fg = p.base0E },
    --       BlinkCmpKindValue = { fg = p.cyan },
    --       BlinkCmpKindEvent = { fg = p.yellow },
    --       BlinkCmpKindOperator = { fg = p.base05 },
    --       BlinkCmpKindTypeParameter = { fg = p.base08 },
    --       BlinkCmpKindCopilot = { fg = p.green },
    --       BlinkCmpKindCodeium = { fg = p.vibrant_green },
    --       BlinkCmpKindTabNine = { fg = p.baby_pink },
    --       BlinkCmpKindSuperMaven = { fg = p.yellow },
    --
    --       ["@variable"] = { fg = p.base05 },
    --       ["@variable.builtin"] = { fg = p.base09 },
    --       ["@variable.parameter"] = { fg = p.base08 },
    --       ["@variable.member"] = { fg = p.base08 },
    --       ["@variable.member.key"] = { fg = p.base08 },
    --     }
    --   end
    --   require("tokyodark").setup(opts) -- calling setup is optional
    --   -- vim.cmd([[colorscheme tokyodark]])
    -- end,
  },

  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      local map = LazyVim.safe_keymap_set
      mc.setup()

      map({ "n", "v" }, "<c-n>", function()
        mc.addCursor("*")
      end)
      map({ "n" }, "<C-M-j>", function()
        mc.addCursor("j")
      end, { desc = "Add cursor downwards" })
      map({ "n" }, "<C-M-k>", function()
        mc.addCursor("k")
      end, { desc = "Add cursor upwards" })
    end,
  },

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    config = function(_, opts)
      opts.sections.lualine_a = {
        {
          "mode",
          fmt = function(res)
            return " " .. res
          end,
        },
      }
      require("lualine").setup(opts)
    end,
    opts = {
      sections = {
        lualine_c = {
          LazyVim.lualine.root_dir(),
          {
            "diagnostics",
            symbols = {
              error = LazyVim.config.icons.diagnostics.Error,
              warn = LazyVim.config.icons.diagnostics.Warn,
              info = LazyVim.config.icons.diagnostics.Info,
              hint = LazyVim.config.icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { LazyVim.lualine.pretty_path() },
        },
        lualine_y = { "encoding", "filetype", "progress" },
        lualine_z = { "location" },
      },
    },
  },

  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = { enabled = false },
        menu = {
          auto_show = false,
          border = "rounded",
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:Purple,CursorLine:BlinkCmpMenuSelection,Search:None",
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
          },
        },
        documentation = {
          window = {
            border = "rounded",
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:Purple,CursorLine:BlinkCmpDocCursorLine,Search:None",
          },
        },
      },
    },
  },

  {
    "ibhagwan/fzf-lua",
    config = function(opts)
      opts.fzf_opts = {
        ["--header"] = false,
      }
      require("fzf-lua").setup(opts)
    end,
  },

  {
    "kcl-lang/kcl.nvim",
  },

  {
    "EdenEast/nightfox.nvim",
  },

  {
    "eldritch-theme/eldritch.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(opts)
      local p = require("tokyodark.palette")
      opts.on_colors = function(colors)
        -- colors.bg = p.base00
        -- colors.bg_statusline = "#ff0000"
        -- colors.bg_float = p.base00
        colors.bg_highlight = p.bg2
        -- colors.bg_dark = "#0c0d18"
        -- colors.bg_dark = p.base00
      end

      opts.transparent = true

      require("eldritch").setup(opts)
      vim.cmd([[colorscheme eldritch]])
    end,
  },

  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    config = function(opts)
      opts.disable_multiplexer_nav_when_zoomed = false
      require("smart-splits").setup(opts)
      -- moving between wezterm splits
      vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
      vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
      vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
      vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
    end,
  },
}
