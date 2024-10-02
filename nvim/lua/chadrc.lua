-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua
---@type ChadrcConfig
local M = {
  base46 = {
    theme = "tokyodark",
    theme_toggle = { "tokyodark", "ayu_light" }
  },
  ui = {
    telescope = {
      style = "bordered",
    },
    tabufline = {
      enabled = true,
      order = { "treeOffset", "buffers", "tabs", "btns" }
    },
    mason = {
      cmd = true,
      pkgs = {
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
      }
    },
    lsp = { signature = true }
    -- nvdash = {
    --   load_on_startup = true
    -- }
    -- hl_override = {
    -- 	["@scope"] = {
    -- 		fg = "red",
    -- 	},
    -- 	IndentBlanklineContextChar = { bg = "red" },
    -- 	FoldColumn = {
    -- 		fg = "red",
    -- 	},
    -- 	LineNr = {
    -- 		fg = "red",
    -- 	},
    -- },
    -- hl_override = {
    --   LspReferenceText = {
    --     bg = "black",
    --   },
    --   LspReferenceRead = {
    --     bg = "black",
    --   },
    --   LspReferenceWrite = {
    --     bg = "black",
    --   },
    -- },
  },
}

return M
