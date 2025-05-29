local autocmd = vim.api.nvim_create_autocmd

-- remap capslock to escape and set leader key to space
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Caps>", "<Esc>", { silent = true })
vim.g.mapleader = " "

vim.keymap.set("n", "<Leader>cl", "v$\"*y", { silent = true, desc = "Copy line to clipboard" })
vim.keymap.set("n", "<Leader>cc", "\"*y", { silent = true, desc = "Copy selection to clipboard" })

local builtin = require("telescope.builtin")
-- telescope test mapping
vim.keymap.set("n", "<Leader>nn", builtin.builtin, { desc = "Telescope test mapping (builtin.builtin)" })

-- file finding remaps
vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "[F]ind [F]ile with from root" })
vim.keymap.set("n", "<Leader>fg", builtin.git_files, { desc = "[F]ind non-i[G]nored file from git root" })
vim.keymap.set("n", "<Leader>lg", builtin.live_grep, { desc = "[L]ive [G]rep files from git root" })

-- buffer remaps
vim.keymap.set("n", "<Leader>bb", builtin.buffers, { desc = "[B]uiltin [B]uffers, enumerates open buffers" })
vim.keymap.set("n", "<Leader>bc", function() vim.cmd('bd') end, { desc = "[B]uffer [C]lose" })
vim.keymap.set("n", "<Leader><Leader>", function() vim.cmd('b#') end, { desc = "Swap to last open buffer" })

-- LSP remaps
autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(args)
	vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
	local opts = { buffer = args.buf }
	-- lsp keymaps
	vim.keymap.set("n", "<Leader>lr", builtin.lsp_references, { desc = "[L]SP [R]eferences to symbol" })
	vim.keymap.set("n", "<Leader>ls", builtin.lsp_document_symbols, { desc = "[L]SP [S]ymbols in current buffer" })
	vim.keymap.set("n", "<Leader>li", builtin.lsp_implementations, { desc = "[L]SP [I]mplementation of symbol" })
	vim.keymap.set("n", "<Leader>ld", builtin.lsp_definitions, { desc = "[L]SP [D]efinition of symbol" })
	vim.keymap.set("n", "<Leader>lt", builtin.lsp_type_definitions, { desc = "[L]SP [T]ype definitions of symbol" })
	vim.keymap.set("n", "<Leader>bf", function() vim.lsp.buf.format({ timeout = 5000 }) end, { desc = "[B]uffer [F]ormat the current buffer" })
	vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, { desc = "[E]rror [D]iagnostic" })
	vim.keymap.set("n", "<Leader>dl", vim.diagnostic.setloclist, { desc = "[D]iagnostic [L]ist" })

	opts.desc = "LSP [H]over"
	vim.keymap.set("n", "<Leader>h", vim.lsp.buf.hover, opts)

	opts.desc = "LSP [C]ode [A]ction"
	vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)

	opts.desc = "[W]orkspace [A]dd folder"
	vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, opts)

	opts.desc = "[W]orkspace [R]emove folder"
	vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, opts)

	opts.desc = "List [W]orkspace [F]olders"
	vim.keymap.set("n", "<Leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
	if vim.lsp.inlay_hint then
	    vim.lsp.inlay_hint.enable(true, opts)
	end
    end,
})

-- git remaps
vim.keymap.set("n", "<Leader>gs", builtin.git_status, { desc = "[G]it [S]tatus" })
vim.keymap.set("n", "<Leader>gbr", builtin.git_branches, { desc = "[G]it [B]ranches" })
vim.keymap.set("n", "<leader>gg", vim.cmd.Git, { desc = "Use Fugitive Git" })
local prockallsyms_Fugitive = vim.api.nvim_create_augroup("prockallsyms_Fugitive", {})
autocmd("BufWinEnter", {
    group = prockallsyms_Fugitive,
    pattern = "*",
    callback = function()
	if vim.bo.filetype == "fugitive" then
	    return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local opts = { buffer = bufnr, remap = false }

	opts.desc = "[G]it [Push]"
	vim.keymap.set("n", "<leader>gpush", function() vim.cmd.Git("push") end, opts)
	--
	-- rebase always
	opts.desc = "[G]it [Pull]"
	vim.keymap.set("n", "<leader>gpull", function() vim.cmd.Git("pull --rebase") end, opts)

	opts.desc = "[G]it [C]ommit"
	vim.keymap.set("n", "<leader>gc",
	function()
	    vim.ui.input({ prompt = "Commit Message: " },
	    function(input)
		vim.cmd.Git("commit -m \"" .. input .. "\"")
	    end)
	end, opts)
    end,
})

-- AI specific remaps
vim.keymap.set({"n", "v"}, "<Leader>aa", "<cmd>CodeCompanionActions<CR>", { desc = "[A]I [A]ctions" })
vim.keymap.set({"n", "v"}, "<Leader>at", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "[A]I [T]oggle Chat" })
vim.keymap.set("v", "<Leader>ai", "<cmd><,'>CodeCompanion<CR>", { desc = "Begin [A]I [I]nline Prompt" })

-- Go filetype-specific keymaps
autocmd("FileType", {
    pattern = "go",
    callback = function(event)
	vim.keymap.set("n", "<Leader>gat", "<cmd>GoAddTag<CR>", { desc = "[G]o [A]dd JSON [T]ags to the struct I'm in" })
	vim.keymap.set("n", "<Leader>gfs", "<cmd>GoFillStruct<CR>", { desc = "[G]o [F]ill [S]truct" })
	vim.keymap.set("n", "<Leader>gfm", "<cmd>GoFillSwitch<CR>", { desc = "[G]o [F]ill switch ([M]atch statement kinda)" })
	vim.keymap.set("n", "<Leader>gie", "<cmd>GoIfErr<CR>", { desc = "Add a [G]o [I]f [E]rr statement" })
	vim.keymap.set("n", "<Leader>gr", "<cmd>GoRun<CR>", { desc = "[G]o [R]un" })
	vim.keymap.set("n", "<Leader>gt", "<cmd>GoTest<CR>", { desc = "[G]o [T]est" })
	vim.keymap.set("n", "<Leader>gbd", "<cmd>GoBuild<CR>", { desc = "[G]o [B]uild" })
	vim.keymap.set("n", "<Leader>gmi", "<cmd>GoModInit<CR>", { desc = "[G]o [M]od [I]nit" })
	vim.keymap.set("n", "<Leader>gmt", "<cmd>GoModTidy<CR>", { desc = "[G]o [M]od [T]idy" })
    end,
})

--[[ Rust filetype-specific keymaps
autocmd("FileType", {
    pattern = "rs",
    callback = function(event)
	vim.keymap.set("n", "<Leader>_", "", { desc = "" })
    end,
})
--]]
