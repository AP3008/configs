return {
  'mrcjkb/rustaceanvim',
  version = '^5',
  lazy = false,
  config = function()
    vim.g.rustaceanvim = {
      server = {
        -- This is the magic bit for standalone files
        standalone = true, 
        default_settings = {
          ['rust-analyzer'] = {
            checkOnSave = {
              command = "clippy",
            },
            -- This helps with single-file performance
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
          },
        },
      },
    }
  end
}
