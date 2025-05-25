return {
	{
		'rust-lang/rust.vim',
		ft = { 'rust' },
		config = function()
			vim.g.auto_focus = true
			vim.g.rustfmt_autosave = 1
			vim.g.rustfmt_emit_files = 1
			vim.g.rustfmt_fail_silently = 0
		end,
	},
	{
		'saecki/crates.nvim',
		event = { "BufRead Cargo.toml" },
		tag = 'stable',
		config = function()
			require('crates').setup({
				lsp = {
					enabled = true,
					on_attack = function(client, bufnr) end,
					actions = true,
					completion = false,
					hover = true,
				},
				completions	= {
					cmp = {
						enabled = true,
					},
				},
			})
		end,
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
