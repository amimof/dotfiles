-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua
---@type ChadrcConfig
local M = {
  type = "dark",
  ui = {
    theme = "tokyodark",
    telescope = {
      style = "bordered",
    },
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
