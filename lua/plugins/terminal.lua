-- return {{
--     "akinsho/toggleterm.nvim",
--     version = "*",
--     opts = {
--         -- === 核心配置 ===
--         size = 15,
--         open_mapping = [[<C-\>]], -- 核心快捷键
--         direction = "horizontal",
--         shade_terminals = true,
--         start_in_insert = true,
--         insert_mappings = true,
--         terminal_mappings = true,  -- 关键：启用终端模式映射
--         persist_size = true,
--         close_on_exit = true,
--         shell = nil,
--         float_opts = {
--             border = "curved",
--             winblend = 0
--         }
--     },
--     config = function(_, opts)
--         -- 1. 设置默认 Shell
--         if vim.fn.has("win32") == 1 then
--             local powershell_options = {
--                 shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
--                 shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
--                 shellquote = "",
--                 shellxquote = ""
--             }
--             for option, value in pairs(powershell_options) do
--                 vim.opt[option] = value
--             end
--         else
--             vim.opt.shell = "/bin/zsh"
--         end

--         -- 2. 定义按键映射函数 (局部函数，不污染全局)
--         local function set_terminal_keymaps(term)
--             local buf = term.bufnr
--             local map = vim.keymap.set
--             local opts_map = { buffer = buf, noremap = true, silent = true }

--                             -- 禁用补全和 autopairs 在终端中
--                 vim.b.completion = false
--                 vim.b[buf].minipairs_disable = true
                

--             -- 在终端模式 (t) 下的快捷键
--             map('t', '<Esc>', [[<C-\><C-n>]], opts_map) -- Esc 退出插入模式
--             -- map('t', 'jk', [[<C-\><C-n>]], opts_map)    -- jk 退出插入模式
            
--             -- 使用 Win+hjkl 进行窗口跳转
--             map('t', '<D-h>', [[<C-\><C-n><C-w>h]], opts_map)
--             map('t', '<D-j>', [[<C-\><C-n><C-w>j]], opts_map)
--             map('t', '<D-k>', [[<C-\><C-n><C-w>k]], opts_map)
--             map('t', '<D-l>', [[<C-\><C-n><C-w>l]], opts_map)
            
--             -- Ctrl+hjkl 也映射（先退出终端模式再跳转）
--             map('t', '<C-h>', [[<C-\><C-n><C-w>h]], opts_map)
--             map('t', '<C-j>', [[<C-\><C-n><C-w>j]], opts_map)
--             map('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts_map)
--             map('t', '<C-l>', [[<C-\><C-n><C-w>l]], opts_map)
            
--             -- 在终端 buffer 的 normal 模式下也支持窗口跳转
--             map('n', '<C-h>', [[<C-w>h]], { buffer = buf })
--             map('n', '<C-j>', [[<C-w>j]], { buffer = buf })
--             map('n', '<C-k>', [[<C-w>k]], { buffer = buf })
--             map('n', '<C-l>', [[<C-w>l]], { buffer = buf })
--         end

--         -- 3. 将按键映射挂载到 on_open 回调中
--         opts.on_open = function(term)
--             set_terminal_keymaps(term)
--             -- 可选：打开后短暂延迟再进入插入模式，确保映射生效
--             vim.defer_fn(function()
--                 if vim.api.nvim_buf_is_valid(term.bufnr) then
--                     vim.cmd("startinsert")
--                 end
--             end, 10)
--         end

--         -- 4. 初始化插件
--         require("toggleterm").setup(opts)

--         -- 5. 备用方案：全局终端 autocmd
--         vim.api.nvim_create_autocmd("TermOpen", {
--             pattern = "term://*",
--             callback = function()
--                 local buf = vim.api.nvim_get_current_buf()
--                 local map = vim.keymap.set
--                 local buf_opts = { buffer = buf, noremap = true, silent = true }
--                                         -- 禁用补全和 autopairs 在终端中
--                 vim.b.completion = false
--                 vim.b[buf].minipairs_disable = true
                    
--                 -- 退出终端模式
--                 map('t', '<Esc>', [[<C-\><C-n>]], buf_opts)
--                 -- map('t', 'jk', [[<C-\><C-n>]], buf_opts)
                
--                 -- 窗口跳转（先退出终端模式）
--                 map('t', '<C-h>', [[<C-\><C-n><C-w>h]], buf_opts)
--                 map('t', '<C-j>', [[<C-\><C-n><C-w>j]], buf_opts)
--                 map('t', '<C-k>', [[<C-\><C-n><C-w>k]], buf_opts)
--                 map('t', '<C-l>', [[<C-\><C-n><C-w>l]], buf_opts)
                
--                 -- Win 版本
--                 map('t', '<D-h>', [[<C-\><C-n><C-w>h]], buf_opts)
--                 map('t', '<D-j>', [[<C-\><C-n><C-w>j]], buf_opts)
--                 map('t', '<D-k>', [[<C-\><C-n><C-w>k]], buf_opts)
--                 map('t', '<D-l>', [[<C-\><C-n><C-w>l]], buf_opts)
--             end
--         })

--         -- 6. 自定义 :Term 命令
--         vim.api.nvim_create_user_command("Term", function(args)
--             local term = require('toggleterm.terminal').Terminal:new({
--                 cmd = args.args,
--                 hidden = true,
--                 direction = "float"
--             })
--             term:toggle()
--         end, {
--             nargs = 1
--         })
--     end
-- }}

return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            size = 15,
            open_mapping = [[<C-\>]],
            direction = "horizontal",
            shade_terminals = true,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            close_on_exit = true,
            shell = nil,
            float_opts = {
                border = "curved",
            },
            on_open = function(term)
                local bufnr = term.bufnr
                
                -- 禁用各种可能导致卡顿的功能
                vim.bo[bufnr].filetype = ""  -- 禁用 filetype 检测
                vim.b[bufnr].completion = false
                vim.b[bufnr].autopairs_enabled = false
                
                -- 禁用 treesitter
                if vim.treesitter.stop then
                    vim.treesitter.stop(bufnr)
                end
                
                -- 终端快捷键
                local opts = { buffer = bufnr, noremap = true, silent = true }
                vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
                vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
                vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
                vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
                vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
            end,
        },
    },
}