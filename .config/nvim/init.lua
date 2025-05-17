local vim = vim
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Caps>", "<Esc>", { silent = true })
vim.g.mapleader = " "
vim.keymap.set("n", "<Leader>cl", "v$\"*y", { silent = true})
vim.keymap.set("n", "<Leader>cc", "\"*y", { silent = true})
vim.g.auto_focus = true
vim.g.rustfmt_autosave = 1
vim.g.rustfmt_emit_files = 1
vim.g.rustfmt_fail_silently = 0
vim.o.termguicolors = true

local set = vim.opt
set.nu = true
set.rnu = true
set.so = 3
set.shiftwidth = 4
set.softtabstop = 4
set.tabstop = 4
set.expandtab = false
set.vb = true
set.wildmode = "list:longest"
set.wildignore = ".hg,.svn,*~,*.png,*.jpg,*.mov,*.mp3,*.mp4,*.exe,*.min.js,*.gif,*.swp,*.o,vendor"

function map(mode, lhs, rhs, opts)
	 local options = { noremap = true }
	 if opts then
		 options = vim.tbl_extend("force", options, opts)
	 end
	 vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('i', "{<CR>", "{<CR>}<Esc>O")

local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('nvim-telescope/telescope.nvim')
Plug('nvim-lua/plenary.nvim')
Plug('sharkdp/fd')
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug('tpope/vim-surround')
Plug('tpope/vim-sleuth')
Plug('nvim-lualine/lualine.nvim')
Plug('machakann/vim-highlightedyank')
Plug('airblade/vim-rooter')
Plug('williamboman/mason.nvim')
Plug('williamboman/mason-lspconfig.nvim')
Plug('neovim/nvim-lspconfig')
Plug('rust-lang/rust.vim')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-nvim-lsp-signature-help')
Plug('hrsh7th/cmp-nvim-lua')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-vsnip')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/vim-vsnip')
Plug('voldikss/vim-floaterm')
Plug('ray-x/go.nvim')
Plug('vuciv/golf')

vim.call('plug#end')

local cmp = require'cmp'
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
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<Tab>'] = cmp.mapping.confirm({ select = true }),
		}),
		sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'vsnip' },
		}, {
				{ name = 'buffer' },
		}, {
				{ name = 'nvim_lsp_signature_help' },
		})
})

cmp.setup.cmdline(':', {
		source = cmp.config.sources({
				{ name = 'path' }
		})
})

require("nvim-web-devicons").setup{}
require("nvim-treesitter").setup{
	ensure_installed = { "go", "rust", "toml", "diff", "lua" },
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true
	}
}
require("telescope").setup{}
require("lualine").setup{}
require("mason").setup{}
require("mason-lspconfig").setup{ 
    automatic_enable = false,
    ensure_installed = {"lua_ls", "rust_analyzer", "gopls"} 
}
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup{ capabilities = capabilities }
lspconfig.ruby_lsp.setup{ capabilities = capabilities }
lspconfig.jdtls.setup{ capabilities = capabilities }
lspconfig.clangd.setup{ capabilities = capabilities }
lspconfig.gopls.setup{ capabilities = capabilities }
require("go").setup{ 
    lsp_cfg = { capabilities = capabilities},
    gofmt = "gopls",
    fillstruct = "gopls",
    lsp_semantic_highlights = true,
}
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        require('go.format').goimports()
    end,
    group = format_sync_grp,
})

lspconfig.rust_analyzer.setup {
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
}

vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('UserLspConfig', {}),
		callback = function(args)
				vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
				local opts = { buffer = args.buf }
				vim.keymap.set("n", "<Leader>h", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, opts)
				vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
				vim.keymap.set("n", "<Leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folder())) end, opts)

				-- for when _inline_ inlay hints become stable
				if vim.lsp.inlay_hint then
					vim.lsp.inlay_hint.enable(true, opts)
				end

				-- client.server_capabilities.semanticTokensProvider = nil
		end,
})


local builtin = require("telescope.builtin")

-- test mapping
vim.keymap.set("n", "<Leader>nn", builtin.builtin, { desc = "Telescope test mapping (builtin.builtin)" })

-- file finding remaps
vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "[F]ind [F]ile with from root" })
vim.keymap.set("n", "<Leader>fg", builtin.git_files, { desc = "[F]ind non-i[G]nored file from root" })

-- LSP remaps
vim.keymap.set("n", "<Leader>lr", builtin.lsp_references, { desc = "[L]SP [R]eferences to symbol" })
vim.keymap.set("n", "<Leader>ls", builtin.lsp_document_symbols, { desc = "[L]SP [S]ymbols in current buffer" })
vim.keymap.set("n", "<Leader>li", builtin.lsp_implementations, { desc = "[L]SP [I]mplementation of symbol" })
vim.keymap.set("n", "<Leader>ld", builtin.lsp_definitions, { desc = "[L]SP [D]efinition of symbol" })
vim.keymap.set("n", "<Leader>lt", builtin.lsp_type_definitions, { desc = "[L]SP [T]ype definitions of symbol" })

-- git remaps
vim.keymap.set("n", "<Leader>gs", builtin.git_status, { desc = "[G]it [S]tatus" })

-- buffer remaps
vim.keymap.set("n", "<Leader>bb", builtin.buffers, { desc = "[B]iultin [B]uffers, enumerates open buffers" })
vim.keymap.set("n", "<Leader>bc", function() vim.cmd('bd') end, { desc = "[B]uffer [C]lose" })
vim.keymap.set("n", "<Leader><Leader>", function() vim.cmd('b#') end, { desc = "Swap to last open buffer" })

-- lsp keymaps
vim.keymap.set("n", "<Leader>bf", function() vim.lsp.buf.format({ timeout = 5000 }) end, { desc = "[B]uffer [F]ormat the current buffer" })
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<Leader>dl", vim.diagnostic.setloclist)

-- floating terminal remaps
vim.keymap.set("n", "<Leader>t", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 fish <CR> ", { desc = "opens a [T]erminal" })
vim.keymap.set("n", "t", ":FloatermToggle myfloat<CR>", { desc = "Re-opens your [T]erminal" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>:q<CR>", { desc = "Backgrounds your [T]erminal" })

-- filetype-specific keymaps
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function(event)
	vim.keymap.set("n", "<Leader>gat", ":GoAddTag<CR>", { desc = "[G]o [A]dd JSON [T]ags to the struct I'm in" })
	vim.keymap.set("n", "<Leader>gfs", ":GoFillStruct<CR>", { desc = "[G]o [F]ill [S]truct" })
	vim.keymap.set("n", "<Leader>gfm", ":GoFillSwith<CR>", { desc = "[G]o [F]ill switch ([M]atch statement kinda)" })
	vim.keymap.set("n", "<Leader>gie", ":GoIfErr<CR>", { desc = "Add a [G]o [I]f [E]rr statement" })
	vim.keymap.set("n", "<Leader>gr", ":GoRun<CR>", { desc = "[G]o [R]un" })
	vim.keymap.set("n", "<Leader>gt", ":GoTest<CR>", { desc = "[G]o [T]est" })
	vim.keymap.set("n", "<Leader>gb", ":GoBuild<CR>", { desc = "[G]o [B]uild" })
	vim.keymap.set("n", "<Leader>gmi", ":GoModInit<CR>", { desc = "[G]o [M]od [I]nit" })
	vim.keymap.set("n", "<Leader>gmt", ":GoModTidy<CR>", { desc = "[G]o [M]od [T]idy" })
    end,
})
