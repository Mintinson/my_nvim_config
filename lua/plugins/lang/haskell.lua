-- ============================================================================
-- Haskell 语言配置
-- 工具、格式化和调试；LSP 差异配置见 after/lsp/，启用清单见 config/servers.lua
-- ============================================================================

return {
    -- Treesitter: 语法高亮
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = {
            ensure_installed = { "haskell" },
        },
        opts_extend = { "ensure_installed" },
    },

    -- Mason: 安装工具（formatter 等）
    {
        "mason-org/mason.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "fourmolu", -- Haskell 代码格式化工具（推荐，比 ormolu 更灵活）
                -- "ormolu",      -- 另一个格式化工具（更严格）
                -- "stylish-haskell", -- 专注于 import 排序
            },
        },
        opts_extend = { "ensure_installed" },
    },

    -- Conform: 代码格式化配置
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                haskell = { "fourmolu" },
                -- haskell = { "ormolu" },  -- 备选
            },
        },
    },

    -- hls (Haskell Language Server) 配置 (Neovim 0.11+)
}
