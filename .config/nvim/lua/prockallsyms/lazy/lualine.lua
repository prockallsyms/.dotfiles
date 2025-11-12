return {
	"nvim-lualine/lualine.nvim",

	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"folke/trouble.nvim",
		-- "frankroeder/parrot.nvim",
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

		if vim.env.TMUX then
			vim.api.nvim_create_autocmd({ "FocusGained", "ColorScheme" }, {
				callback = function()
					vim.defer_fn(function()
						vim.opt.laststatus = 0
					end, 100)
				end,
			})

			vim.o.laststatus = 0
		end
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

		--[[
		local function parrot_status()
			local status_info = require("parrot.config").get_status_info()
			local status = ""
			if status_info.is_chat then
				status = status_info.prov.chat.name
			else
				status = status_info.prov.command.name
			end
			return string.format("%s(%s)", status, status_info.model)
		end
		--]]

		return {
			sections = {
				-- lualine_a = { parrot_status },
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
