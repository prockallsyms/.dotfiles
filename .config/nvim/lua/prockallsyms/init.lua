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

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
