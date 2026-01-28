-- ============================================================================
-- Python 语言配置
-- 使用 Neovim 0.11+ vim.lsp.config() API
-- ============================================================================

return {
    -- Treesitter: syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = {
            ensure_installed = { "python" },
        },
        opts_extend = { "ensure_installed" },
    },

    -- Mason: install formatters/linters
    {
        "williamboman/mason.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "ruff",
            },
        },
        opts_extend = { "ensure_installed" },
    },

    -- Mason-lspconfig: install LSP servers
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "ty",
            },
        },
        opts_extend = { "ensure_installed" },
    },

    -- ty LSP 配置（Neovim 0.11+）
    {
        "neovim/nvim-lspconfig",
        optional = true,
        opts = function()
            -- 使用 vim.lsp.config() 配置 ty
            -- 这会与全局 "*" 配置自动合并
            vim.lsp.config("ty", {
                cmd = { "ty", "server" },
                filetypes = { "python" },
                root_markers = {
                    "ty.toml",
                    "pyproject.toml",
                    "setup.py",
                    "setup.cfg",
                    "requirements.txt",
                    ".git",
                },
                -- ty 的 settings 配置
                -- 参考: https://docs.astral.sh/ty/reference/editor-settings/
                settings = {
                    -- Inlay hints 配置
                    inlayHints = {
                        enable = true,
                        parameterNames = true,
                        variableTypes = true,
                        functionReturnTypes = true,
                        genericTypes = true,
                    },
                },
            })

            -- 启用 ty LSP
            vim.lsp.enable("ty")
        end,
    },

    -- Conform: formatting
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                python = { "ruff_organize_imports", "ruff_format" },
            },
        },
    },

    -- Linting
    {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = {
            linters_by_ft = {
                python = { "ruff" },
            },
        },
    },

    -- Python environment selector
    {
        "linux-cultist/venv-selector.nvim",
        branch = "main",
        cmd = "VenvSelect",
        ft = "python",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        opts = {
            settings = {
                options = {
                    notify_user_on_venv_activation = true,
                },
            },
            -- 指定支持的 Python LSP 名称
            name = { "ty", "pyright", "pylsp", "basedpyright" },
        },
        keys = {
            { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Python Virtual Env", ft = "python" },
        },
    },
}