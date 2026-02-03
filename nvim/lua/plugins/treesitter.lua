return {
    {
        "MeanderingProgrammer/treesitter-modules.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        lazy = false,
        priority = 1000,
        opts = {
            ensure_installed = { 
                "python", 
                "c", 
                "lua", 
                "javascript", 
                "typescript", 
                "bash", 
                "html", 
                "css", 
                "markdown", 
                "markdown_inline", 
                "vimdoc",
                "java"
            },
            sync_install = false,
            auto_install = false,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = 'gnn',
                    node_incremental = 'grn',
                    scope_incremental = 'grc',
                    node_decremental = 'grm',
                },
            },
        },
        config = function(_, opts)
            local ts = require('treesitter-modules')
            ts.setup(opts)

            vim.keymap.set('n', 'gnn', ts.init_selection)
            vim.keymap.set('x', 'grn', ts.node_incremental)
            vim.keymap.set('x', 'grc', ts.scope_incremental)
            vim.keymap.set('x', 'grm', ts.node_decremental)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufRead",
        opts = { multiwindow = true },
    },
}
