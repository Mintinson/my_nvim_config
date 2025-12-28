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
                function() return " " end, -- 一个占位符，纯为了排版好看
                color = "Comment"
            }}
        },
        lualine_x = {"lsp_status"}, -- 顶部右侧：显示 LSP 加载状态
        inactive_winbar = {
            -- Always show winbar
            -- stylua: ignore
            lualine_b = {function() return " " end}
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
    }, -- === 新增：关闭所有其他标签 (Close All But Current) ===
    {
        "<leader>bo",
        "<CMD>BufferCloseAllButCurrent<CR>",
        mode = {"n"},
        desc = "[Buffer] Close all other buffers"
    }},

    opts = {
        -- Automatically hide the tabline when there are this many buffers left.
        -- Set to any value >=0 to enable.
        auto_hide = false,
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
    -- main = "rainbow-delimiters.setup", -- 指定入口函数
    -- opts = {} -- 默认配置：让成对的括号显示不同颜色，方便看代码嵌套
    config = function()
        -- 1. 引入你自己的主题配置 (lua/config/theme.lua)
        -- 这样括号颜色就能和你当前的 Ayu 主题完美融合
        local theme = require("config.theme")
        local colors = theme.colors

        -- 2. 定义高亮组 (映射到你的主题变量)
        vim.api.nvim_set_hl(0, "RainbowDelimiterRed", {
            fg = colors.red
        }) -- #F07178
        vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", {
            fg = colors.warning
        }) -- #E6B450
        vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", {
            fg = colors.secondary
        }) -- #39BAE6
        vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", {
            fg = colors.peach
        }) -- #FF8F40
        vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", {
            fg = colors.green
        }) -- #C2D94C
        vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", {
            fg = colors.mauve
        }) -- #D4BFFF
        vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", {
            fg = colors.hint
        }) -- #95E6CB

        -- 3. 配置插件使用上述颜色
        local rainbow = require("rainbow-delimiters")
        require("rainbow-delimiters.setup").setup({
            strategy = {
                [''] = rainbow.strategy['global'],
                vim = rainbow.strategy['local']
            },
            query = {
                [''] = 'rainbow-delimiters',
                lua = 'rainbow-blocks'
            },
            -- 指定颜色循环顺序
            highlight = {"RainbowDelimiterRed", "RainbowDelimiterYellow", "RainbowDelimiterBlue",
                         "RainbowDelimiterOrange", "RainbowDelimiterGreen", "RainbowDelimiterViolet",
                         "RainbowDelimiterCyan"}
        })
    end
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
}, {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    opts = {
        ---@type false | "classic" | "modern" | "helix"
        preset = "helix",
        win = {
            -- no_overlap = true,
            title = false,
            width = 0.5
        }
    },
    keys = {{
        "<leader>?",
        function()
            require("which-key").show({
                global = false
            })
        end,
        desc = "Buffer local KeyMaps (which-key)"
    }}
}, {
    "petertriho/nvim-scrollbar",
    opts = {
        handelers = {
            gitsigns = true, -- Requires gitsigns
            search = true -- Requires hlslens
        },
        marks = {
            Search = {
                color = "#65b7f1"
            },
            GitAdd = {
                text = "┃"
            },
            GitChange = {
                text = "┃"
            },
            GitDelete = {
                text = "_"
            }
        }
    }
}, {
    "kevinhwang91/nvim-hlslens",
    -- stylua: ignore
    keys = {{
        "n",
        "nzz<Cmd>lua require('hlslens').start()<CR>",
        mode = "n",
        desc = "Next match",
        noremap = true,
        silent = true
    }, {
        "N",
        "Nzz<Cmd>lua require('hlslens').start()<CR>",
        mode = "n",
        desc = "Previous match",
        noremap = true,
        silent = true
    }, {
        "\\",
        "<Cmd>noh<CR>",
        mode = "n",
        desc = "Clear highlight",
        noremap = true,
        silent = true
    }, {"/"}, {"?"}},
    opts = {
        nearest_only = true
    },
    config = function(_, opts)
        -- require('hlslens').setup() is not required
        require("scrollbar.handlers.search").setup(opts)
        vim.api.nvim_set_hl(0, "HlSearchLens", {
            link = "CurSearch"
        })
        vim.api.nvim_set_hl(0, "HlSearchLensNear", {
            fg = "#CBA6F7"
        })
    end
}, {
    "echasnovski/mini.diff",
    event = "BufReadPost",
    version = "*",
    -- stylua: ignore
    keys = {{
        "<leader>df",
        function() require("mini.diff").toggle_overlay(vim.api.nvim_get_current_buf()) end,
        mode = "n",
        desc = "[Mini.Diff] Toggle diff overlay"
    }},
    opts = {
        -- Module mappings. Use `''` (empty string) to disable one.
        -- NOTE: Mappings are handled by gitsigns.
        mappings = {
            -- Apply hunks inside a visual/operator region
            apply = "",
            -- Reset hunks inside a visual/operator region
            reset = "",
            -- Hunk range textobject to be used inside operator
            -- Works also in Visual mode if mapping differs from apply and reset
            textobject = "",
            -- Go to hunk range in corresponding direction
            goto_first = "",
            goto_prev = "",
            goto_next = "",
            goto_last = ""
        }
    }
}, {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    opts = {
        signcolumn = false, -- 禁用左侧专用的 Git 符号列
        numhl = true, -- 启用行号高亮，通过行号颜色显示 Git 状态
        -- word_diff = true, -- 启用单词级差异对比
        current_line_blame = true, -- 在当前行末尾显示 Git Blame 信息
        attach_to_untracked = true, -- 追踪未加入 Git 管理的文件
        preview_config = {
            border = "rounded" -- 差异预览窗口使用圆角边框
        },
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")

            -- 快捷键映射辅助函数
            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- === 导航 (Navigation) ===
            -- 跳转到下一个修改块 (Hunk)
            -- stylua: ignore
            map("n", "]h", function()
                if vim.wo.diff then
                    vim.cmd.normal({
                        "]h",
                        bang = true
                    })
                else
                    gitsigns.nav_hunk("next")
                end
            end, {
                desc = "[Git] Next hunk"
            })
            -- 跳转到最后一个修改块
            -- stylua: ignore
            map("n", "]H", function()
                if vim.wo.diff then
                    vim.cmd.normal({
                        "]H",
                        bang = true
                    })
                else
                    gitsigns.nav_hunk("last")
                end
            end, {
                desc = "[Git] Last hunk"
            })
            -- 跳转到上一个修改块
            -- stylua: ignore
            map("n", "[h", function()
                if vim.wo.diff then
                    vim.cmd.normal({
                        "[h",
                        bang = true
                    })
                else
                    gitsigns.nav_hunk("prev")
                end
            end, {
                desc = "[Git] Prev hunk"
            })
            -- 跳转到第一个修改块
            -- stylua: ignore
            map("n", "[H", function()
                if vim.wo.diff then
                    vim.cmd.normal({
                        "[H",
                        bang = true
                    })
                else
                    gitsigns.nav_hunk("first")
                end
            end, {
                desc = "[Git] First hunk"
            })

            -- === 操作 (Actions) ===
            -- 暂存 (Stage) 当前修改块
            map("n", "<leader>ggs", gitsigns.stage_hunk, {
                desc = "[Git] Stage hunk"
            })
            -- 可视模式下暂存选中的修改块
            -- stylua: ignore
            map("v", "<leader>ggs", function() gitsigns.stage_hunk({vim.fn.line("."), vim.fn.line("v")}) end, {
                desc = "[Git] Stage hunk (Visual)"
            })

            -- 重置 (Reset) 当前修改块
            map("n", "<leader>ggr", gitsigns.reset_hunk, {
                desc = "[Git] Reset hunk"
            })
            -- 可视模式下重置选中的修改块
            -- stylua: ignore
            map("v", "<leader>ggr", function() gitsigns.reset_hunk({vim.fn.line("."), vim.fn.line("v")}) end, {
                desc = "[Git] Reset hunk (Visual)"
            })

            -- 暂存整个文件的修改
            map("n", "<leader>ggS", gitsigns.stage_buffer, {
                desc = "[Git] Stage buffer"
            })
            -- 重置整个文件的修改
            map("n", "<leader>ggR", gitsigns.reset_buffer, {
                desc = "[Git] Reset buffer"
            })

            -- 预览当前修改块的内容
            map("n", "<leader>ggp", gitsigns.preview_hunk, {
                desc = "[Git] Preview hunk"
            })
            -- 在行内预览修改块
            map("n", "<leader>ggP", gitsigns.preview_hunk_inline, {
                desc = "[Git] Preview hunk inline"
            })

            -- 将所有差异放入 Quickfix 列表
            -- stylua: ignore
            map("n", "<leader>ggQ", function() gitsigns.setqflist("all") end, {
                desc = "[Git] Show diffs (ALL) in qflist"
            })
            -- 将当前文件的差异放入 Quickfix 列表
            -- stylua: ignore
            map("n", "<leader>ggq", gitsigns.setqflist, {
                desc = "[Git] Show diffs in qflist"
            })

            -- 文本对象：ih 表示当前修改块 (用于 ciH, diH 等操作)
            map({"o", "x"}, "ih", gitsigns.select_hunk, {
                desc = "[Git] Current hunk"
            })

            -- === 开关 (Toggles) ===
            -- 切换行末 Blame 显示
            require("snacks").toggle({
                name = "line blame",
                get = function() return require("gitsigns.config").config.current_line_blame end,
                set = function(enabled) require("gitsigns").toggle_current_line_blame(enabled) end
            }):map("<leader>tgb")
            -- 切换单词级差异显示
            require("snacks").toggle({
                name = "word diff",
                get = function() return require("gitsigns.config").config.word_diff end,
                set = function(enabled) require("gitsigns").toggle_word_diff(enabled) end
            }):map("<leader>tgw")
        end
    },

    config = function(_, opts)
        require("gitsigns").setup(opts)
        -- 集成滚动条插件，在滚动条上显示 Git 修改标记
        require("scrollbar.handlers.gitsigns").setup()
    end
}, {
    -- 6. Colorizer: 颜色代码高亮 (如 #FFFFFF 会直接显示对应的背景色)
    "norcalli/nvim-colorizer.lua",
    config = function(_, _) require("colorizer").setup() end
}, {
    -- 7. Showkeys: 在屏幕上实时显示你按下的按键 (适合录屏或演示)
    "nvzone/showkeys",
    cmd = "ShowkeysToggle",
    opts = {
        maxkeys = 5 -- 最多同时显示 5 个按键
    }
}, -- TODO: 稍后在配置 LSP 代码操作时进行详细配置
{
    -- 8. Lightbulb: 当当前行有可用的 LSP 代码操作 (Code Action) 时显示灯泡图标
    "kosayoda/nvim-lightbulb"
}, {
    -- 9. Tiny Code Action: 提供一个更漂亮、更现代的 LSP 代码操作选择菜单
    "rachartier/tiny-code-action.nvim",
    dependencies = {{"nvim-lua/plenary.nvim"}, {
        "folke/snacks.nvim",
        opts = {
            terminal = {}
        }
    }},
    event = "LspAttach",
    opts = {}
}, {
    -- 10. UFO (Ultra Fold Optimization): 极简且强大的代码折叠增强插件
    "kevinhwang91/nvim-ufo",
    dependencies = {"kevinhwang91/promise-async"},
    opts = {
        -- 折叠提供者选择器：优先使用 treesitter，其次是缩进 (indent)
        provider_selector = function(_, _, _) return {"treesitter", "indent"} end,

        open_fold_hl_timeout = 0,
        -- 自定义折叠虚拟文本：在折叠行末尾显示该折叠包含的行数
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = (" 󰁂 %d "):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, {chunkText, hlGroup})
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, {suffix, "MoreMsg"})
            return newVirtText
        end
    },

    init = function()
        -- UFO 要求的折叠基础设置
        vim.o.foldenable = true
        vim.o.foldcolumn = "0"
        vim.o.foldlevel = 99 -- 默认不折叠 (层级很高)
        vim.o.foldlevelstart = 99
        vim.opt.fillchars = {
            fold = " ",
            foldopen = "▾",
            foldsep = "│",
            foldclose = "▸"
        }
    end,

    config = function(_, opts)
        require("ufo").setup(opts)
        -- 自动命令：在读取缓冲区前初始化折叠层级变量
        vim.api.nvim_create_autocmd("BufReadPre", {
            callback = function() vim.b.ufo_foldlevel = 0 end
        })

        -- 设置当前缓冲区的折叠层级
        local set_buf_foldlevel = function(num)
            vim.b.ufo_foldlevel = num
            require("ufo").closeFoldsWith(num)
        end

        -- 增量修改折叠层级
        local change_buf_foldlevel_by = function(num)
            local foldlevel = vim.b.ufo_foldlevel or 0
            if foldlevel + num >= 0 then
                foldlevel = foldlevel + num
            else
                foldlevel = 0
            end
            set_buf_foldlevel(foldlevel)
        end

        -- === 快捷键映射 ===
        -- K: 如果在折叠处则预览折叠内容，否则触发 LSP 悬浮文档 (Hover)
        vim.keymap.set("n", "K", function()
            local winid = require("ufo").peekFoldedLinesUnderCursor()
            if not winid then vim.lsp.buf.hover() end
        end)

        -- zM: 关闭所有折叠
        -- stylua: ignore
        vim.keymap.set("n", "zM", function() set_buf_foldlevel(0) end, { desc = "[UFO] Close all folds" })
        -- zR: 打开所有折叠
        vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "[UFO] Open all folds" })

        -- zm: 折叠更多 (层级递减)
        vim.keymap.set("n", "zm", function()
            local count = vim.v.count
            if count == 0 then count = 1 end
            change_buf_foldlevel_by(-count)
        end, { desc = "[UFO] Fold More" })
        -- zr: 折叠更少 (层级递增)
        vim.keymap.set("n", "zr", function()
            local count = vim.v.count
            if count == 0 then count = 1 end
            change_buf_foldlevel_by(count)
        end, { desc = "[UFO] Fold Less" })

        -- zS: 设置具体的折叠层级 (配合数字使用，如 2zS)
        vim.keymap.set("n", "zS", function()
            if vim.v.count == 0 then
                vim.notify("No foldlevel given to set!", vim.log.levels.WARN)
            else
                set_buf_foldlevel(vim.v.count)
            end
        end, { desc = "[UFO] Set foldlevel" })

        -- 禁用一些与 UFO 不兼容或冲突的默认折叠快捷键
        vim.keymap.set("n", "zE", "<NOP>", { desc = "Disabled" })
        vim.keymap.set("n", "zx", "<NOP>", { desc = "Disabled" })
        vim.keymap.set("n", "zX", "<NOP>", { desc = "Disabled" })
    end
}}
