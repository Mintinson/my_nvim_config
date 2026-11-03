-- ============================================================================
-- Zig 语言配置
-- 工具、格式化和调试；LSP 差异配置见 after/lsp/，启用清单见 config/servers.lua
-- ============================================================================

return {
    -- Treesitter: syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = {
            ensure_installed = { "zig" },
        },
        opts_extend = { "ensure_installed" },
    },

    -- Conform: formatting (zls has built-in formatter)
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                zig = { "zigfmt" },
            },
        },
    },

}
