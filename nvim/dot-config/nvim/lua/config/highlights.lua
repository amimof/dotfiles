local M = {}

function M.apply()
	-- Normal
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

	-- NeoTree
	vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "#08090c", })
	vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "#08090c", })
	vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "#08090c", })

	-- Blink
	vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#0b0d11", })
	vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "#0b0d11", })
	vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#0b0d11", })
	vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "#0b0d11", })
end

return M
