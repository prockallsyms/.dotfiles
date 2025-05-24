require("prockallsyms")

local Plug = vim.fn['plug#']
vim.call('plug#begin')

Plug('rust-lang/rust.vim')
Plug('ray-x/go.nvim')

vim.call('plug#end')


--[[
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
}
--]]

