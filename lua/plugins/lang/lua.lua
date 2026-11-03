-- ============================================================================
-- Lua 语言配置
-- 工具、格式化和调试；LSP 差异配置见 after/lsp/，启用清单见 config/servers.lua
-- ============================================================================

return {
    -- Treesitter: syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = {
            ensure_installed = { "lua", "luadoc", "luap" },
        },
        opts_extend = { "ensure_installed" },
    },

    -- Mason: install formatters/linters
    {
        "mason-org/mason.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "stylua",
            },
        },
        opts_extend = { "ensure_installed" },
    },

    -- Conform: formatting
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
            },
        },
    },

    -- LazyDev: better Neovim Lua development experience
    -- 提供 vim.* API 的类型定义和补全
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

}
