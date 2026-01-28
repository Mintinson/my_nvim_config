-- ============================================================================
-- Lua 语言配置
-- 使用 Neovim 0.11+ vim.lsp.config() API
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
        "williamboman/mason.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "stylua",
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
                "lua_ls",
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

    -- lua_ls LSP 配置 (Neovim 0.11+)
    {
        "neovim/nvim-lspconfig",
        optional = true,
        opts = function()
            -- 使用 vim.lsp.config() 配置 lua_ls
            -- 这会与全局 "*" 配置自动合并
            vim.lsp.config("lua_ls", {
                cmd = { "lua-language-server" },
                filetypes = { "lua" },
                root_markers = {
                    ".luarc.json",
                    ".luarc.jsonc",
                    ".luacheckrc",
                    ".stylua.toml",
                    "stylua.toml",
                    "selene.toml",
                    "selene.yml",
                    ".git",
                },
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                -- 如果需要，可以添加更多库路径
                            },
                        },
                        completion = {
                            callSnippet = "Replace",
                        },
                        hint = {
                            enable = true,
                            setType = true,
                            paramType = true,
                            paramName = "Literal",
                            semicolon = "Disable",
                            arrayIndex = "Disable",
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            -- 启用 lua_ls
            vim.lsp.enable("lua_ls")
        end,
    },
}