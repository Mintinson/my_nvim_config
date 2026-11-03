-- ============================================================================
-- Rust 语言配置
-- 工具、格式化和调试；LSP 差异配置见 after/lsp/，启用清单见 config/servers.lua
-- ============================================================================

return {
    -- Treesitter: syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = {
            ensure_installed = { "rust", "toml" },
        },
        opts_extend = { "ensure_installed" },
    },

    -- Mason: install debuggers
    {
        "mason-org/mason.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "codelldb", -- Debugger
            },
        },
        opts_extend = { "ensure_installed" },
    },

    -- Conform: formatting（使用 rustfmt）
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
