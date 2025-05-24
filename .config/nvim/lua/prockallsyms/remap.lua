vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Caps>", "<Esc>", { silent = true })
vim.g.mapleader = " "

vim.keymap.set("n", "<Leader>cl", "v$\"*y", { silent = true})
vim.keymap.set("n", "<Leader>cc", "\"*y", { silent = true})

local builtin = require("telescope.builtin")
-- telescope test mapping
vim.keymap.set("n", "<Leader>nn", builtin.builtin, { desc = "Telescope test mapping (builtin.builtin)" })

-- file finding remaps
vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "[F]ind [F]ile with from root" })
vim.keymap.set("n", "<Leader>fg", builtin.git_files, { desc = "[F]ind non-i[G]nored file from root" })

-- LSP remaps
vim.keymap.set("n", "<Leader>lr", builtin.lsp_references, { desc = "[L]SP [R]eferences to symbol" })
vim.keymap.set("n", "<Leader>ls", builtin.lsp_document_symbols, { desc = "[L]SP [S]ymbols in current buffer" })
vim.keymap.set("n", "<Leader>li", builtin.lsp_implementations, { desc = "[L]SP [I]mplementation of symbol" })
vim.keymap.set("n", "<Leader>ld", builtin.lsp_definitions, { desc = "[L]SP [D]efinition of symbol" })
vim.keymap.set("n", "<Leader>lt", builtin.lsp_type_definitions, { desc = "[L]SP [T]ype definitions of symbol" })

-- git remaps
vim.keymap.set("n", "<Leader>gs", builtin.git_status, { desc = "[G]it [S]tatus" })

-- buffer remaps
vim.keymap.set("n", "<Leader>bb", builtin.buffers, { desc = "[B]iultin [B]uffers, enumerates open buffers" })
vim.keymap.set("n", "<Leader>bc", function() vim.cmd('bd') end, { desc = "[B]uffer [C]lose" })
vim.keymap.set("n", "<Leader><Leader>", function() vim.cmd('b#') end, { desc = "Swap to last open buffer" })

-- Go filetype-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function(event)
	vim.keymap.set("n", "<Leader>gat", ":GoAddTag<CR>", { desc = "[G]o [A]dd JSON [T]ags to the struct I'm in" })
	vim.keymap.set("n", "<Leader>gfs", ":GoFillStruct<CR>", { desc = "[G]o [F]ill [S]truct" })
	vim.keymap.set("n", "<Leader>gfm", ":GoFillSwitch<CR>", { desc = "[G]o [F]ill switch ([M]atch statement kinda)" })
	vim.keymap.set("n", "<Leader>gie", ":GoIfErr<CR>", { desc = "Add a [G]o [I]f [E]rr statement" })
	vim.keymap.set("n", "<Leader>gr", ":GoRun<CR>", { desc = "[G]o [R]un" })
	vim.keymap.set("n", "<Leader>gt", ":GoTest<CR>", { desc = "[G]o [T]est" })
	vim.keymap.set("n", "<Leader>gb", ":GoBuild<CR>", { desc = "[G]o [B]uild" })
	vim.keymap.set("n", "<Leader>gmi", ":GoModInit<CR>", { desc = "[G]o [M]od [I]nit" })
	vim.keymap.set("n", "<Leader>gmt", ":GoModTidy<CR>", { desc = "[G]o [M]od [T]idy" })
    end,
})

--[[ Rust filetype-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rs",
    callback = function(event)
		vim.keymap.set("n", "<Leader>_", "", { desc = "" })
    end,
})
--]]
