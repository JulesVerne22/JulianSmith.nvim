-- Add Mason LSP servers here to auto-install them
return {
    servers = {
        clangd = {},
        gopls = {},
        pyright = {},
        rust_analyzer = {},
        ts_ls = {},
        bashls = {},
        -- helm_ls = {},
        -- tflint = {},
        -- terraformls = {},

        lua_ls = {
            Lua = {
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            },
        },
    },
    daps = {
        'delve',
        'codelldb',
    },
    formattersAndLinters = {
        'stylua',
        'eslint_d',
        'flake8',
        'black',
        'gofumpt',
        'prettier',
        'clang-format',
        'commitlint',
    },
}
