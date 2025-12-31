-- return {
--  {
--     "williamboman/mason.nvim",
--     opts = {
--         ensure_installed = {
--             "lua-language-server",  -- 指定必须安装的工具
--         },
--     },
--     config = function(_, opts)
--         require("mason").setup(opts)  -- 初始化 Mason
--         local mr = require("mason-registry")
--         -- 自定义安装函数：检查并安装未安装的工具
--         local function ensure_installed()
--             for _, tool in ipairs(opts.ensure_installed) do
--                 local p = mr.get_package(tool)
--                 if not p:is_installed() then
--                     p:install()  -- 触发安装
--                 end
--             end
--         end
--         -- 根据 registry 状态选择执行方式
--         if mr.refresh then
--             mr.refresh(ensure_installed)  -- 刷新后安装
--         else
--             ensure_installed()  -- 直接安装
--         end
--     end,
-- },
-- {
--   'neovim/nvim-lspconfig',
--   dependencies = { 'saghen/blink.cmp' },
--  -- example calling setup directly for each LSP
--   config = function()
--   -- === 1. 屏蔽 0.11+ 的废弃警告 ===
--             -- 在加载 lspconfig 之前拦截 notify，过滤掉特定的 warning
--             local _notify = vim.notify
--             vim.notify = function(msg, ...)
--                 if msg:match("The `require%('lspconfig'%)` \"framework\" is deprecated") then
--                     return
--                 end
--                 _notify(msg, ...)
--             end
--         vim.diagnostic.config({
--         underline = false,
--         signs = false,
--         update_in_insert = false,
--         virtual_text = { spacing = 2, prefix = "●" },
--         severity_sort = true,
--         float = {
--           border = "rounded",
--         },
--       })
--     -- Use LspAttach autocommand to only map the following keys
--       -- after the language server attaches to the current buffer
--       vim.api.nvim_create_autocmd("LspAttach", {
--         group = vim.api.nvim_create_augroup("UserLspConfig", {}),
--         callback = function(ev)
--           -- vim.keymap.set("n", "K", vim.lsp.buf.hover) -- configured in "nvim-ufo" plugin
--           vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
--             buffer = ev.buf,
--             desc = "[LSP] Show diagnostic",
--           })
--           vim.keymap.set("n", "<leader>gk", vim.lsp.buf.signature_help, { desc = "[LSP] Signature help" })
--           vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "[LSP] Add workspace folder" })
--           vim.keymap.set(
--             "n",
--             "<leader>wr",
--             vim.lsp.buf.remove_workspace_folder,
--             { desc = "[LSP] Remove workspace folder" }
--           )
--           vim.keymap.set("n", "<leader>wl", function()
--             print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--           end, { desc = "[LSP] List workspace folders" })
--           vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "[LSP] Rename" })
--         end,
--       })  
--     local capabilities = require('blink.cmp').get_lsp_capabilities()
--     local lspconfig = require('lspconfig')
--     lspconfig['lua_ls'].setup({ capabilities = capabilities })
--   end
-- }
-- }
return {{
    "williamboman/mason.nvim",
    dependencies = {"williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig", "saghen/blink.cmp"},
    config = function()
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
                border = "rounded"
            }
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                -- vim.keymap.set("n", "K", vim.lsp.buf.hover) -- configured in "nvim-ufo" plugin
                vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
                    buffer = ev.buf,
                    desc = "[LSP] Show diagnostic"
                })
                vim.keymap.set("n", "<leader>gk", vim.lsp.buf.signature_help, {
                    desc = "[LSP] Signature help"
                })
                vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, {
                    desc = "[LSP] Add workspace folder"
                })
                vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, {
                    desc = "[LSP] Remove workspace folder"
                })
                vim.keymap.set("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, {
                    desc = "[LSP] List workspace folders"
                })
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
                    buffer = ev.buf,
                    desc = "[LSP] Rename"
                })
            end
        })

        -- === 1. 屏蔽 0.11+ 的废弃警告 ===
        -- 在加载 lspconfig 之前拦截 notify，过滤掉特定的 warning
        local _notify = vim.notify
        vim.notify = function(msg, ...)
            if msg:match("The `require%('lspconfig'%)` \"framework\" is deprecated") then
                return
            end
            _notify(msg, ...)
        end

        -- === 2. 初始化 Mason ===
        require("mason").setup()

        -- === 3. 使用 mason-lspconfig 自动处理 ===
        -- 这是业界标准做法，它会自动处理 Mason 二进制文件的路径问题
        require("mason-lspconfig").setup({
            ensure_installed = {"lua_ls", "clangd"}, -- 确保安装
            handlers = { -- 默认处理器：对所有安装的 server 自动调用 setup
            function(server_name)

                local capabilities = require('blink.cmp').get_lsp_capabilities()

                -- 针对特定语言的特殊配置
                local opts = {
                    capabilities = capabilities
                }

                -- Lua 特别配置
                if server_name == "lua_ls" then
                    opts.settings = {
                        Lua = {
                            diagnostics = {
                                globals = {"vim"}
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = {vim.env.VIMRUNTIME}
                            }
                        }
                    }
                end

                -- 调用 setup (虽然这会触发 warning，但上面的代码已经屏蔽了它)
                -- 这样既能享受 Mason 的路径自动管理，又没有报错
                require("lspconfig")[server_name].setup(opts)
            end}
        })

    end

    -- 配置解耦：如果以后想加 pyright 或 clangd，只需要在 ensure_installed 
    -- 里加名字，下面会自动生效，不需要每次都手写一遍 vim.lsp.config。
}, {
    "folke/lazydev.nvim",
    ft = "lua", -- onbly load for lua files
    opts = {
        library = { -- see the configuration section for more details
        -- load luvit types when the vim.uv word is found
        {
            path = "${3rd}/luv/library",
            words = {"vim%.uv"}
        }}
    }
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
            lua = {"stylua"},
            zig = {"zigfmt"},
            cpp = {"clangd"},
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
}, {
    "folke/trouble.nvim",
    cmd = "Trouble",
    -- stylua: ignore
    keys = {{
        "<A-j>",
        function()
            vim.diagnostic.jump({
                count = 1
            })
        end,
        mode = {"n"},
        desc = "Go to next diagnostic"
    }, {
        "<A-k>",
        function()
            vim.diagnostic.jump({
                count = -1
            })
        end,
        mode = {"n"},
        desc = "Go to previous diagnostic"
    }, {
        "<leader>gd",
        "<CMD>Trouble diagnostics toggle<CR>",
        desc = "[Trouble] Toggle buffer diagnostics"
    }, {
        "<leader>gs",
        "<CMD>Trouble symbols toggle focus=false<CR>",
        desc = "[Trouble] Toggle symbols "
    }, {
        "<leader>gl",
        "<CMD>Trouble lsp toggle focus=false win.position=right<CR>",
        desc = "[Trouble] Toggle LSP definitions/references/..."
    }, {
        "<leader>gL",
        "<CMD>Trouble loclist toggle<CR>",
        desc = "[Trouble] Location List"
    }, {
        "<leader>gq",
        "<CMD>Trouble qflist toggle<CR>",
        desc = "[Trouble] Quickfix List"
    }, {
        "grr",
        "<CMD>Trouble lsp_references focus=true<CR>",
        mode = {"n"},
        desc = "[Trouble] LSP references"
    }, {
        "gD",
        "<CMD>Trouble lsp_declarations focus=true<CR>",
        mode = {"n"},
        desc = "[Trouble] LSP declarations"
    }, {
        "gd",
        "<CMD>Trouble lsp_type_definitions focus=true<CR>",
        mode = {"n"},
        desc = "[Trouble] LSP type definitions"
    }, {
        "gri",
        "<CMD>Trouble lsp_implementations focus=true<CR>",
        mode = {"n"},
        desc = "[Trouble] LSP implementations"
    }},

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
}}
