-- C/C++ language configuration
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

    -- Mason-LSPConfig: LSP 服务器安装和自动配置
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            ensure_installed = { "clangd" }, -- C/C++ Language Server
        },
        opts_extend = { "ensure_installed" },
    },

    

    -- Mason: 安装其他工具（formatter, debugger 等）
    {
        "williamboman/mason.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "clang-format", -- C/C++ 代码格式化工具
                -- "clang-tidy",   -- （用于 linting）
                "codelldb",     -- C/C++ debugger (可选)
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

    -- LSPConfig: clangd 特殊配置（可选）
    -- {
    --     "neovim/nvim-lspconfig",
    --     optional = true,
    --     opts = function(_, opts)
    --         -- 如果需要自定义 clangd 配置，可以在这里添加
    --         opts.servers = opts.servers or {}
    --         opts.servers.clangd = {
    --             cmd = {
    --                 "clangd",
    --                 "--background-index",
    --                 "--clang-tidy",
    --                 "--header-insertion=iwyu",
    --                 "--completion-style=detailed",
    --                 "--function-arg-placeholders",
    --                 "--header-insertion-decorators", -- 显示头文件插入提示
    --             },
    --             init_options = {
    --                 clangdFileStatus = true,
    --                 usePlaceholders = true,
    --                 completeUnimported = true,
    --                 semanticHighlighting = true,
    --             },

    --         }
    --         return opts
    --     end,
    -- },

    -- clangd LSP 配置
    {
        "neovim/nvim-lspconfig",
        optional = true,
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
                callback = function(ev)
                    local clients = vim.lsp.get_clients({ bufnr = ev.buf, name = "clangd" })
                    if #clients > 0 then
                        return
                    end

                    local capabilities = require("blink.cmp").get_lsp_capabilities()
                    vim.lsp.start({
                        name = "clangd",
                        cmd = {
                            "clangd",
                            "--background-index",
                            "--clang-tidy",
                            "--header-insertion=iwyu",
                            "--header-insertion-decorators",
                            "--completion-style=detailed",
                            -- "--argument-lists=delimiters",
                            "--function-arg-placeholders",
                        },
                        root_dir = vim.fs.root(ev.buf, {
                            ".clangd",
                            ".clang-tidy",
                            ".clang-format",
                            "compile_commands.json",
                            "compile_flags.txt",
                            ".git",
                        }),
                        capabilities = capabilities,
                        init_options = {
                            clangdFileStatus = true,
                            -- usePlaceholders = false,
                            -- completeUnimported = true,
                            semanticHighlighting = true,
                            fallbackFlags = { "-std=c++20" },
                        },
                    })
                end,
            })
        end,
    },
}