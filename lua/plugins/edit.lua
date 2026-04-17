return {
    -- Auto-pairs brackets, parens, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
      
    },
  },
--   -- Trim whitespace on save
--   {
--     "cappyzawa/trim.nvim",
--     event = "BufWritePre",
--     opts = {},
--   },

  -- record and visualize undo history
  {
    "mbbill/undotree",
    keys = {
      { "<leader>ut", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo-tree" },
    },
    init = function()
      vim.cmd([[
      if has("persistent_undo")
         let target_path = expand('~/.undodir')

          " create the directory and any parent directories if the location does not exist.
          if !isdirectory(target_path)
              call mkdir(target_path, "p", 0700)
          endif

          let &undodir=target_path
          set undofile
      endif
      ]])
    end,
  },

  {
    "numToStr/Comment.nvim",
    -- stylua: ignore
    keys = {
      -- Normal mode (普通模式)
      { "<C-/>", function() require("Comment.api").toggle.linewise.current() end, mode = "n", desc = "Comment toggle current line" },
      { "<C-_>", function() require("Comment.api").toggle.linewise.current() end, mode = "n", desc = "Comment toggle current line" },
      
      -- Visual mode (可视模式)
      { "<C-/>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", mode = "v", desc = "Comment toggle linewise (visual)" },
      { "<C-_>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", mode = "v", desc = "Comment toggle linewise (visual)" },
      
      -- Insert mode (插入模式)
      { "<C-/>", "<C-o><cmd>lua require('Comment.api').toggle.linewise.current()<cr>", mode = "i", desc = "Comment toggle current line" },
      { "<C-_>", "<C-o><cmd>lua require('Comment.api').toggle.linewise.current()<cr>", mode = "i", desc = "Comment toggle current line" },
    },
    config = true,
  },
    -----------------------------------------------------------------------------
    -- 4. smartyank.nvim: 智能复制增强
    -- - 复制时高亮显示复制的内容
    -- - 支持 OSC52 协议，可在 SSH 远程会话中复制到本地剪贴板
    -----------------------------------------------------------------------------
    {
        "ibhagwan/smartyank.nvim",
        event = { "BufWinEnter" }, -- 打开缓冲区窗口时加载
        opts = {
            highlight = {
                timeout = 100, -- 高亮持续时间 (毫秒)
                               -- 复制后，被复制的文本会短暂高亮，便于确认复制范围
            },
            clipboard = {
                enabled = true, -- 启用系统剪贴板集成
                                -- 复制的内容会同步到系统剪贴板
            },
            osc52 = {
                enabled = true, -- 启用 OSC52 协议 (默认)
                                -- 这让你在 SSH 远程连接时，复制内容能传回本地剪贴板
                silent = false,  -- 静默模式：不显示 "n chars copied" 提示消息
                                -- 设为 false 会在每次复制时显示复制了多少字符
            },
        },
    },

  -- {
  --   "folke/flash.nvim",
  --   event = "BufReadPost",
  --   opts = {
  --     label = {
  --       rainbow = {
  --         enabled = true,
  --         shade = 1,
  --       },
  --     },
  --     modes = {
  --       char = {
  --         enabled = false,
  --       },
  --     },
  --   },
  --   keys = {
  --     -- stylua: ignore
  --     { "<leader>f", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "[Flash] Jump"              },
  --     -- stylua: ignore
  --     { "<leader>F", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "[Flash] Treesitter"        },
  --     -- stylua: ignore
  --     { "<leader>F", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "[Flash] Treesitter Search" },
  --     -- stylua: ignore
  --     { "<c-f>",     mode = { "c" },           function() require("flash").toggle() end,            desc = "[Flash] Toggle Search"     },
  --     {
  --       "<leader>j",
  --       mode = { "n", "x", "o" },
  --       function()
  --         require("flash").jump({
  --           search = { mode = "search", max_length = 0 },
  --           label = { after = { 0, 0 }, matches = false },
  --           jump = { pos = "end" },
  --           pattern = "^\\s*\\S\\?", -- match non-whitespace at start plus any character (ignores empty lines)
  --         })
  --       end,
  --       desc = "[Flash] Line jump",
  --     },
  --     {
  --       "<leader>k",
  --       mode = { "n", "x", "o" },
  --       function()
  --         require("flash").jump({
  --           search = { mode = "search", max_length = 0 },
  --           label = { after = { 0, 0 }, matches = false },
  --           jump = { pos = "end" },
  --           pattern = "^\\s*\\S\\?", -- match non-whitespace at start plus any character (ignores empty lines)
  --         })
  --       end,
  --       desc = "[Flash] Line jump",
  --     },
  --   },
  -- },

      {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            -- 标签样式
            label = {
                uppercase = false,  -- 使用小写字母作为标签
                rainbow = {
                    enabled = true,  -- 彩虹色标签
                    shade = 5,
                },
            },
            -- 跳转模式配置
            modes = {
                -- 搜索模式（/ 和 ?）
                search = {
                    enabled = false,  -- 不接管搜索，保持原生行为
                },
                -- 字符跳转模式（f/F/t/T）
                char = {
                    enabled = true,   -- 启用 f/F/t/T 增强
                    -- 配置哪些按键启用 flash
                    keys = { "f", "F", "t", "T", ";", "," },
                    -- 多行跳转
                    multi_line = true,
                    -- 高亮配置
                    highlight = {
                        backdrop = true,  -- 显示背景遮罩，让目标更突出
                    },
                    -- 跳转后的行为
                    jump = {
                        autojump = false,  -- 不自动跳转，等待选择
                    },
                },
            },
            -- 高亮组配置
            highlight = {
                backdrop = true,
                matches = true,
                groups = {
                    match = "FlashMatch",
                    current = "FlashCurrent",
                    backdrop = "FlashBackdrop",
                    label = "FlashLabel",
                },
            },
        },
        -- stylua: ignore
        keys = {
            -- 通用跳转（按 s 然后输入字符）
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "[Flash] Jump" },
            -- Treesitter 选择（按 S 选择语法节点）
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "[Flash] Treesitter" },
            -- 远程操作（在操作符模式下跳转到目标执行操作）
            { "r", mode = "o", function() require("flash").remote() end, desc = "[Flash] Remote" },
            -- Treesitter 搜索
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "[Flash] Treesitter Search" },
            -- 在命令行搜索中切换 flash
            { "<C-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "[Flash] Toggle Flash Search" },
        },
        config = function(_, opts)
            require("flash").setup(opts)
            
            -- 注册到 which-key
            local ok, wk = pcall(require, "which-key")
            if ok then
                wk.add({
                    { "s", desc = "Flash Jump", mode = { "n", "x", "o" } },
                    { "S", desc = "Flash Treesitter", mode = { "n", "x", "o" } },
                })
            end
        end,
    },

  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim"
    },
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      ---@diagnostic disable-next-line: undefined-field
      { "<leader>st", function() require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME", "BUG", "FIXIT", "HACK", "WARN", "ISSUE"  } }) end, desc = "[TODO] Pick todos (without NOTE)", },
      ---@diagnostic disable-next-line: undefined-field
      { "<leader>sT", function() require("snacks").picker.todo_comments() end, desc = "[TODO] Pick todos (with NOTE)", },
    },
    config = true,
  },
-- {
--     "kylechui/nvim-surround",
--     version = "*",
--     event = "VeryLazy",
--     opts = {},
-- },
{
    "echasnovski/mini.surround",
    version = "*",
    event = "BufReadPost",
    opts = {
        -- 使用 gs 前缀避免与原生 s 冲突
        mappings = {
            add = "gsa",            -- 添加包围符号
            delete = "gsd",         -- 删除包围符号
            find = "gsf",           -- 查找包围符号
            find_left = "gsF",      -- 向左查找包围符号
            highlight = "gsh",      -- 高亮包围符号
            replace = "gsr",        -- 替换包围符号
            update_n_lines = "gsn", -- 更新搜索行数 （默认只能搜索20行的对应符号，如果要增大范围，先运行 gsn100<CR> 表示搜索100行）
        },
    },
    config = function(_, opts)
        require("mini.surround").setup(opts)
        
        -- 注册到 which-key
        local ok, wk = pcall(require, "which-key")
        if ok then
            wk.add({
                { "gs", group = "Surround", icon = "󰅪" },
                { "gsa", desc = "Add surrounding", mode = { "n", "v" } },
                { "gsd", desc = "Delete surrounding" },
                { "gsf", desc = "Find surrounding (right)" },
                { "gsF", desc = "Find surrounding (left)" },
                { "gsh", desc = "Highlight surrounding" },
                { "gsr", desc = "Replace surrounding" },
                { "gsn", desc = "Update n_lines" },
            })
        end
    end,
},

--   {
--     -- Extend `a`/`i` textobjects
--     "echasnovski/mini.ai",
--     version = "*",
--     event = "BufReadPost",
--     config = true,
--   },

  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "BufReadPost",
    keys = {
      -- Append/insert for each line of visual selections. Similar to block selection insertion.
      {"mI", function() require("multicursor-nvim").insertVisual() end, mode = "x", desc = "Insert cursors at visual selection"},
      {"mA", function() require("multicursor-nvim").appendVisual() end, mode = "x", desc = "Append cursors at visual selection"},
    },
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      -- Mappings defined in a keymap layer only apply when there are multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          mc.clearCursors()
        end)
      end)

    end,
  },

--   { "wakatime/vim-wakatime", lazy = false },
}