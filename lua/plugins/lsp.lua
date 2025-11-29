return {
 {
    "williamboman/mason.nvim",
    opts = {
        ensure_installed = {
            "lua-language-server",  -- 指定必须安装的工具
        },
    },
    config = function(_, opts)
        require("mason").setup(opts)  -- 初始化 Mason
        local mr = require("mason-registry")
        
        -- 自定义安装函数：检查并安装未安装的工具
        local function ensure_installed()
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()  -- 触发安装
                end
            end
        end

        -- 根据 registry 状态选择执行方式
        if mr.refresh then
            mr.refresh(ensure_installed)  -- 刷新后安装
        else
            ensure_installed()  -- 直接安装
        end
    end,
},
-- {
--   'neovim/nvim-lspconfig',
--   dependencies = { 'saghen/blink.cmp' },

--   -- example using `opts` for defining servers
--   opts = {
--     servers = {
--       lua_ls = {}
--     }
--   },
--   config = function(_, opts)
--     local lspconfig = require('lspconfig')
--     for server, config in pairs(opts.servers) do
--       -- passing config.capabilities to blink.cmp merges with the capabilities in your
--       -- `opts[server].capabilities, if you've defined it
--       config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
--       lspconfig[server].setup(config)
--     end
--   end

-- --  -- example calling setup directly for each LSP
-- --   config = function()
-- --     local capabilities = require('blink.cmp').get_lsp_capabilities()
-- --     local lspconfig = require('lspconfig')

-- --     lspconfig['lua_ls'].setup({ capabilities = capabilities })
-- --   end
-- }
{
  'neovim/nvim-lspconfig',
  dependencies = { 'saghen/blink.cmp', 'williamboman/mason.nvim' },
  config = function()
    vim.diagnostic.config({
        underline = false,
        signs = false,
        update_in_insert = false,
        virtual_text = { spacing = 2, prefix = "●" },
        severity_sort = true,
        float = {
          border = "rounded",
        },
      })

    -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- vim.keymap.set("n", "K", vim.lsp.buf.hover) -- configured in "nvim-ufo" plugin
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
            buffer = ev.buf,
            desc = "[LSP] Show diagnostic",
          })
          vim.keymap.set("n", "<leader>gk", vim.lsp.buf.signature_help, { desc = "[LSP] Signature help" })
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "[LSP] Add workspace folder" })
          vim.keymap.set(
            "n",
            "<leader>wr",
            vim.lsp.buf.remove_workspace_folder,
            { desc = "[LSP] Remove workspace folder" }
          )
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, { desc = "[LSP] List workspace folders" })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "[LSP] Rename" })
        end,
      })  
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    
    -- 适配 Neovim 0.11 的原生写法
    -- 1. 既然不能用 lspconfig.lua_ls.setup，我们就直接 require 它的配置表
    --    注意：这需要绕过主 lspconfig 表的 __index 元方法
    local lua_ls_config = require('lspconfig.configs.lua_ls').default_config
    
    -- 2. 合并你的自定义配置 (例如 capabilities)
    local config = vim.tbl_deep_extend("force", lua_ls_config, {
        capabilities = capabilities,
        -- 如果有其他 settings 也可以在这里加
        settings = {
            Lua = {
                diagnostics = { globals = { 'vim' } },
            },
        },
    })

    -- 3. 使用 Neovim 原生接口注册和启用
    -- 判断是否存在原生接口 (以防你回退到稳定版 0.10)
    if vim.lsp.config then 
        vim.lsp.config['lua_ls'] = config
        vim.lsp.enable('lua_ls')
    else
        -- 如果是旧版 Neovim，回退到旧写法
        require('lspconfig').lua_ls.setup(config)
    end
  end
}
}



-- return {
--     {
--         "williamboman/mason.nvim",
--         dependencies = {
--             "williamboman/mason-lspconfig.nvim", -- 新增依赖
--         },
--         config = function()
--             require("mason").setup()
--             -- mason-lspconfig 自动处理安装，不需要手写循环
--             require("mason-lspconfig").setup({
--                 ensure_installed = { "lua_ls" }, -- 名字在 mason 中是 lua-language-server，但在 lspconfig 中是 lua_ls，插件会自动映射
--             })
--         end,
--     },
--     {
--         'neovim/nvim-lspconfig',
--         dependencies = { 'saghen/blink.cmp', 'williamboman/mason.nvim' },
--         config = function()

--             vim.diagnostic.config({
--           underline = false,
--         signs = false,
--         update_in_inset = false,
--         virtual_text = {spacing = 2, prefix = "*" },
--         severity_sort = true,
--         float = {
--           border = "rounded",
--         },
--       })

--             local capabilities = require('blink.cmp').get_lsp_capabilities()
--             local lspconfig = require('lspconfig')

--             -- 针对 Lua LS 的配置
--             local lua_opts = {
--                 capabilities = capabilities,
--                 settings = {
--                     Lua = {
--                         diagnostics = { globals = { "vim" } },
--                     },
--                 },
--             }

--             -- 修复 Warning 的关键点：
--             -- 检测是否为 Neovim 0.11+ (拥有 vim.lsp.config)
--             if vim.fn.has('nvim-0.11') == 1 then
--                 -- 0.11+ 新写法：原生启用
--                 local defaults = require('lspconfig.configs.lua_ls').default_config
--                 local final_config = vim.tbl_deep_extend("force", defaults, lua_opts)
                
--                 vim.lsp.config['lua_ls'] = final_config
--                 vim.lsp.enable('lua_ls')
--             else
--                 -- 0.10 及以下旧写法
--                 lspconfig.lua_ls.setup(lua_opts)
--             end

--         -- vim.api.nvim_create_autocmd("LspAttach", { })

--         end
--     }
-- }

