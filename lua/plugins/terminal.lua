return {{
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
        -- === 核心配置 ===
        size = 15, -- 终端的高度（如果是水平分屏）
        open_mapping = [[<C-\>]], -- 核心快捷键：Ctrl + \ 来切换终端显示/隐藏

        -- === 外观样式 ===
        -- 选项：'vertical' | 'horizontal' | 'tab' | 'float'
        -- 'horizontal': 像 VS Code 默认那样在底部
        -- 'float': 浮动在中间
        direction = "horizontal",

        shade_terminals = true, -- 背景稍微变暗，区分代码区
        start_in_insert = true, -- 打开自动进入插入模式
        insert_mappings = true, -- 允许在终端模式使用 Ctrl+n 等键
        persist_size = true, -- 记住上次调整的大小
        close_on_exit = true, -- 输 exit 退出时自动关闭窗口
        -- 默认 shell 设置为 nil，这样它会跟随我们下面 config 中设置的 vim.opt.shell
        shell = nil,

        -- === 浮动窗口样式 (如果你选 float 模式) ===
        float_opts = {
            border = "curved", -- 边框风格：'single' | 'double' | 'shadow' | 'curved'
            winblend = 0 -- 透明度 (0-100)
        }
    },
    config = function(_, opts)
        -- 智能判断 OS 并设置默认 Shell

        -- 如果是 Windows
        if vim.fn.has("win32") == 1 then
            -- 优先尝试使用 PowerShell 7 (pwsh), 如果没有则用旧版 PowerShell
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
            -- 如果是 Linux / macOS，通常默认就是 bash 或 zsh，不需要额外配置
            -- 但如果你想强制指定 bash：
            vim.opt.shell = "/bin/zsh"
        end

        require("toggleterm").setup(opts)
        -- === 关键优化：解决终端模式下 Esc 无法退出的问题 ===
        -- 默认在终端里按 Esc 是没反应的（为了兼容 top 等命令），这让新手很抓狂。
        -- 这里把 Esc 映射为“回到普通模式”，方便你切回代码窗口。
        function _G.set_terminal_keymaps()
            local opts = {
                buffer = 0
            }
            -- 按 Esc 退出插入模式，回到终端的 Normal 模式
            vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
            -- 按 jk 也可以退出 (如果你习惯了 jk)
            vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)

            -- 像在代码窗格一样，用 Ctrl+h/j/k/l 在终端和代码之间跳转
            vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
            vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
            vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
            vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        end

        -- 每次打开终端时自动加载上述按键映射
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

        -- 创建一个命令 :Term <cmd>
        -- 例如输入 :Term python 就会打开 python 终端
        -- 输入 :Term cmd 就会打开 cmd
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

        -- local Terminal = require('toggleterm.terminal').Terminal
        -- local lazygit = Terminal:new({
        --     cmd = "lazygit",
        --     hidden = true,
        --     direction = "float"
        -- })

        -- function _lazygit_toggle()
        --     lazygit:toggle()
        -- end

        -- -- 映射 <leader>g 打开 Lazygit
        -- vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", {
        --     noremap = true,
        --     silent = true
        -- })
    end

}}
