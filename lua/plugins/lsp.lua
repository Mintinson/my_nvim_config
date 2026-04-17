-- ============================================================================
-- LSP 全局配置 (Neovim 0.11+)
-- 本文件只包含语言无关的 LSP 基础能力配置
-- 语言特定配置请放在 lang/xxx.lua 中
-- ============================================================================
return { -- Mason: 工具安装管理器
{
    "williamboman/mason.nvim",
    opts = {
        ensure_installed = {}
    },
    opts_extend = {"ensure_installed"},
    config = function(_, opts)
        require("mason").setup(opts)
        local mr = require("mason-registry")

        local function ensure_installed()
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end
        if mr.refresh then
            mr.refresh(ensure_installed)
        else
            ensure_installed()
        end
    end
}, -- Mason-lspconfig: 仅用于自动安装 LSP 服务器
-- 注意：不再使用 handlers 来配置 LSP，改用 vim.lsp.config()
{
    "williamboman/mason-lspconfig.nvim",
    dependencies = {"williamboman/mason.nvim"},
    opts = {
        ensure_installed = {},
        automatic_installation = true
        -- 不再使用 handlers，LSP 配置由 vim.lsp.config() 负责
    },
    opts_extend = {"ensure_installed"}
}, -- LSP 全局基础配置
{
    "neovim/nvim-lspconfig",
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {"saghen/blink.cmp", "williamboman/mason.nvim"},
    config = function()
        -- ================================================================
        -- 全局 LSP 默认配置 (Neovim 0.11+ vim.lsp.config)
        -- 所有 LSP 服务器都会继承这些配置
        -- ================================================================
        vim.lsp.config("*", {
            -- 全局 capabilities（包含 blink.cmp 的补全能力）
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            -- 全局 root_markers（通用项目根目录标识）
            root_markers = {".git", ".editorconfig"}
        })

        -- ================================================================
        -- Diagnostics 全局配置
        -- ================================================================
        vim.diagnostic.config({
            underline = false,
            signs = false,
            update_in_insert = false,
            virtual_text = {
                spacing = 2,
                prefix = "●"
            },
            severity_sort = true,
            float = {
                border = "rounded",
                anchor_bias = "auto"
            }
        })

        -- ================================================================
        -- LSP Handlers 全局配置（hover, signature help 等）
        -- ================================================================
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "rounded",
            anchor_bias = "auto",
            max_width = 80,
            max_height = 20
        })

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "rounded",
            anchor_bias = "auto",
            max_width = 80,
            max_height = 20
        })

        -- ================================================================
        -- 全局 LspAttach 事件处理（通用快捷键和行为）
        -- ================================================================
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)

                -- Inlay hints: 默认关闭，支持手动开启
                if client and client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(false, {
                        bufnr = ev.buf
                    })
                end

                -- 通用 LSP 快捷键
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, {
                        buffer = ev.buf,
                        desc = desc
                    })
                end

                map("n", "<leader>d", vim.diagnostic.open_float, "[LSP] Show diagnostic")
                map("n", "<leader>gk", vim.lsp.buf.signature_help, "[LSP] Signature help")
                map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[LSP] Add workspace folder")
                map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[LSP] Remove workspace folder")
                map("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, "[LSP] List workspace folders")
                map("n", "<leader>rn", vim.lsp.buf.rename, "[LSP] Rename")

                -- Toggle inlay hints
                map("n", "<leader>th", function()
                    local current_state = vim.lsp.inlay_hint.is_enabled({
                        bufnr = ev.buf
                    })
                    vim.lsp.inlay_hint.enable(not current_state, {
                        bufnr = ev.buf
                    })
                    print(string.format("Inlay hints %s", not current_state and "enabled" or "disabled"))
                end, "[LSP] Toggle inlay hints")
            end
        })
    end
}, {
    "stevearc/conform.nvim",
    cmd = {"ConformInfo"},
    keys = {{
        "<M-F>", -- Alt + Shift + f
        function()
            require("conform").format({
                async = true,
                lsp_format = "fallback"
            })
        end,
        mode = {"n", "v"},
        desc = "Format buffer"
    }},
    opts = {
        formatters_by_ft = {
            -- lua = { "stylua" },
            -- zig = { "zigfmt" },
            -- cpp = { "clangd" },
            -- Use the "_" filetype to run formatters on filetypes that don't
            -- have other formatters configured.
            ["_"] = {"trim_whitespace"}
        }
    }
}, {
    "mfussenegger/nvim-lint",
    event = "BufWritePost",
    config = function()
        vim.api.nvim_create_autocmd({"BufWritePost"}, {
            callback = function()
                -- try_lint without arguments runs the linters defined in `linters_by_ft`
                -- for the current filetype
                require("lint").try_lint()

                -- You can call `try_lint` with a linter name or a list of names to always
                -- run specific linters, independent of the `linters_by_ft` configuration
                require("lint").try_lint("codespell")
            end
        })
    end
}, 
{
    "folke/trouble.nvim",
    cmd = "Trouble",
    -- stylua: ignore
    keys = {
        -- 诊断跳转（不与 Snacks picker 冲突）
        { "<A-j>", function() vim.diagnostic.jump({ count = 1 }) end, mode = "n", desc = "[Diagnostic] Next" },
        { "<A-k>", function() vim.diagnostic.jump({ count = -1 }) end, mode = "n", desc = "[Diagnostic] Previous" },
        
        -- Trouble 特有功能（使用 <leader>x 前缀避免冲突）
        { "<leader>xx", "<CMD>Trouble diagnostics toggle<CR>", desc = "[Trouble] Workspace diagnostics" },
        { "<leader>xX", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>", desc = "[Trouble] Buffer diagnostics" },
        { "<leader>xs", "<CMD>Trouble symbols toggle focus=false<CR>", desc = "[Trouble] Symbols outline" },
        { "<leader>xl", "<CMD>Trouble lsp toggle focus=false win.position=right<CR>", desc = "[Trouble] LSP references/definitions" },
        { "<leader>xL", "<CMD>Trouble loclist toggle<CR>", desc = "[Trouble] Location list" },
        { "<leader>xq", "<CMD>Trouble qflist toggle<CR>", desc = "[Trouble] Quickfix list" },
        
        -- 不覆盖 gd/gD/gr 等，让 Snacks 处理跳转
    },
    opts = {
        focus = false,
        warn_no_results = false,
        open_no_results = true,
        preview = {
            type = "float",
            relative = "editor",
            border = "rounded",
            title = "Preview",
            title_pos = "center",
            ---`row` and `col` values relative to the editor
            position = {0.3, 0.3},
            size = {
                width = 0.6,
                height = 0.5
            },
            zindex = 200
        }
    },

    specs = {
        "folke/snacks.nvim",
        opts = function(_, opts)
            return vim.tbl_deep_extend("force", opts or {}, {
                picker = {
                    actions = require("trouble.sources.snacks").actions,
                    win = {
                        input = {
                            -- stylua: ignore
                            keys = {
                                ["<c-t>"] = {
                                    "trouble_open",
                                    mode = {"n", "i"}
                                }
                            }
                        }
                    }
                }
            })
        end
    },


    config = function(_, opts)
        require("trouble").setup(opts)
        local symbols = require("trouble").statusline({
            mode = "lsp_document_symbols",
            groups = {},
            title = false,
            filter = {
                range = true
            },
            format = "{kind_icon}{symbol.name:Normal}"
            -- The following line is needed to fix the background color
            -- Set it to the lualine section you want to use
            -- hl_group = "lualine_b_normal",
        })

        -- Insert status into lualine
        opts = require("lualine").get_config()
        table.insert(opts.winbar.lualine_b, 1, {
            symbols.get,
            cond = symbols.has
        })
        require("lualine").setup(opts)
    end
},
 {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
        notification = {
            window = {
                winblend = 0,
                border = "rounded"
            }
        },
        progress = {
            display = {
                done_icon = "✓"
            }
        }
    }
}}
