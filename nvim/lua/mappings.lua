-- require "nvchad.mappings"

local map = vim.keymap.set
local builtin = require "telescope.builtin"

-- Toggle NvimTree
map("n", "<C-b>", "<Cmd>NvimTreeToggle<CR>")

-- Find document symbols
map("n", "<leader>ds", builtin.lsp_document_symbols, { desc = "[D]ocument [S]ymbols" })

-- Jump to the definition of the word under your cursor.
--  This is where a variable was first declared, or where a function is defined, etc.
--  To jump back, press <C-t>.
map("n", "<leader>gd", builtin.lsp_definitions, { desc = "[G]oto [D]efinition" })

-- Find references for the word under your cursor.
map("n", "<leader>gr", builtin.lsp_references, { desc = "[G]oto [R]eferences" })

-- Jump to the implementation of the word under your cursor.
--  Useful when your language has ways of declaring types without an actual implementation.
map("n", "<leader>gI", builtin.lsp_implementations, { desc = "[G]oto [I]mplementation" })

-- Jump to the type of the word under your cursor.
--  Useful when you're not sure what type a variable is and you want to see
--  the definition of its *type*, not where it was *defined*.
map("n", "<leader>gD", builtin.lsp_type_definitions, { desc = "Type [D]efinition" })

-- Search through keymappings with telescope
map("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
map("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
map("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
map("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
map("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
map("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
map("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
map("n", "<leader>sl", builtin.lsp_document_symbols, { desc = "[L]SP Document Symbols" })

-- Buffer manipulation
map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "[B]uffer [D]elete" })
map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "[B]uffer [N]ext" })
map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "[B]uffer [P]revious" })

-- Fuzzy search current opened buffer, without preview pane
map("n", "<leader>/", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = "[/] Fuzzily search in current buffer" })

-- Fuzzy search all open files (requires ripgrep)
map("n", "<leader>s/", function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  }
end, { desc = "[S]earch [/] in Open Files" })
