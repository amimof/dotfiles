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
      ensure_installed = {
        "gopls",
        "gofumpt",
        "goimports",
        "lua-language-server",
        "stylua",
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
    "nvimdev/dashboard-nvim",
    lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
    opts = function()
      local logo = [[
         ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
         ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z
         ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z
         ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z
         ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
         ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
    ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local builtin = require("telescope.builtin")

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = builtin.find_files, desc = " Find File", icon = " ", key = "f" },
            { action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
            { action = builtin.oldfiles, desc = " Recent Files", icon = " ", key = "r" },
            { action = builtin.live_grep, desc = " Find Text", icon = " ", key = "g" },
            { action = 'lua LazyVim.pick.config_files()()', desc = " Config", icon = " ", key = "c" },
            { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
            { action = "LazyExtras", desc = " Lazy Extras", icon = " ", key = "x" },
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

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- open dashboard after closing lazy
      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end

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

  -- Comment/Uncomment code
  {
    "numToStr/Comment.nvim",
    init = function()
      require("Comment").setup()
    end,
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
}
