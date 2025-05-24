return {
	"folke/zen-mode.nvim",
	config = function()
		vim.keymap.set("n", "<Leader>zz", function()
			require("zen-mode").setup({
				window = {
					width = 0.8,
					height = 1,
					options = {
						number = true,
						relativenumber = true,
					},
				},

				plugins = {
					tmux = { enabled = false },
					-- alacritty = { enabled = true, font = "+4" },
					options = {
						laststatus = 3,
					}
				},

				-- enable statusline for lualine
			})

			require("zen-mode").toggle()
			vim.wo.wrap = false
		end)
	end,
}
