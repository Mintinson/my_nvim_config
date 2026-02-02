-- ============================================================================
-- Haskell 语言配置
-- 使用 Neovim 0.11+ vim.lsp.config() API
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
        "williamboman/mason.nvim",
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

    -- Mason-lspconfig: 安装 LSP 服务器
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "hls", -- Haskell Language Server
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
    {
        "neovim/nvim-lspconfig",
        optional = true,
        opts = function()
            -- 使用 vim.lsp.config() 配置 hls
            -- 这会与全局 "*" 配置自动合并
            vim.lsp.config("hls", {
                cmd = { "haskell-language-server-wrapper", "--lsp" },
                filetypes = { "haskell", "lhaskell" },
                root_markers = {
                    "hie.yaml",
                    "stack.yaml",
                    "cabal.project",
                    "*.cabal",
                    "package.yaml",
                    ".git",
                },
                settings = {
                    haskell = {
                        -- 插件配置
                        plugin = {
                            -- 代码补全
                            ["ghcide-completions"] = {
                                config = {
                                    autoExtendOn = true, -- 自动扩展语言扩展
                                    snippetsOn = true,   -- 启用代码片段
                                },
                            },
                            -- 类型签名
                            ["ghcide-type-lenses"] = {
                                globalOn = true, -- 显示类型透镜
                            },
                            -- Hlint 集成
                            hlint = {
                                globalOn = true, -- 启用 hlint 诊断
                            },
                            -- 格式化（如果使用 hls 内置格式化）
                            fourmolu = {
                                config = {
                                    external = true, -- 使用外部 fourmolu
                                },
                            },
                        },
                        -- 格式化提供者
                        formattingProvider = "fourmolu",
                    },
                },
            })

            -- 启用 hls
            vim.lsp.enable("hls")
        end,
    },
}
