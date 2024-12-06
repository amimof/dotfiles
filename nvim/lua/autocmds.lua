-- The following two autocommands are used to highlight references of the
-- word under your cursor when your cursor rests there for a little while.
--    See `:help CursorHold` for information about when this is executed
--
-- When you move your cursor, the highlights will be cleared (the second autocommand).
-- TODO: Changecolor of highlighted text so it's a little more subtle
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- A auto-cleanup function to close empty [No Name] buffers on specific events
vim.api.nvim_create_autocmd({ "BufEnter", "BufDelete", "FileType" }, {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_get_name(bufnr) == "" and vim.bo[bufnr].buflisted then
      vim.cmd("bdelete " .. bufnr)
    end
  end,
})

-- Opens Nvdash if no other buffers exists. Prevents Neovim from creating a lot of [No Name] buffers
-- vim.api.nvim_create_autocmd({ "BufEnter", "BufDelete", "FileType" }, {
--   callback = function(args)
--     if args.event == "FileType" then
--       vim.o.showtabline = vim.bo.ft == "nvdash" and 0 or 2
--       return
--     end
--
--     local buf = args.buf
--
--     if not vim.bo[buf].buflisted then
--       return
--     end
--
--     vim.schedule(function()
--       if #vim.t.bufs == 1 and vim.api.nvim_buf_get_name(buf) == "" then
--         vim.cmd "Nvdash"
--       end
--     end)
--   end,
-- })
