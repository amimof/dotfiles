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

  -- LSP Configuration
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
      -- ensure_installed = {
      --   "gopls",
      --   "gofumpt",
      --   "goimports",
      --   "lua-language-server",
      --   "stylua",
      --   "yaml-language-server",
      --   "markdownlint",
      --   "marksman",
      --   "typescript-language-server",
      --   "prettier",
      --   "vue-language-server",
      -- },
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
        "gomod",
        "gowork",
        "gosum",
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
          update_root = false,
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
    event = "VimEnter",
    config = function() -- This is the function that runs, AFTER loading
      require("which-key").setup()
      require("which-key").add(
        {
          { "<leader>b",  group = "[B]uffer" },
          { "<leader>b_", hidden = true },
          { "<leader>c",  group = "[C]ode" },
          { "<leader>c_", hidden = true },
          { "<leader>d",  group = "[D]ocument" },
          { "<leader>d_", hidden = true },
          { "<leader>g",  group = "[G]oto" },
          { "<leader>g_", hidden = true },
          { "<leader>r",  group = "[R]ename" },
          { "<leader>r_", hidden = true },
          { "<leader>s",  group = "[S]earch" },
          { "<leader>s_", hidden = true },
          { "<leader>w",  group = "[W]orkspace" },
          { "<leader>w_", hidden = true },
        })
    end
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

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "leoluz/nvim-dap-go",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require "dap"
      local ui = require "dapui"
      require('dap-go').setup({
        dap_configurations = {
          {
            type = "go",
            name = "Hello Attach remote",
            request = "launch",
            program = "${file}"
          },
        },

      })
      require("dapui").setup()


      vim.keymap.set("n", "<space>db", dap.toggle_breakpoint, { desc = "[D]ebug Toggle [B]reakpoint" })

      -- Eval var under cursor
      vim.keymap.set("n", "<space>?", function()
        require("dapui").eval(nil, { enter = true })
      end)


      vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

      vim.keymap.set("n", "<F1>", dap.continue, { desc = "DAP Continue" })
      vim.keymap.set("n", "<F2>", dap.step_into, { desc = "DAP Step Into" })
      vim.keymap.set("n", "<F3>", dap.step_over, { desc = "DAP Step Over" })
      vim.keymap.set("n", "<F4>", dap.step_out, { desc = "DAP Step Out" })
      vim.keymap.set("n", "<F5>", dap.step_back, { desc = "DAP Step Back" })
      vim.keymap.set("n", "<F6>", dap.restart, { desc = "DAP Restart" })
      vim.keymap.set("n", "<F7>", dap.terminate, { desc = "DAP Termiante" })

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end
  },

  -- Greeter
  {
    "nvimdev/dashboard-nvim",
    lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
    opts = function()
      local builtin = require("telescope.builtin")

      local opts = {
        theme = "hyper",
        change_to_vcs_root = true,
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = {
            "",
            "⢰⣶⣶⣶⣶⣶⣶⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣶⣶⣶⣶⣶⣶",
            "⢸⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿",
            "⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿",
            "⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿",
            "⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿",
            "⢸⣿⣿⣿⠀⠀⠀⠀⠀⢰⣶⣶⣶⠀⠀⠀⢰⣶⣶⣶⡆⠀⣿⣿⣿",
            "⢸⣿⣿⣿⠀⠀⠀⠀⠀⢸⣿⣿⣿⠀⠀⠀⢸⣿⣿⣿⡇⠀⣿⣿⣿",
            "⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿",
            "⢸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿",
            "⢸⣿⣿⣿⣶⣶⣶⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣶⣶⣶⣿⣿⣿",
            "⢸⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿",
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⣿⣿⣿⡇⠀⠀⠀⣿⣿⣿⣿⠀⠀⠀⢸⣿⣿⣿⠀⠀⠀",
            "⠀⠀⠀⠀⣿⣿⣿⡇⠀⠀⠀⣿⣿⣿⣿⠀⠀⠀⢸⣿⣿⣿⡀⠀⠀",
            "⠀⠀⠀⣸⣿⣿⣿⠇⠀⠀⠀⣿⣿⣿⣿⠀⠀⠀⠘⣿⣿⣿⣇⠀⠀",
            "⢠⣤⣶⣿⣿⣿⡟⠀⠀⠀⠀⣿⣿⣿⣿⠀⠀⠀⠀⠹⣿⣿⣿⣶⣤",
            "⢸⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⣿⣿⣿⣿⠀⠀⠀⠀⠀⠙⠿⣿⣿⣿",
            "",
            "",
          },
          week_header = {
            enable = false
          },
          -- header = vim.split(logo, "\n"),
          -- project = { enable = true, limit = 6, icon = '󰘬', label = '', action = 'Telescope find_files cwd=/Users/amir/git' },
          -- stylua: ignore
          shortcut = {
            { action = builtin.find_files, desc = " Find File", icon = " ", key = "f", icon_hl = "@variable" },
            { action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
            { action = builtin.oldfiles, desc = " Recent Files", icon = " ", key = "r" },
            { action = builtin.live_grep, desc = " Find Text", icon = " ", key = "g" },
            { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
            { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit", icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return {
              "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
            }
          end,
        },
      }

      -- General
      -- DashboardHeader DashboardFooter
      -- -- Hyper theme
      -- DashboardProjectTitle DashboardProjectTitleIcon DashboardProjectIcon
      -- DashboardMruTitle DashboardMruIcon DashboardFiles DashboardShortCutIcon
      -- -- Doome theme
      -- DashboardDesc DashboardKey DashboardIcon DashboardShortCut


      -- Setup highlights
      vim.cmd([[
        :hi DashboardProjectTitle guifg=#a6e3a1
        :hi DashboardMruTitle guifg=#a6e3a1
        ]])

      vim.defer_fn(
        function()
          vim.api.nvim_create_autocmd(
            'BufDelete',
            {
              group    = vim.api.nvim_create_augroup('open-dashboard-after-last-buffer-close', { clear = true }),
              callback = function(event)
                for buf = 1, vim.fn.bufnr('$') do
                  if buf ~= event.buf and vim.fn.buflisted(buf) == 1 then
                    if vim.api.nvim_buf_get_name(buf) ~= '' and vim.bo[buf].filetype ~= 'dashboard' then
                      return
                    end
                  end
                end

                vim.cmd('Dashboard')
              end,
            }
          )
        end,
        0
      )

      return opts
    end,
  },

  -- Replacement for vm.ui.select
  {
    "nvim-telescope/telescope-ui-select.nvim",
    after = "nvim-lspconfig",
  },

  -- Telescope config
  {
    "nvim-telescope/telescope.nvim",
    module = "telescope",
    override_options = function()
      return {
        extentions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
        extensions_list = { "themes", "terms", "ui-select" },
      }
    end,
  },

  -- Line and blockwise commenting
  {
    'numToStr/Comment.nvim',
    lazy = false,
    config = function()
      require('Comment').setup()
    end
  },


  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },
  },

  -- Seamless Tmux pane navigation
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
      -- { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  -- Highlight TODOs in code
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufEnter",
    opts = {},
  },

  -- Multicursor
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup() -- Add a cursor and jump to the next word under cursor.
      vim.keymap.set({ "n", "v" }, "<c-n>", function() mc.addCursor("*") end)

      vim.keymap.set({ "n" }, "<m-j>", function() mc.addCursor("j") end, { desc = "Add cursor downwards" })
      vim.keymap.set({ "n" }, "<m-k>", function() mc.addCursor("k") end, { desc = "Add cursor upwards" })
      vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
      vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    end
  }

}
