local lsp = require('lsp-zero').preset({
    name = 'minimal',
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = true
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.setup()

require'lspconfig'.lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'love' }
            }
        }
    }
}
