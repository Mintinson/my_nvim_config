-- ============================================================================
-- Rust 语言配置
-- 使用 Neovim 0.11+ vim.lsp.config() API
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
        "williamboman/mason.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "codelldb", -- Debugger
            },
        },
        opts_extend = { "ensure_installed" },
    },

    -- Mason-lspconfig: install LSP servers
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            ensure_installed = { "rust_analyzer" },
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

    -- rust_analyzer LSP 配置 (Neovim 0.11+)
    {
        "neovim/nvim-lspconfig",
        optional = true,
        opts = function()
            -- 使用 vim.lsp.config() 配置 rust_analyzer
            -- 这会与全局 "*" 配置自动合并
            vim.lsp.config("rust_analyzer", {
                cmd = { "rust-analyzer" },
                filetypes = { "rust" },
                root_markers = {
                    "Cargo.toml",
                    "rust-project.json",
                    ".git",
                },
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            runBuildScripts = true,
                        },
                        -- checkOnSave 在新版 rust-analyzer 中是布尔值
                        checkOnSave = true,
                        -- check 配置（替代旧的 checkOnSave 对象）
                        check = {
                            allFeatures = true,
                            command = "clippy",
                            extraArgs = { "--no-deps" },
                        },
                        procMacro = {
                            enable = true,
                            ignored = {
                                ["async-trait"] = { "async_trait" },
                                ["napi-derive"] = { "napi" },
                                ["async-recursion"] = { "async_recursion" },
                            },
                        },
                        inlayHints = {
                            bindingModeHints = { enable = false },
                            chainingHints = { enable = true },
                            closingBraceHints = { enable = true, minLines = 25 },
                            closureReturnTypeHints = { enable = "never" },
                            lifetimeElisionHints = { enable = "never", useParameterNames = false },
                            maxLength = 25,
                            parameterHints = { enable = true },
                            reborrowHints = { enable = "never" },
                            renderColons = true,
                            typeHints = {
                                enable = true,
                                hideClosureInitialization = false,
                                hideNamedConstructor = false,
                            },
                        },
                    },
                },
            })

            -- 启用 rust_analyzer
            vim.lsp.enable("rust_analyzer")
        end,
    },
}
