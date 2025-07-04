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
					on_attach = function(client, bufnr) end,
					actions = true,
					completion = false,
					hover = true,
				},
				completion = {
					cmp = {
						enabled = true,
					},
				},
			})
		end,
	},
	{
		"nwiizo/cargo.nvim",
		ft = { "rust" },
		build = "cargo build --release",
		config = function()
			require("cargo").setup({
				float_window = true,
				window_width = 0.8,
				window_height = 0.8,
				border = "rounded",
				auto_close = true,
				close_timeout = 5000,
			})
		end,
		cmd = {
			"CargoBench",
			"CargoBuild",
			"CargoClean",
			"CargoDoc",
			"CargoNew",
			"CargoRun",
			"CargoRunTerm",
			"CargoTest",
			"CargoUpdate",
			"CargoCheck",
			"CargoClippy",
			"CargoAdd",
			"CargoRemove",
			"CargoFmt",
			"CargoFix"
		}
	},
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			lsp_cfg = true,
			lsp_semantic_highlights = true,
		},
		ft = { "go", "gomod" },
		event = { "CmdLineEnter" },
		build = ":lua require('go.install').update_all_sync()",
		config = function(lp, opts)
			require("go").setup(opts)
			local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = format_sync_grp,
				pattern = "*.go",
				callback = function()
					require('go.format').goimports()
				end,
			})
			return {}
		end
	},
}
