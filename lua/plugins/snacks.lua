return {{
    "folke/snacks.nvim",
    priority = 1000, -- 确保此插件在其他插件之前加载，以便尽早接管 UI
    lazy = false,    -- 禁用懒加载，因为我们需要它在启动时立即生效（例如 dashboard）
    ---@type snacks.Config
    opts = {
        -- 大文件处理：自动禁用某些耗资源的特性以优化大文件打开速度
        bigfile = {
            enabled = true -- 启用大文件检测。当打开大文件时，自动禁用 Treesitter、LSP 等耗资源功能以防止卡顿
        },
        -- 启动界面：显示仪表盘
        dashboard = {
            enabled = true -- 启用启动时的仪表盘界面，显示最近文件、项目等
        },
        -- 文件浏览器：当前已禁用
        explorer = {
            enabled = false -- 禁用 Snacks 自带的文件资源管理器（可能使用 Neo-tree 或 Nvim-tree 代替）
        },
        -- 图片预览：支持在 Neovim 中查看图片，包括 LaTeX 公式渲染
        image = {
            enabled = true, -- 启用终端内图片预览支持
            doc = {
                inline = false, -- 禁用在文档（如 Markdown）行内直接渲染图片，避免排版混乱
                float = false,  -- 禁用使用浮动窗口显示图片
                max_width = 80, -- 设置图片显示的最大字符宽度
                max_height = 40 -- 设置图片显示的最大字符高度
            },
            math = {
                latex = {
                    font_size = "small" -- 设置 LaTeX 公式渲染的字体大小为小号
                }
            }
        },
        -- 缩进线：提供美观的缩进指示
        indent = {
            enabled = true, -- 启用缩进线显示
            animate = {
                enabled = true -- 启用缩进线变化的动画效果
            },
            indent = {
                only_scope = true -- 仅显示当前作用域的缩进线，隐藏其他层级的缩进线以减少视觉干扰
            },
            scope = {
                enabled = true, -- 启用当前代码块作用域的高亮显示
                underline = true -- 在当前作用域的起始行（如 if/function）下方添加下划线
            },
            chunk = {
                -- 块渲染：当启用时，作用域将以色块形式渲染，增强层级可视性
                enabled = true
            }
        },
        -- 输入框：替换原生的 vim.ui.input
        input = {
            enabled = true -- 启用 Snacks 的输入框替代原生的 vim.ui.input（用于重命名等操作）
        },
        -- 选择器：强大的模糊查找工具（类似 Telescope）
        picker = {
            enabled = true, -- 启用选择器功能
            previewers = {
                diff = {
                    builtin = false, -- 禁用 Neovim 内置的 diff 预览
                    cmd = {"delta"} -- 使用 'delta' 命令行工具来渲染 diff，提供更好的语法高亮和差异显示
                },
                git = {
                    builtin = false, -- 禁用 Neovim 内置的 git 输出预览
                    args = {} -- 传递给 git 命令的额外参数
                }
            },
            sources = {
                spelling = {
                    layout = {
                        preset = "select" -- 拼写建议列表使用简单的下拉选择布局
                    }
                }
            },
            layout = {
                preset = "telescope" -- 默认布局预设使用类似 Telescope 的样式（通常是底部输入，上方预览）
            },
            win = {
                input = {
                    keys = {
                        -- 自定义选择器内部快捷键
                        ["<Tab>"] = {
                            "select_and_prev", -- 选中当前项并移动到上一项（通常用于多选）
                            mode = {"i", "n"}
                        },
                        ["<S-Tab>"] = {
                            "select_and_next", -- 选中当前项并移动到下一项
                            mode = {"i", "n"}
                        },
                        ["<A-Up>"] = {
                            "history_back", -- 浏览输入历史：上一条
                            mode = {"n", "i"}
                        },
                        ["<A-Down>"] = {
                            "history_forward", -- 浏览输入历史：下一条
                            mode = {"n", "i"}
                        },
                        ["<A-j>"] = {
                            "list_down", -- 结果列表向下移动
                            mode = {"n", "i"}
                        },
                        ["<A-k>"] = {
                            "list_up", -- 结果列表向上移动
                            mode = {"n", "i"}
                        },
                        ["<C-u>"] = {
                            "preview_scroll_up", -- 预览窗口向上滚动
                            mode = {"n", "i"}
                        },
                        ["<C-d>"] = {
                            "preview_scroll_down", -- 预览窗口向下滚动
                            mode = {"n", "i"}
                        },
                        ["<A-u>"] = {
                            "list_scroll_up", -- 结果列表向上滚动一页
                            mode = {"n", "i"}
                        },
                        ["<A-d>"] = {
                            "list_scroll_down", -- 结果列表向下滚动一页
                            mode = {"n", "i"}
                        },
                        ["<c-j>"] = {}, -- 禁用默认的 Ctrl+j
                        ["<c-k>"] = {}  -- 禁用默认的 Ctrl+k
                    }
                }
            }
        },
        -- 通知系统：替换原生的通知显示
        notifier = {
            enabled = true, -- 启用 Snacks 的通知系统替代 vim.notify
            style = "notification" -- 设置通知样式为标准通知气泡
        },
        -- 快速文件打开：优化大量文件加载
        quickfile = {
            enabled = true -- 启用快速文件加载优化（在插件完全加载前处理文件类型检测等）
        },
        -- 作用域检测：用于其他模块（如缩进线）
        scope = {
            enabled = true -- 启用作用域检测核心功能（供 indent 等模块使用）
        },
        -- 平滑滚动
        scroll = {
            enabled = true -- 启用平滑滚动动画（Ctrl+d/u 等操作时）
        },
        -- 状态列：自定义行号区域（支持折叠图标等）
        statuscolumn = {
            enabled = true -- 启用自定义状态列（行号区域），支持显示 Git 符号、折叠标记等
        },
        -- 单词高亮：自动高亮光标下的相同单词
        words = {
            enabled = true -- 启用光标下单词自动高亮及引用跳转支持
        },
        -- 样式定义：配置浮动终端等组件的外观
        styles = {
            terminal = {
                relative = "editor", -- 终端窗口相对于编辑器定位
                border = "rounded",  -- 使用圆角边框
                position = "float",  -- 使用浮动定位
                backdrop = 60,       -- 背景遮罩透明度（0-100），60 表示较暗的背景
                height = 0.8,        -- 终端高度占编辑器的 80%
                width = 0.8,         -- 终端宽度占编辑器的 80%
                zindex = 50          -- 设置层级，确保在其他窗口之上
            }
        }
    },
    keys = {{
        "<A-w>",
        function()
            require("snacks").bufdelete() -- 调用 bufdelete 删除当前缓冲区
        end,
        desc = "[Snacks] Delete buffer"
    }, {
        "<leader>si",
        function()
            require("snacks").image.hover() -- 在悬浮窗中显示光标下的图片
        end,
        desc = "[Snacks] Display image"
    }, {
        "<A-i>",
        function()
            require("snacks").terminal() -- 切换浮动终端的显示/隐藏
        end,
        desc = "[Snacks] Toggle terminal",
        mode = {"n", "t"}
    }, -- Notification
    {
        "<leader>sn",
        function()
            require("snacks").picker.notifications() -- 使用选择器搜索历史通知
        end,
        desc = "[Snacks] Notification history"
    }, {
        "<leader>n",
        function()
            require("snacks").notifier.show_history() -- 显示通知历史列表
        end,
        desc = "[Snacks] Notification history"
    }, {
        "<leader>un",
        function()
            require("snacks").notifier.hide() -- 立即关闭所有当前显示的通知
        end,
        desc = "[Snacks] Dismiss all notifications"
    }, -- Top Pickers & Explorer
    {
        "<leader><space>",
        function()
            require("snacks").picker.smart() -- 智能查找（通常结合了文件、缓冲区和最近文件）
        end,
        desc = "[Snacks] Smart find files"
    }, {
        "<leader>,",
        function()
            require("snacks").picker.buffers() -- 查找已打开的缓冲区
        end,
        desc = "[Snacks] Buffers"
    }, {
        "<leader>sn",
        function()
            require("snacks").picker.notifications() -- 搜索通知历史 (重复定义，保留原样)
        end,
        desc = "[Snacks] Notification history"
    }, -- find
    {
        "<leader>sb",
        function()
            require("snacks").picker.buffers() -- 查找缓冲区（备用快捷键）
        end,
        desc = "[Snacks] Buffers"
    }, {
        "<leader>sf",
        function()
            require("snacks").picker.files() -- 查找项目中的文件
        end,
        desc = "[Snacks] Find files"
    }, {
        "<leader>sp",
        function()
            require("snacks").picker.projects() -- 查找并切换项目
        end,
        desc = "[Snacks] Projects"
    }, {
        "<leader>sr",
        function()
            require("snacks").picker.recent() -- 查找最近打开的文件
        end,
        desc = "[Snacks] Recent"
    }, -- git
    {
        "<C-g>",
        function()
            require("snacks").lazygit() -- 打开 LazyGit 终端界面
        end,
        desc = "[Snacks] Lazygit"
    }, {
        "<leader>gl",
        function()
            require("snacks").picker.git_log() -- 查看 Git 提交日志
        end,
        desc = "[Snacks] Git log"
    }, {
        "<leader>gd",
        function()
            require("snacks").picker.git_diff() -- 查看 Git 差异
        end,
        desc = "[Snacks] Git diff"
    }, {
        "<leader>gb",
        function()
            require("snacks").git.blame_line() -- 显示当前行的 Git Blame 信息
        end,
        desc = "[Snacks] Git blame line"
    }, {
        "<leader>gB",
        function()
            require("snacks").gitbrowse() -- 在浏览器中打开当前文件的 Git 仓库页面
        end,
        desc = "[Snacks] Git browse"
    }, -- Grep
    -- { "<leader>sb", function() require("snacks").picker.lines() end, desc = "[Snacks] Buffer lines" },
    -- { "<leader>sB", function() require("snacks").picker.grep_buffers() end, desc = "[Snacks] Grep open buffers" },
    {
        "<leader>sg",
        function()
            require("snacks").picker.grep() -- 全局搜索文本 (Grep)
        end,
        desc = "[Snacks] Grep"
    },
    -- { "<leader>sw", function() require("snacks").picker.grep_word() end, desc = "[Snacks] Visual selection or word", mode = { "n", "x" } },
    -- search
            {
        '<leader>s"',
        function()
            require("snacks").picker.registers() -- 查看寄存器内容
        end,
        desc = "[Snacks] Registers"
    }, {
        '<leader>s/',
        function()
            require("snacks").picker.search_history() -- 查看搜索历史
        end,
        desc = "[Snacks] Search history"
    }, {
        "<leader>sa",
        function()
            require("snacks").picker.spelling() -- 查看拼写建议
        end,
        desc = "[Snacks] Spelling"
    }, {
        "<leader>sA",
        function()
            require("snacks").picker.autocmds() -- 查看自动命令
        end,
        desc = "[Snacks] Autocmds"
    }, {
        "<leader>s:",
        function()
            require("snacks").picker.command_history() -- 查看命令历史
        end,
        desc = "[Snacks] Command history"
    }, {
        "<leader>sc",
        function()
            require("snacks").picker.commands() -- 查看可用命令
        end,
        desc = "[Snacks] Commands"
    }, {
        "<leader>sd",
        function()
            require("snacks").picker.diagnostics() -- 查看所有诊断信息
        end,
        desc = "[Snacks] Diagnostics"
    }, {
        "<leader>sD",
        function()
            require("snacks").picker.diagnostics_buffer() -- 查看当前缓冲区的诊断信息
        end,
        desc = "[Snacks] Diagnostics buffer"
    }, {
        "<leader>sH",
        function()
            require("snacks").picker.help() -- 搜索帮助文档
        end,
        desc = "[Snacks] Help pages"
    }, {
        "<leader>sh",
        function()
            require("snacks").picker.highlights() -- 搜索高亮组
        end,
        desc = "[Snacks] Highlights"
    }, {
        "<leader>sI",
        function()
            require("snacks").picker.icons() -- 搜索图标
        end,
        desc = "[Snacks] Icons"
    }, {
        "<leader>sj",
        function()
            require("snacks").picker.jumps() -- 查看跳转列表
        end,
        desc = "[Snacks] Jumps"
    }, {
        "<leader>sk",
        function()
            require("snacks").picker.keymaps() -- 查看快捷键映射
        end,
        desc = "[Snacks] Keymaps"
    }, {
        "<leader>sl",
        function()
            require("snacks").picker.loclist() -- 查看位置列表
        end,
        desc = "[Snacks] Location list"
    }, {
        "<leader>sm",
        function()
            require("snacks").picker.marks() -- 查看标记
        end,
        desc = "[Snacks] Marks"
    }, {
        "<leader>sM",
        function()
            require("snacks").picker.man() -- 查看 Man 手册
        end,
        desc = "[Snacks] Man pages"
    }, {
        "<leader>sp",
        function()
            require("snacks").picker.lazy() -- 搜索插件规范
        end,
        desc = "[Snacks] Search for plugin spec"
    }, {
        "<leader>sq",
        function()
            require("snacks").picker.qflist() -- 查看 Quickfix 列表
        end,
        desc = "[Snacks] Quickfix list"
    }, {
        "<leader>sr",
        function()
            require("snacks").picker.resume() -- 恢复上次的选择器会话
        end,
        desc = "[Snacks] Resume"
    }, {
        "<leader>su",
        function()
            require("snacks").picker.undo() -- 查看撤销历史树
        end,
        desc = "[Snacks] Undo history"
    }, -- LSP
    {
        "gd",
        function()
            require("snacks").picker.lsp_definitions() -- 跳转到定义
        end,
        desc = "[Snacks] Goto definition"
    }, {
        "gD",
        function()
            require("snacks").picker.lsp_declarations() -- 跳转到声明
        end,
        desc = "[Snacks] Goto declaration"
    }, {
        "gr",
        function()
            require("snacks").picker.lsp_references() -- 查找引用
        end,
        desc = "[Snacks] References"
    }, {
        "gI",
        function()
            require("snacks").picker.lsp_implementations() -- 跳转到实现
        end,
        desc = "[Snacks] Goto implementation"
    }, {
        "gy",
        function()
            require("snacks").picker.lsp_type_definitions() -- 跳转到类型定义
        end,
        desc = "[Snacks] Goto t[y]pe definition"
    }, {
        "<leader>ss",
        function()
            require("snacks").picker.lsp_symbols() -- 查找当前文件的 LSP 符号
        end,
        desc = "[Snacks] LSP symbols"
    }, {
        "<leader>sS",
        function()
            require("snacks").picker.lsp_workspace_symbols() -- 查找工作区的 LSP 符号
        end,
        desc = "[Snacks] LSP workspace symbols"
    }, -- Words
    {
        "]]",
        function()
            require("snacks").words.jump(vim.v.count1) -- 跳转到下一个相同的单词
        end,
        desc = "[Snacks] Next Reference",
        mode = {"n", "t"}
    }, {
        "[[",
        function()
            require("snacks").words.jump(-vim.v.count1) -- 跳转到上一个相同的单词
        end,
        desc = "[Snacks] Prev Reference",
        mode = {"n", "t"}
    }, -- Zen mode
    {
        "<leader>z",
        function()
            require("snacks").zen() -- 切换 Zen 模式（专注模式）
        end,
        desc = "[Snacks] Toggle Zen Mode"
    }, {
        "<leader>Z",
        function()
            require("snacks").zen.zoom() -- 切换 Zoom 模式（最大化当前窗口）
        end,
        desc = "[Snacks] Toggle Zoom"
    }}
}}
