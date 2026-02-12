return {
  'mrcjkb/rustaceanvim',
  version = '^5',
  lazy = false,
  config = function()
    vim.g.rustaceanvim = {
      server = {
        -- 1. Enable standalone mode for single-file scripts
        standalone = true,
        default_settings = {
          ['rust-analyzer'] = {
            -- 2. This helps find files that aren't explicitly in a module tree
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                    enable = true,
                },
            },
            -- 3. Proc-macros are essential for high-level Rust crates
            procMacro = {
                enable = true,
            },
            checkOnSave = {
                command = "clippy",
            },
            -- 4. This specifically addresses the "not in module tree" error
            diagnostics = {
                disabled = { "unresolved-proc-macro" },
            },
          },
        },
      },
    }
  end
}
