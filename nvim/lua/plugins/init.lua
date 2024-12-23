return {

  -- Disable plugins
  { "ggandor/leap.nvim", enabled = false },
  { "folke/noice.nvim", enabled = false },
  { "folke/flash.nvim", enabled = false },
  { "echasnovski/mini.icons", enabled = false },
  { "williamboman/mason-lspconfig.nvim", config = function() end, enabled = false },

  { "nvim-tree/nvim-web-devicons" },

  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = true,
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
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kcl = {},
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
        kcl = function(_, opts)
          -- opts.capabilities = vim.lsp.protocol.make_client_capabilities()
          -- opts.on_attach = function(client, bufnr)
          --   -- Enable completion triggered by <C-x><C-o>
          --   vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
          --
          --   -- Optional: Configure additional LSP settings
          --   local blink = require("blink.cmp")
          --   blink.on_attach(client, bufnr)
          -- end
        end,
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
    config = function(_, opts)
      opts.custom_palette = function(_)
        return {
          base00 = "#11121d",
          base01 = "#1b1c27",
          base02 = "#21222d",
          base03 = "#282934",
          base04 = "#30313c",
          base05 = "#abb2bf",
          base06 = "#b2b9c6",
          base07 = "#A0A8CD",
          base08 = "#ee6d85",
          base09 = "#7199ee",
          base0A = "#7199ee",
          base0B = "#dfae67",
          base0C = "#a485dd",
          base0D = "#95c561",
          base0E = "#a485dd",
          base0F = "#f3627a",
          darker_black = "#0c0d18",
        }
      end
      opts.custom_highlights = function(_, p)
        return {
          WinSeparator = { fg = p.darker_black },
          IndentBlanklineChar = { fg = p.bg4 },
          IndentBlanklineContextChar = { fg = p.fg },
          IblIndent = { fg = p.bg4 },
          IblScope = { fg = p.fg },
          LazyProgressDone = { bold = true, fg = p.magenta2 },
          LazyProgressTodo = { bold = true, fg = p.fg_gutter },
          GitSignsChange = { fg = p.yellow },
          GitSignsChangeLn = { fg = p.yellow },
          GitSignsChangeNr = { fg = p.yellow },
          GitGutterDelete = { fg = p.diff_red },
          DiagnosticSignError = { fg = p.red },
          DiagnosticError = { fg = p.red },

          ["@variable"] = { fg = p.base05 },
          ["@variable.builtin"] = { fg = p.base09 },
          ["@variable.parameter"] = { fg = p.base08 },
          ["@variable.member"] = { fg = p.base08 },
          ["@variable.member.key"] = { fg = p.base08 },
        }
      end
      require("tokyodark").setup(opts) -- calling setup is optional
      vim.cmd([[colorscheme tokyodark]])
    end,
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
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        markdownlint = {
          args = { "--disable", "MD013", "--" },
        },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        offsets = {
          {
            filetype = "neo-tree",
            text = "",
            highlight = "Directory",
            text_align = "left",
          },
        },
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
    opts = function(_, opts)
      local p = require("tokyodark.palette")
      vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = p.bg3 })
      vim.api.nvim_set_hl(0, "FzfLuaFzfPrompt", { fg = p.red })
      vim.api.nvim_set_hl(0, "FzfLuaHeaderText", { fg = p.red })
      vim.api.nvim_set_hl(0, "FzfLuaFzfMatch", { fg = p.green })
    end,
  },
  {
    "kcl-lang/kcl.nvim",
  },

  -- {
  --   "kcl-lang/kcl.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     local server_config = require("lspconfig.configs")
  --     local util = require("lspconfig.util")
  --
  --     server_config.kcl = {
  --       default_config = {},
  --     }
  --
  --     require("lspconfig").kcl.setup({
  --       cmd = { "kcl-language-server" },
  --       filetypes = { "kcl" },
  --       root_dir = util.root_pattern(".git"),
  --     })
  --   end,
  -- },
}
