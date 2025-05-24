return {
	"nvim-lualine/lualine.nvim",

	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"folke/trouble.nvim",
	},

	lazy = false,

	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { statusline = { "alpha" } },
			},
			sections = {
				lualine_c = {}
			},
		})
	end,

	opts = function()
		local trouble = require("trouble")
		local symbols = trouble.statusline({
			mode = "lsp_document_symbols",
			groups = {},
			title = false,
			filter = { range = true },
			format = "{kind_icon}{symbol.name:Normal}",
			hl_group = "lualine_c_normal"
		})
		return {
			sections = {
				lualine_c = {
					{ "filename" },
					{
						symbols.get,
						cond = symbols.has,
					},
				},
			},
		}
	end,
}
