return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-vsnip",
		"hrsh7th/vim-vsnip",
		"zbirenbaum/copilot-cmp",
	},

	--
	config = function()
		local cmp = require('cmp')
		local cmp_lsp = require('cmp_nvim_lsp')
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)
		require("mason").setup({})
		require("mason-lspconfig").setup({
			automatic_enable = true,
			ensure_installed = {"lua_ls", "rust_analyzer", "gopls"},
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup {
						capabilities = capabilities
					}
				end,

				["rust_analyzer"] = function()
					require("lspconfig").rust_analyzer.setup({
						capabilities = capabilities,
						settings = {
							["rust-analyzer"] = {
								cargo = {
									allFeatures = true
								},
								imports = {
									group = {
										enable = true
									}
								},
								completion = {
									postfix = {
										enable = true
									}
								}
							}
						}
					})
				end,

				["gopls"] = function()
					require("lspconfig").gopls.setup({
						capabilities = capabilities,
						settings = {
							gopls = {
								gofumpt = true,
								usePlaceholders = true,
								codelenses = {
									generate = true,
									gc_details = true,
									test = true,
									tidy = true,
									upgrade_dependency = true,
									vendor = true
								},
							}
						}
					})
				end
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					vim.fn["vsnip#anonymous"](args.body) -- For `vsnip`
					-- vim.snippet.expand(args.body)
				end,
			},
			window = {
				--	completion = cmp.config.window.bordered(),
				--	documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				['<C-e>'] = cmp.mapping.abort(),
				['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
				['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
				['<C-u>'] = cmp.mapping.scroll_docs(-4),
				['<C-d>'] = cmp.mapping.scroll_docs(4),
				['<C-y>'] = cmp.mapping.confirm({ select = true }),
				['<C-Space>'] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = 'copilot', group_index = 2 },
				{ name = 'nvim_lsp' },
				{ name = 'vsnip' },
			}, {
				{ name = 'buffer' },
			} --,{
				--{ name = 'nvim_lsp_signature_help' },
			--}
			),
		})
	end
	--]]
}
