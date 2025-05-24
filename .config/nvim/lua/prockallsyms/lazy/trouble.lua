return {
	"folke/trouble.nvim",
	lazy = false,
	depends = { "nvim-tree/nvim-web-devicons" },
	opts = {},
	cmd = "Trouble",
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = ""
		},
		{
			"[t",
			"<cmd>Trouble diagnostics next jump=true<cr>",
			desc = ""
		},
		{
			"]t",
			"<cmd>Trouble diagnostics prev jump=true<cr>",
			desc = ""
		},
	},
}
