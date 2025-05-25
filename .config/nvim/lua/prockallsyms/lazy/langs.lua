return {
	{
		"rust-lang/rust.vim",
		event = "BufEnter *.rs",
		opts = {},
	},
	{
		"ray-x/go.nvim",
		event = "BufEnter *.go",
		config = function()
			local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					require('go.format').goimports()
				end,
				group = format_sync_grp,
			})

			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities()
			)

			return {
				lsp_cfg = { capabilities = capabilities },
				gofmt = "gopls",
				fillstruct = "gopls",
				lsp_semantic_highlights = true,
			}
		end
	},
}
