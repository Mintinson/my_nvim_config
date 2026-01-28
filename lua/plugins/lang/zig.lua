-- ============================================================================
-- Zig 语言配置
-- 使用 Neovim 0.11+ vim.lsp.config() API
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

    -- Mason-lspconfig: install LSP servers
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "zls", -- Zig Language Server
            },
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

    -- zls LSP 配置 (Neovim 0.11+)
    {
        "neovim/nvim-lspconfig",
        optional = true,
        opts = function()
            -- 使用 vim.lsp.config() 配置 zls
            -- 这会与全局 "*" 配置自动合并
            vim.lsp.config("zls", {
                cmd = { "zls" },
                filetypes = { "zig", "zir" },
                root_markers = {
                    "zls.json",
                    "build.zig",
                    ".git",
                },
                settings = {
                    zls = {
                        enable_snippets = true,
                        enable_argument_placeholders = true,
                        enable_ast_check_diagnostics = true,
                        enable_autofix = true,
                        enable_import_embedfile_argument_completions = true,
                        warn_style = true,
                        enable_semantic_tokens = true,
                        enable_inlay_hints = true,
                        inlay_hints_show_builtin = true,
                        inlay_hints_exclude_single_argument = true,
                        inlay_hints_hide_redundant_param_names = false,
                        inlay_hints_hide_redundant_param_names_last_token = false,
                        operator_completions = true,
                        include_imports = true,
                    },
                },
            })

            -- 启用 zls
            vim.lsp.enable("zls")
        end,
    },
}
