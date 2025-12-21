return { -----------------------------------------------------------------------------
-- 1. Lualine: 底部状态栏美化
-----------------------------------------------------------------------------
{
    "nvim-lualine/lualine.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons", "AndreM222/copilot-lualine"}, -- 依赖图标库，让状态栏显示文件图标
    opts = {
        options = {
            theme = "ayu", -- 设置主题为 Ayu
            always_divide_middle = false -- 当有多个分屏时，不强制在中间显示分割线
        },
        -- sections 定义底栏的显示内容 (A/B/C 在左边，X/Y/Z 在右边)
        sections = {
            lualine_a = {"mode"}, -- 最左侧：显示当前模式 (NORMAL/INSERT)
            lualine_b = {"branch", "diff", "diagnostics"}, -- 左二：Git分支、差异、LSP诊断错误
            lualine_c = {"filename"}, -- 中间左侧：当前文件名
            lualine_x = {}, -- 中间右侧：留空
            lualine_y = {"encoding", "fileformat", "filetype", "progress"} -- 右侧：编码(utf-8)、系统格式(unix)、文件类型(lua)、进度百分比
        },
        -- winbar 定义窗口顶部的“面包屑”导航栏
        winbar = {
            lualine_a = {"filename"}, -- 顶部左侧：显示文件名
            lualine_b = {{
                function()
                    return " "
                end, -- 一个占位符，纯为了排版好看
                color = "Comment"
            }}
        },
        lualine_x = {"lsp_status"}, -- 顶部右侧：显示 LSP 加载状态
        inactive_winbar = {
            -- Always show winbar
            -- stylua: ignore
            lualine_b = {function()
                return " "
            end}
        }
    },
    config = function(_, opts)
        local theme = require("config.theme")
        local colors = theme.colors

        local copilot = {
            "copilot",
            show_colors = true,
            symbols = {
                status = {
                    hl = {
                        enabled = colors.green,
                        sleep = colors.overlay,
                        disabled = colors.surface,
                        warning = colors.peach,
                        unknown = colors.red
                    }
                },
                spinner_color = colors.mauve
            }
        }
        table.insert(opts.sections.lualine_c, 1, copilot)
        require("lualine").setup(opts)
    end
}, -----------------------------------------------------------------------------
-- 2. Barbar: 顶部标签页 (类似浏览器的 Tabs)
-----------------------------------------------------------------------------
{
    "romgrk/barbar.nvim",
    version = '^1.0.0', -- 指定版本，防止大版本更新破坏配置
    dependencies = {'lewis6991/gitsigns.nvim', 'nvim-tree/nvim-web-devicons'}, -- 依赖 Git 信息和图标

    init = function()
        vim.g.barbar_auto_setup = false -- 禁用自动启动，必须手动调用 setup (由 lazy 自动处理)
    end,

    event = {"VeryLazy"}, -- 延迟加载，等界面画好后再加载，提升启动速度

    -- === 快捷键映射 ===
    keys = { -- 移动标签页位置 (Alt + , / Alt + .)
    {
        "<A-,>",
        "<CMD>BufferMovePrevious<CR>",
        mode = {"n"},
        desc = "[Buffer] Move buffer left"
    }, {
        "<A-.>",
        "<CMD>BufferMoveNext<CR>",
        mode = {"n"},
        desc = "[Buffer] Move buffer right"
    }, -- 快速跳转到第 1-9 个标签 (Alt + 1~9)
    {
        "<A-1>",
        "<CMD>BufferGoto 1<CR>",
        mode = {"n"},
        desc = "[Buffer] Go to buffer 1"
    }, {
        "<A-2>",
        "<CMD>BufferGoto 2<CR>",
        mode = {"n"},
        desc = "[Buffer] Go to buffer 2"
    }, {
        "<A-3>",
        "<CMD>BufferGoto 3<CR>",
        mode = {"n"},
        desc = "[Buffer] Go to buffer 3"
    }, {
        "<A-4>",
        "<CMD>BufferGoto 4<CR>",
        mode = {"n"},
        desc = "[Buffer] Go to buffer 4"
    }, {
        "<A-5>",
        "<CMD>BufferGoto 5<CR>",
        mode = {"n"},
        desc = "[Buffer] Go to buffer 5"
    }, {
        "<A-6>",
        "<CMD>BufferGoto 6<CR>",
        mode = {"n"},
        desc = "[Buffer] Go to buffer 6"
    }, {
        "<A-7>",
        "<CMD>BufferGoto 7<CR>",
        mode = {"n"},
        desc = "[Buffer] Go to buffer 7"
    }, {
        "<A-8>",
        "<CMD>BufferGoto 8<CR>",
        mode = {"n"},
        desc = "[Buffer] Go to buffer 8"
    }, {
        "<A-9>",
        "<CMD>BufferGoto 9<CR>",
        mode = {"n"},
        desc = "[Buffer] Go to buffer 9"
    }, -- 切换上一个/下一个标签 (Alt + h / Alt + l)
    {
        "<A-h>",
        "<CMD>BufferPrevious<CR>",
        mode = {"n"},
        desc = "[Buffer] Previous buffer"
    }, {
        "<A-l>",
        "<CMD>BufferNext<CR>",
        mode = {"n"},
        desc = "[Buffer] Next buffer"
    }, -- 关闭当前标签 (Alt + w)
    {
        "<A-w>",
        "<CMD>BufferClose<CR>",
        mode = {"n"},
        desc = "Close buffer"
    }},

    opts = {
        -- Automatically hide the tabline when there are this many buffers left.
        -- Set to any value >=0 to enable.
        auto_hide = 1,
        -- 侧边栏集成配置
        sidebar_filetypes = {
            -- 当打开 NvimTree 时，Barbar 会自动向右偏移，防止挡住文件树的标题
            NvimTree = true
        }
    }
}, -----------------------------------------------------------------------------
-- 3. NvimTree: 左侧文件资源管理器
-----------------------------------------------------------------------------
{
    "nvim-tree/nvim-tree.lua",
    version = "*", -- 使用最新稳定版
    dependencies = {"nvim-tree/nvim-web-devicons"},

    -- 这里定义了开关文件树的快捷键：Ctrl + b
    keys = {{
        "<C-b>",
        "<CMD>NvimTreeToggle<CR>",
        mode = {"n"},
        desc = "[NvimTree] Toggle NvimTree"
    }},
    opts = {} -- 使用默认配置
}, -----------------------------------------------------------------------------
-- 4. Rainbow Delimiters: 彩虹括号
-----------------------------------------------------------------------------
{
    "HiPhish/rainbow-delimiters.nvim",
    submodules = false, -- 不需要下载子模块
    main = "rainbow-delimiters.setup", -- 指定入口函数
    opts = {} -- 默认配置：让成对的括号显示不同颜色，方便看代码嵌套
}, -----------------------------------------------------------------------------
-- 5. Noice: 消息通知与命令行 UI 增强
-----------------------------------------------------------------------------
{
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {"MunifTanjim/nui.nvim", -- UI 组件库依赖
    {
        "rcarriga/nvim-notify", -- 漂亮的右下角弹窗通知插件
        opts = {
            background_colour = "#000000" -- 设置通知弹窗的背景色为纯黑
        }
    }},
    keys = { -- 查看历史消息记录 (<leader>sN 或 <leader>N)
    {
        "<leader>sN",
        "<CMD>Noice pick<CR>",
        desc = "[Noice] Pick history messages"
    }, {
        "<leader>N",
        "<CMD>Noice<CR>",
        desc = "[Noice] Show history messages"
    }},
    opts = {
        -- 弹出菜单配置 (输入时的补全列表)
        popupmenu = {
            enabled = false -- 禁用 Noice 自带的补全菜单 (通常因为你已经用了 cmp 插件，避免冲突)
        },
        notify = {
            enabled = false
        },
        -- LSP 集成配置
        lsp = {
            override = {
                -- 接管 LSP 的文档悬浮窗和 Markdown 渲染，让它们看起来更漂亮（有边框、高亮等）
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cop.entry.get_documentation"] = true
            }
        },
        -- 预设配置 (Presets)
        presets = {
            bottom_search = false, -- 搜索栏位置：设为 true 会像传统 Vim 一样在底部，设为 false 可能会浮动
            command_palette = true, -- 命令行面板：按 : 后，输入框会出现在屏幕中间，类似 VSCode 的命令面板
            long_message_to_split = true, -- 长消息处理：如果报错信息太长，自动分屏显示，而不是挤在小弹窗里
            inc_rename = false, -- 禁用即时重命名输入框 (除非你装了 inc-rename.nvim)
            lsp_doc_border = true -- 给 LSP 的悬浮文档加个边框，更美观
        },

        -- 消息过滤器 (Routes)
        routes = { -- 这是一个过滤器，用于屏蔽恼人的消息
        {
            filter = {
                event = "msg_show",
                kind = "" -- 匹配普通消息
            },
            opts = {
                skip = true -- 直接跳过 (不显示)
            }
        } -- 注意：上面这个过滤规则非常激进，可能会屏蔽掉 ":w" 保存时显示的 "written" 提示。
        -- 如果你发现保存文件时没提示了，就是这几行代码干的。
        }
    }
}, {
    "echasnovski/mini.diff",
    event = "BufReadPost",
    version = "*",
    -- stylua: ignore
    opts = {}
},
{
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      ---@type false | "classic" | "modern" | "helix"
      preset = "helix",
      win = {
        -- no_overlap = true,
        title = false,
        width = 0.5,
      },
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({global = false})
            end,
            desc = "Buffer local KeyMaps (which-key)"
        }
    }
}
}
