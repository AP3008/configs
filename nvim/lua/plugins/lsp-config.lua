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
					"lua_ls",
					"basedpyright",
					"ts_ls",
					"html",
					"cssls",
					"bashls",
					"rust_analyzer",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/nvim-cmp", -- Added this to manage the completion window
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local cmp = require("cmp")

			-- 1. TAMING THE COMPLETION WINDOW (Part 2)
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					-- Scroll through the small suggestion box with Tab
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),

					['<C-j>'] = cmp.mapping.select_next_item(),
                    ['<C-k>'] = cmp.mapping.select_prev_item(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", max_item_count = 15 }, -- Limits total items
				}),
				performance = {
					max_view_entries = 7, -- Only 7 lines high
				},
				window = {
					-- This creates the small, scrollable box
					completion = cmp.config.window.bordered({
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
						max_height = 10,
					}),
					-- This hides the giant "Doc" box unless you have enough room
					documentation = cmp.config.disable,
				},
				formatting = {
					fields = { "abbr", "menu" }, -- Removed 'kind' to make it narrower
					format = function(entry, vim_item)
						vim_item.abbr = string.sub(vim_item.abbr, 1, 20)
						return vim_item
					end,
				},
			})
			-- 2. GLOBAL DIAGNOSTICS (Inline Errors)
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

			-- 3. TOGGLE DIAGNOSTICS KEYMAP
			vim.keymap.set("n", "<leader>td", function()
				local is_enabled = vim.diagnostic.is_enabled()
				vim.diagnostic.enable(not is_enabled)
				print("Diagnostics: " .. (not is_enabled and "ON" or "OFF"))
			end, { desc = "Toggle Inline Errors" })

			local servers = { "lua_ls", "basedpyright", "ts_ls", "html", "cssls", "bashls" }

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- ... (rest of your lua_ls and basedpyright config stays the same)
			vim.lsp.config("lua_ls", {
				settings = { Lua = { diagnostics = { globals = { "vim" } } } },
			})

			vim.lsp.config("basedpyright", {
				settings = { basedpyright = { analysis = { typeCheckingMode = "basic" } } },
			})

			-- Enable all servers
			for _, lsp in ipairs(servers) do
				vim.lsp.enable(lsp)
			end

			-- Keymaps
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
