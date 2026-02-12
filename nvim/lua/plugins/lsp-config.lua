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
                ensure_installed = { 
                    "lua_ls", "basedpyright", "ts_ls", 
                    "html", "cssls", "bashls", "rust_analyzer" 
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- 1. GLOBAL DIAGNOSTICS (Inline Errors)
            vim.diagnostic.config({
                virtual_text = {
                    spacing = 4,
                    prefix = "●",
                },
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = { border = "rounded" },
            })

            -- 2. TOGGLE DIAGNOSTICS KEYMAP
            vim.keymap.set('n', '<leader>td', function()
                local is_enabled = vim.diagnostic.is_enabled()
                vim.diagnostic.enable(not is_enabled)
                print("Diagnostics: " .. (not is_enabled and "ON" or "OFF"))
            end, { desc = "Toggle Inline Errors" })

            local servers = { "lua_ls", "basedpyright", "ts_ls", "html", "cssls", "bashls"}


            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })

            vim.lsp.config("basedpyright", {
                settings = {
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "basic",
                        }
                    }
                }
            })

            -- Enable all servers
            for _, lsp in ipairs(servers) do
                vim.lsp.enable(lsp)
            end
            
            -- Keymaps
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
        end,
    },
}
