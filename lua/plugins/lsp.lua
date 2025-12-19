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
}}
