
vim.g.loaded_netrw = 1 -- 
vim.g.loaded_netrwPlugin = 1
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.list = true
vim.opt.listchars = {
  tab = "▸ ",
  trail = "·",
  extends = "»",
  precedes = "«",
  nbsp = "␣",
}

vim.opt.ignorecase = true  -- 搜索时忽略大小写 (搜 "abc" 能搜到 "ABC")
vim.opt.smartcase = true   -- 智能大小写 (如果你输入了包含大写字母的 "Abc"，则强制区分大小写；全小写则忽略大小写)
vim.opt.hlsearch = true    -- 高亮搜索结果 (搜索后，所有匹配项变成黄色背景)

vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true -- 新起一行时，自动检测是否需要缩进 (比如在大括号后回车自动缩进)
vim.opt.expandtab = true -- 将 Tab 键转换为空格 (这是重点！按 Tab 不会插入 \t，而是插入空格)
vim.opt.scrolloff = 15     -- 上下滚动余量
vim.opt.sidescrolloff = 10 -- 左右滚动余量 (同上，针对长行左右移动)
vim.opt.startofline = false

-- for code companion
vim.opt.splitbelow = true  -- 新窗口在当前窗口下方打开
vim.opt.splitright = true  -- 新窗口在当前窗口右侧打开

vim.opt.conceallevel = 2  -- for markdown or json

vim.wo.wrap = false     -- 关闭自动换行

vim.g.mapleader = " "       -- 将 Leader 键设置为空格键 (Space)
vim.g.maplocalleader = "\\" -- 将 Local Leader 设置为反斜杠 (\)

require("config.lazy")

require("keymapping")
