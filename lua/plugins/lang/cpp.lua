-- ============================================================================
-- C/C++ 语言配置
-- 使用 Neovim 0.11+ vim.lsp.config() API
-- ============================================================================

return {
    -- Treesitter: 语法高亮和代码解析
    {
        "nvim-treesitter/nvim-treesitter",
        optional = true,
        opts = {
            ensure_installed = { "c", "cpp", "cmake" },
        },
        opts_extend = { "ensure_installed" },
    },

    -- Mason-LSPConfig: LSP 服务器安装
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            ensure_installed = { "clangd" },
        },
        opts_extend = { "ensure_installed" },
    },

    -- Mason: 安装其他工具（formatter, debugger 等）
    {
        "williamboman/mason.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "clang-format",
                "codelldb", -- C/C++ debugger
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
                c = { "clang-format" },
                cpp = { "clang-format" },
            },
        },
    },

    -- clangd LSP 配置 (Neovim 0.11+)
    {
        "neovim/nvim-lspconfig",
        optional = true,
        opts = function()
            -- 使用 vim.lsp.config() 配置 clangd
            -- 这会与全局 "*" 配置自动合并
            vim.lsp.config("clangd", {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--header-insertion-decorators",
                    "--completion-style=detailed",
                    "--function-arg-placeholders=0",
                    "--experimental-modules-support",
                },
                filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
                root_markers = {
                    ".clangd",
                    ".clang-tidy",
                    ".clang-format",
                    "compile_commands.json",
                    "compile_flags.txt",
                    ".git",
                },
                init_options = {
                    clangdFileStatus = true,
                    usePlaceholders = true,
                    completeUnimported = true,
                    semanticHighlighting = true,
                    fallbackFlags = { "-std=c++20" },
                },
            })

            -- 启用 clangd
            vim.lsp.enable("clangd")
        end,
    },

    -- DAP: codelldb debugger 配置
    {
        "mfussenegger/nvim-dap",
        optional = true,
        opts = function()
            local dap = require("dap")

            -- codelldb adapter 配置
            -- Mason 安装路径
            local mason_path = vim.fn.stdpath("data") .. "/mason"
            local codelldb_path = mason_path .. "/packages/codelldb/extension/adapter/codelldb"
            local liblldb_path = mason_path .. "/packages/codelldb/extension/lldb/lib/liblldb.so"

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = codelldb_path,
                    args = { "--port", "${port}" },
                },
            }

            -- C/C++ 调试配置
            local codelldb_config = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
                {
                    name = "Launch file with arguments",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    args = function()
                        local args_string = vim.fn.input("Arguments: ")
                        return vim.split(args_string, " +")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
                {
                    name = "Attach to process",
                    type = "codelldb",
                    request = "attach",
                    pid = require("dap.utils").pick_process,
                    cwd = "${workspaceFolder}",
                },
            }

            dap.configurations.c = codelldb_config
            dap.configurations.cpp = codelldb_config
        end,
    },
}