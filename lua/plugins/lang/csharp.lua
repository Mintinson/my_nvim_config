-- ============================================================================
-- C# 语言配置
-- 使用 Neovim 0.11+ vim.lsp.config() API
-- ============================================================================

return {
    -- Treesitter: 语法高亮
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = {
            ensure_installed = { "c_sharp" },
        },
        opts_extend = { "ensure_installed" },
    },

    -- Mason: 安装工具（formatter, debugger 等）
    {
        "williamboman/mason.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "csharpier",   -- C# 代码格式化工具
                "netcoredbg",  -- .NET Core 调试器
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
                "omnisharp", -- C# Language Server (功能最全)
                -- "csharp_ls", -- 备选：更轻量的 C# LSP
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
                cs = { "csharpier" },
            },
        },
    },

    -- OmniSharp LSP 配置 (Neovim 0.11+)
    {
        "neovim/nvim-lspconfig",
        optional = true,
        opts = function()
            -- 使用 vim.lsp.config() 配置 omnisharp
            -- 这会与全局 "*" 配置自动合并
            vim.lsp.config("omnisharp", {
                cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
                filetypes = { "cs", "vb" },
                root_markers = {
                    "*.sln",
                    "*.csproj",
                    "omnisharp.json",
                    "function.json",
                    ".git",
                },
                settings = {
                    FormattingOptions = {
                        EnableEditorConfigSupport = true, -- 支持 .editorconfig
                        OrganizeImports = true,           -- 自动整理 using
                    },
                    MsBuild = {
                        LoadProjectsOnDemand = false, -- 启动时加载所有项目
                    },
                    RoslynExtensionsOptions = {
                        EnableAnalyzersSupport = true,           -- 启用 Roslyn 分析器
                        EnableImportCompletion = true,           -- 启用导入补全
                        AnalyzeOpenDocumentsOnly = true,         -- 只分析打开的文档（提升性能）
                        EnableDecompilationSupport = true,       -- 启用反编译支持
                        InlayHintsOptions = {
                            EnableForParameters = true,          -- 参数名提示
                            ForLiteralParameters = true,         -- 字面量参数提示
                            ForIndexerParameters = true,         -- 索引器参数提示
                            EnableForTypes = true,               -- 类型提示
                            ForImplicitVariableTypes = true,     -- var 类型提示
                            ForLambdaParameterTypes = true,      -- Lambda 参数类型提示
                            ForImplicitObjectCreation = true,    -- new() 类型提示
                        },
                    },
                    Sdk = {
                        IncludePrereleases = false, -- 不包含预览版 SDK
                    },
                },
            })

            -- 启用 omnisharp
            vim.lsp.enable("omnisharp")
        end,
    },

    -- DAP: netcoredbg 调试器配置
    {
        "mfussenegger/nvim-dap",
        optional = true,
        opts = function()
            local dap = require("dap")

            -- netcoredbg adapter 配置
            local mason_path = vim.fn.stdpath("data") .. "/mason"
            local netcoredbg_path = mason_path .. "/packages/netcoredbg/netcoredbg"

            dap.adapters.coreclr = {
                type = "executable",
                command = netcoredbg_path,
                args = { "--interpreter=vscode" },
            }

            -- C# 调试配置
            dap.configurations.cs = {
                {
                    name = "Launch - netcoredbg",
                    type = "coreclr",
                    request = "launch",
                    program = function()
                        -- 尝试自动找到 DLL
                        local cwd = vim.fn.getcwd()
                        local dll = vim.fn.glob(cwd .. "/bin/Debug/**/**.dll", false, true)
                        if #dll > 0 then
                            return vim.fn.input("Path to dll: ", dll[1], "file")
                        end
                        return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
                {
                    name = "Attach - netcoredbg",
                    type = "coreclr",
                    request = "attach",
                    processId = require("dap.utils").pick_process,
                },
            }
        end,
    },
}
