-- ============================================================================
-- C# 语言配置
-- 工具、格式化和调试；LSP 差异配置见 after/lsp/，启用清单见 config/servers.lua
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
        "mason-org/mason.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "csharpier",   -- C# 代码格式化工具
                "netcoredbg",  -- .NET Core 调试器
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
