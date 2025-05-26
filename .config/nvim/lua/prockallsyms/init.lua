require("prockallsyms.opt")
require("prockallsyms.var")
require("prockallsyms.lazy_init")
require("prockallsyms.remap")

local augroup = vim.api.nvim_create_augroup
local prockallsyms = augroup('prockallsyms', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 75,
		})
	end,
})

autocmd("BufWritePre", {
	group = prockallsyms,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- activate nvim-cmp completions for crates.nvim lazily
local crates_cmp = augroup('CmpSourceCargo', { clear = true })
autocmd('BufRead', {
	group = crates_cmp,
	pattern = "Cargo.toml",
	callback = function()
		cmp.setup.buffer({ sources = { { name = "crates" } } })
	end,
})

autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(args)
		vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
		local opts = { buffer = args.buf }
		-- lsp keymaps
		vim.keymap.set("n", "<Leader>bf", function() vim.lsp.buf.format({ timeout = 5000 }) end,
			{ desc = "[B]uffer [F]ormat the current buffer" })
		vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float)
		vim.keymap.set("n", "<Leader>dl", vim.diagnostic.setloclist)
		vim.keymap.set("n", "<Leader>h", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<Leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
		if vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(true, opts)
		end
	end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
