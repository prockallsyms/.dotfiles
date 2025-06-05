return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"BurntSushi/ripgrep",
		"sharkdp/fd",
		{ "nvim-telescope/telescope-fzf-native.nvim", build ="make", },
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
	},
	lazy = false,
	opts = {
		extensions = {
			fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
		},
	},
	config = function(_, opts)
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("git_worktree")
	end,
}
