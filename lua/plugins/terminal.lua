-- return {{
--     "akinsho/toggleterm.nvim",
--     version = "*",
--     opts = {
--         -- === 核心配置 ===
--         size = 15, -- 终端的高度（如果是水平分屏）
--         open_mapping = [[<C-\>]], -- 核心快捷键：Ctrl + \ 来切换终端显示/隐藏

--         -- === 外观样式 ===
--         -- 选项：'vertical' | 'horizontal' | 'tab' | 'float'
--         -- 'horizontal': 像 VS Code 默认那样在底部
--         -- 'float': 浮动在中间
--         direction = "horizontal",

--         shade_terminals = true, -- 背景稍微变暗，区分代码区
--         start_in_insert = true, -- 打开自动进入插入模式
--         insert_mappings = true, -- 允许在终端模式使用 Ctrl+n 等键
--         persist_size = true, -- 记住上次调整的大小
--         close_on_exit = true, -- 输 exit 退出时自动关闭窗口
--         -- 默认 shell 设置为 nil，这样它会跟随我们下面 config 中设置的 vim.opt.shell
--         shell = nil,

--         -- === 浮动窗口样式 (如果你选 float 模式) ===
--         float_opts = {
--             border = "curved", -- 边框风格：'single' | 'double' | 'shadow' | 'curved'
--             winblend = 0 -- 透明度 (0-100)
--         }
--     },
--     config = function(_, opts)
--         -- 智能判断 OS 并设置默认 Shell

--         -- 如果是 Windows
--         if vim.fn.has("win32") == 1 then
--             -- 优先尝试使用 PowerShell 7 (pwsh), 如果没有则用旧版 PowerShell
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
--             -- 如果是 Linux / macOS，通常默认就是 bash 或 zsh，不需要额外配置
--             -- 但如果你想强制指定 bash：
--             vim.opt.shell = "/bin/zsh"
--         end
--         -- === 核心修改：定义快捷键函数 ===
--         local function set_terminal_keymaps(term)
--             -- 注意：这里使用 buffer = term.bufnr 确保只针对当前终端生效
--             local options = {
--                 buffer = term.bufnr
--             }
--             local map = vim.keymap.set

--             -- 终端模式下 (t) 的跳转映射
--             map('t', '<Esc>', [[<C-\><C-n>]], options)
--             map('t', 'jk', [[<C-\><C-n>]], options)
--             map('t', '<C-h>', [[<Cmd>wincmd h<CR>]], options)
--             map('t', '<C-j>', [[<Cmd>wincmd j<CR>]], options)
--             map('t', '<C-k>', [[<Cmd>wincmd k<CR>]], options)
--             map('t', '<C-l>', [[<Cmd>wincmd l<CR>]], options)
--         end

--         -- 将快捷键设置注入到 setup 的 on_open 回调中，比 autocmd 更稳定
--         opts.on_open = function(term)
--             set_terminal_keymaps(term)
--         end
--         require("toggleterm").setup(opts)
--         -- -- === 关键优化：解决终端模式下 Esc 无法退出的问题 ===
--         -- -- 默认在终端里按 Esc 是没反应的（为了兼容 top 等命令），这让新手很抓狂。
--         -- -- 这里把 Esc 映射为“回到普通模式”，方便你切回代码窗口。:
--         -- function _G.set_terminal_keymaps()
--         --     local map_opts = {
--         --         buffer = 0
--         --     }
--         --     -- 终端模式下按 Esc 切换到 Normal 模式
--         --     vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], map_opts)
--         --     vim.keymap.set('t', 'jk', [[<C-\><C-n>]], map_opts)

--         --     -- 窗口导航快捷键
--         --     vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], map_opts)
--         --     vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], map_opts)
--         --     -- vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], map_opts)
--         --     vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd w<CR>]], map_opts)
--         --     vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], map_opts)
--         -- end

--         -- 每次打开终端时自动加载上述按键映射
--         -- vim.api.nvim_create_autocmd("TermOpen", {
--         --     group = vim.api.nvim_create_augroup("UserTerminalKeymaps", {
--         --         clear = true
--         --     }),
--         --     pattern = "term://*",
--         --     callback = function()
--         --         _G.set_terminal_keymaps()
--         --     end
--         -- })

--         -- 创建一个命令 :Term <cmd>
--         -- 例如输入 :Term python 就会打开 python 终端
--         -- 输入 :Term cmd 就会打开 cmd
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

--         -- local Terminal = require('toggleterm.terminal').Terminal
--         -- local lazygit = Terminal:new({
--         --     cmd = "lazygit",
--         --     hidden = true,
--         --     direction = "float"
--         -- })

--         -- function _lazygit_toggle()
--         --     lazygit:toggle()
--         -- end

--         -- -- 映射 <leader>g 打开 Lazygit
--         -- vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", {
--         --     noremap = true,
--         --     silent = true
--         -- })
--     end

-- }}


return {{
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
        -- === 核心配置 ===
        size = 15,
        open_mapping = [[<C-\>]], -- 核心快捷键
        direction = "horizontal",
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,  -- 关键：启用终端模式映射
        persist_size = true,
        close_on_exit = true,
        shell = nil,
        float_opts = {
            border = "curved",
            winblend = 0
        }
    },
    config = function(_, opts)
        -- 1. 设置默认 Shell
        if vim.fn.has("win32") == 1 then
            local powershell_options = {
                shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
                shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
                shellquote = "",
                shellxquote = ""
            }
            for option, value in pairs(powershell_options) do
                vim.opt[option] = value
            end
        else
            vim.opt.shell = "/bin/zsh"
        end

        -- 2. 定义按键映射函数 (局部函数，不污染全局)
        local function set_terminal_keymaps(term)
            local buf = term.bufnr
            local map = vim.keymap.set
            local opts_map = { buffer = buf, noremap = true, silent = true }

            -- 在终端模式 (t) 下的快捷键
            map('t', '<Esc>', [[<C-\><C-n>]], opts_map) -- Esc 退出插入模式
            map('t', 'jk', [[<C-\><C-n>]], opts_map)    -- jk 退出插入模式
            
            -- 使用 Win+hjkl 进行窗口跳转
            map('t', '<D-h>', [[<C-\><C-n><C-w>h]], opts_map)
            map('t', '<D-j>', [[<C-\><C-n><C-w>j]], opts_map)
            map('t', '<D-k>', [[<C-\><C-n><C-w>k]], opts_map)
            map('t', '<D-l>', [[<C-\><C-n><C-w>l]], opts_map)
            
            -- Ctrl+hjkl 也映射（先退出终端模式再跳转）
            map('t', '<C-h>', [[<C-\><C-n><C-w>h]], opts_map)
            map('t', '<C-j>', [[<C-\><C-n><C-w>j]], opts_map)
            map('t', '<C-k>', [[<C-\><C-n><C-w>k]], opts_map)
            map('t', '<C-l>', [[<C-\><C-n><C-w>l]], opts_map)
            
            -- 在终端 buffer 的 normal 模式下也支持窗口跳转
            map('n', '<C-h>', [[<C-w>h]], { buffer = buf })
            map('n', '<C-j>', [[<C-w>j]], { buffer = buf })
            map('n', '<C-k>', [[<C-w>k]], { buffer = buf })
            map('n', '<C-l>', [[<C-w>l]], { buffer = buf })
        end

        -- 3. 将按键映射挂载到 on_open 回调中
        opts.on_open = function(term)
            set_terminal_keymaps(term)
            -- 可选：打开后短暂延迟再进入插入模式，确保映射生效
            vim.defer_fn(function()
                if vim.api.nvim_buf_is_valid(term.bufnr) then
                    vim.cmd("startinsert")
                end
            end, 10)
        end

        -- 4. 初始化插件
        require("toggleterm").setup(opts)

        -- 5. 备用方案：全局终端 autocmd
        vim.api.nvim_create_autocmd("TermOpen", {
            pattern = "term://*",
            callback = function()
                local buf = vim.api.nvim_get_current_buf()
                local map = vim.keymap.set
                local buf_opts = { buffer = buf, noremap = true, silent = true }
                
                -- 退出终端模式
                map('t', '<Esc>', [[<C-\><C-n>]], buf_opts)
                map('t', 'jk', [[<C-\><C-n>]], buf_opts)
                
                -- 窗口跳转（先退出终端模式）
                map('t', '<C-h>', [[<C-\><C-n><C-w>h]], buf_opts)
                map('t', '<C-j>', [[<C-\><C-n><C-w>j]], buf_opts)
                map('t', '<C-k>', [[<C-\><C-n><C-w>k]], buf_opts)
                map('t', '<C-l>', [[<C-\><C-n><C-w>l]], buf_opts)
                
                -- Win 版本
                map('t', '<D-h>', [[<C-\><C-n><C-w>h]], buf_opts)
                map('t', '<D-j>', [[<C-\><C-n><C-w>j]], buf_opts)
                map('t', '<D-k>', [[<C-\><C-n><C-w>k]], buf_opts)
                map('t', '<D-l>', [[<C-\><C-n><C-w>l]], buf_opts)
            end
        })

        -- 6. 自定义 :Term 命令
        vim.api.nvim_create_user_command("Term", function(args)
            local term = require('toggleterm.terminal').Terminal:new({
                cmd = args.args,
                hidden = true,
                direction = "float"
            })
            term:toggle()
        end, {
            nargs = 1
        })
    end
}}