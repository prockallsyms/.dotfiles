return {
	{
		"j-hui/fidget.nvim",
	},
	{
		"vimpostor/vim-tpipeline",
		dependencies = 'nvim-lualine/lualine.nvim',
		event = "VeryLazy", 
	},
	{
		"nvim-lua/plenary.nvim",
		name = "plenary"
	},

	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},

	{
		"sharkdp/fd",
		lazy = true,
	},

	{
		'vuciv/golf',
		lazy = true,
	},

	{
		"airblade/vim-rooter",
		lazy = true,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = true })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
