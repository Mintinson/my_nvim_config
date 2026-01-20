return { -- Treesitter: syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		optional = true,
		opts = {
			ensure_installed = { "rust", "toml" },
		},
		opts_extend = { "ensure_installed" },
	}, -- Mason: install formatters/linters/debuggers
	{
		"williamboman/mason.nvim",
		optional = true,
		opts = {
			ensure_installed = {
				"codelldb", -- Debugger
			},
		},
		opts_extend = { "ensure_installed" },
	}, -- Mason-lspconfig: install LSP servers
	{
		"williamboman/mason-lspconfig.nvim",
		optional = true,
		opts = {
			ensure_installed = { "rust_analyzer" },
		},
		opts_extend = { "ensure_installed" },
	}, -- Conform: formatting（使用 rustfmt）
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				rust = { "rustfmt" },
			},
		},
	},
}
