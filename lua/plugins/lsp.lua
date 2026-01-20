return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {},
		},
		opts_extend = { "ensure_installed" },
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")

			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
	{
		-- mason-lspconfig: 自动连接 Mason 和 lspconfig
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "saghen/blink.cmp" },
		opts = {
			-- 确保安装的 LSP 服务器（会自动安装）
			ensure_installed = {},
			-- 自动设置已安装的 LSP
			automatic_installation = true,
            handlers = {
                -- 默认 handler：为所有 LSP 调用 setup（带 blink.cmp capabilities）
                function(server_name)
                    local capabilities = require("blink.cmp").get_lsp_capabilities()
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
            },
			-- handlers: 自动为所有已安装的 LSP 调用 setup
			-- handlers = {
			-- 	-- 默认处理器
			-- 	function(server_name)
			-- 		local capabilities = require("blink.cmp").get_lsp_capabilities()
			-- 		require("lspconfig")[server_name].setup({
			-- 			capabilities = capabilities,
			-- 		})
			-- 	end,

			-- 	-- Lua 特殊配置
			-- 	["lua_ls"] = function()
			-- 		local capabilities = require("blink.cmp").get_lsp_capabilities()
			-- 		require("lspconfig").lua_ls.setup({
			-- 			capabilities = capabilities,
			-- 			settings = {
			-- 				Lua = {
			-- 					diagnostics = { globals = { "vim" } },
			-- 					workspace = {
			-- 						checkThirdParty = false,
			-- 						library = { vim.env.VIMRUNTIME },
			-- 					},
			-- 				},
			-- 			},
			-- 		})
			-- 	end,
			-- },
		},
		-- opts_extend = { "ensure_installed" },
		-- config = function(_, opts)
        --     require("mason-lspconfig").setup(opts)
        -- end,
		opts_extend = { "ensure_installed", "handlers" },
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "saghen/blink.cmp", "williamboman/mason.nvim" },

		-- example calling setup directly for each LSP
		config = function()
			vim.diagnostic.config({
				underline = false,
				signs = false,
				update_in_insert = false,
				virtual_text = { spacing = 2, prefix = "●" },
				severity_sort = true,
				float = {
					border = "rounded",
					-- border = "rounded",
					-- 智能定位：自动根据光标位置调整浮动窗口
					anchor_bias = "auto",  -- 自动选择最佳锚点
				},
			})
			-- 配置 LSP 悬浮窗口的全局行为
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
				-- 智能定位配置
				anchor_bias = "auto",
				max_width = 80,
				max_height = 20,
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
				anchor_bias = "auto",
				max_width = 80,
				max_height = 20,
			})

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					-- 自动为所有支持 inlay hints 的 LSP 配置（默认关闭）
					if client and client.server_capabilities.inlayHintProvider then
						-- 默认关闭，通过快捷键手动开启
						vim.lsp.inlay_hint.enable(false, { bufnr = ev.buf })
					end

					-- vim.keymap.set("n", "K", vim.lsp.buf.hover) -- configured in "nvim-ufo" plugin
					vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
						buffer = ev.buf,
						desc = "[LSP] Show diagnostic",
					})
					vim.keymap.set("n", "<leader>gk", vim.lsp.buf.signature_help, { desc = "[LSP] Signature help" })
					vim.keymap.set(
						"n",
						"<leader>wa",
						vim.lsp.buf.add_workspace_folder,
						{ desc = "[LSP] Add workspace folder" }
					)
					vim.keymap.set(
						"n",
						"<leader>wr",
						vim.lsp.buf.remove_workspace_folder,
						{ desc = "[LSP] Remove workspace folder" }
					)
					vim.keymap.set("n", "<leader>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, { desc = "[LSP] List workspace folders" })

					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "[LSP] Rename" })

					-- 切换 inlay hints 的快捷键（统一处理所有 LSP）
					vim.keymap.set("n", "<leader>th", function()
						local current_state = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
						vim.lsp.inlay_hint.enable(not current_state, { bufnr = ev.buf })
						print(string.format("Inlay hints %s", not current_state and "enabled" or "disabled"))
					end, { buffer = ev.buf, desc = "[LSP] Toggle inlay hints" })
				end,
			})
		end,
	},
	-- {
	-- 	"folke/lazydev.nvim",
	-- 	ft = "lua", -- onbly load for lua files
	-- 	opts = {
	-- 		library = { -- see the configuration section for more details
	-- 			-- load luvit types when the vim.uv word is found
	-- 			{
	-- 				path = "${3rd}/luv/library",
	-- 				words = { "vim%.uv" },
	-- 			},
	-- 		},
	-- 	},
	-- },
	{
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		keys = {
			{
				"<M-F>", -- Alt + Shift + f
				function()
					require("conform").format({
						async = true,
						lsp_format = "fallback",
					})
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				-- lua = { "stylua" },
				-- zig = { "zigfmt" },
				-- cpp = { "clangd" },
				-- Use the "_" filetype to run formatters on filetypes that don't
				-- have other formatters configured.
				["_"] = { "trim_whitespace" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = "BufWritePost",
		config = function()
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					-- try_lint without arguments runs the linters defined in `linters_by_ft`
					-- for the current filetype
					require("lint").try_lint()

					-- You can call `try_lint` with a linter name or a list of names to always
					-- run specific linters, independent of the `linters_by_ft` configuration
					require("lint").try_lint("codespell")
				end,
			})
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
    -- stylua: ignore
    keys = {{
        "<A-j>",
        function()
            vim.diagnostic.jump({
                count = 1
            })
        end,
        mode = {"n"},
        desc = "Go to next diagnostic"
    }, {
        "<A-k>",
        function()
            vim.diagnostic.jump({
                count = -1
            })
        end,
        mode = {"n"},
        desc = "Go to previous diagnostic"
    }, {
        "<leader>gd",
        "<CMD>Trouble diagnostics toggle<CR>",
        desc = "[Trouble] Toggle buffer diagnostics"
    }, {
        "<leader>gs",
        "<CMD>Trouble symbols toggle focus=false<CR>",
        desc = "[Trouble] Toggle symbols "
    }, {
        "<leader>gl",
        "<CMD>Trouble lsp toggle focus=false win.position=right<CR>",
        desc = "[Trouble] Toggle LSP definitions/references/..."
    }, {
        "<leader>gL",
        "<CMD>Trouble loclist toggle<CR>",
        desc = "[Trouble] Location List"
    }, {
        "<leader>gq",
        "<CMD>Trouble qflist toggle<CR>",
        desc = "[Trouble] Quickfix List"
    }, {
        "grr",
        "<CMD>Trouble lsp_references focus=true<CR>",
        mode = {"n"},
        desc = "[Trouble] LSP references"
    }, {
        "gD",
        "<CMD>Trouble lsp_declarations focus=true<CR>",
        mode = {"n"},
        desc = "[Trouble] LSP declarations"
    },  
	    {
        "gd",
        "<CMD>Trouble lsp_definitions focus=true<CR>",  -- ✅ 修复：改为 definitions
        mode = {"n"},
        desc = "[Trouble] Go to definition"
    },
	   {
        "gt",  -- 新增：类型定义改用 gt
        "<CMD>Trouble lsp_type_definitions focus=true<CR>",
        mode = {"n"},
        desc = "[Trouble] LSP type definitions"
    }, {
        "gri",
        "<CMD>Trouble lsp_implementations focus=true<CR>",
        mode = {"n"},
        desc = "[Trouble] LSP implementations"
    }},

		specs = {
			"folke/snacks.nvim",
			opts = function(_, opts)
				return vim.tbl_deep_extend("force", opts or {}, {
					picker = {
						actions = require("trouble.sources.snacks").actions,
						win = {
							input = {
                            -- stylua: ignore
                            keys = {
                                ["<c-t>"] = {
                                    "trouble_open",
                                    mode = {"n", "i"}
                                }
                            }
,
							},
						},
					},
				})
			end,
		},
		opts = {
			focus = false,
			warn_no_results = false,
			open_no_results = true,
			preview = {
				type = "float",
				relative = "editor",
				border = "rounded",
				title = "Preview",
				title_pos = "center",
				---`row` and `col` values relative to the editor
				position = { 0.3, 0.3 },
				size = {
					width = 0.6,
					height = 0.5,
				},
				zindex = 200,
			},
		},

		config = function(_, opts)
			require("trouble").setup(opts)
			local symbols = require("trouble").statusline({
				mode = "lsp_document_symbols",
				groups = {},
				title = false,
				filter = {
					range = true,
				},
				format = "{kind_icon}{symbol.name:Normal}",
				-- The following line is needed to fix the background color
				-- Set it to the lualine section you want to use
				-- hl_group = "lualine_b_normal",
			})

			-- Insert status into lualine
			opts = require("lualine").get_config()
			table.insert(opts.winbar.lualine_b, 1, {
				symbols.get,
				cond = symbols.has,
			})
			require("lualine").setup(opts)
		end,
	},
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {
			notification = {
				window = {
					winblend = 0,
					border = "rounded",
				},
			},
			progress = {
				display = {
					done_icon = "✓",
				},
			},
		},
	},
}
