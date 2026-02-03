return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                -- Including the specific servers you've installed for Python and Web
                ensure_installed = { 
                    "lua_ls", "basedpyright", "ts_ls", 
                    "html", "cssls", "bashls" 
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Define your servers
            local servers = { "lua_ls", "basedpyright", "ts_ls", "html", "cssls", "bashls" }

            -- Modern way to apply global capabilities (replaces util.default_config)
            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            -- Modern configuration for specific LSPs
            -- Note: We use vim.lsp.config to define settings, then vim.lsp.enable to start them
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })

            -- Basedpyright is better for your Python projects (CityScope/Savify)
            vim.lsp.config("basedpyright", {
                settings = {
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "basic", -- High performance for large projects
                        }
                    }
                }
            })

            -- Enable all servers
            for _, lsp in ipairs(servers) do
                vim.lsp.enable(lsp)
            end
            
            -- Keymaps remain the same
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
        end,
    },
}
