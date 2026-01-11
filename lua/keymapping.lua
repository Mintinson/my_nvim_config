vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-l>", "<Right>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Win+hjkl 用于窗口跳转（统一快捷键，终端和代码编辑都可用）
vim.keymap.set("n", "<D-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<D-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<D-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<D-l>", "<C-w>l", { desc = "Go to right window" })

vim.keymap.set("n", "<A-z>", "<CMD>set wrap!<CR>", { desc = "Toggle line wrap" })

-- 查看当前 buffer 的 LSP 客户端信息
vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "[LSP] Info" })

-- 查看 LSP 日志
vim.keymap.set("n", "<leader>ll", "<cmd>lua vim.cmd('e ' .. vim.lsp.get_log_path())<cr>", { desc = "[LSP] Log" })

-- LSP 代码操作
vim.keymap.set({ "n", "x" }, "<leader>ca", function()
	require("tiny-code-action").code_action()
end, { noremap = true, silent = true, desc = "Code Action" })

-- 移动当前行（Normal 模式）
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move line up" })

-- 移动选中行（Visual 模式）
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- -- 鼠标滚轮速度调节（每次滚动 1 行，默认是 3 行）
vim.keymap.set({ "n", "v", "i" }, "<ScrollWheelUp>", "<C-y>", { desc = "Scroll up 1 line" })
vim.keymap.set({ "n", "v", "i" }, "<ScrollWheelDown>", "<C-e>", { desc = "Scroll down 1 line" })

-- 每次滚动 2 行（介于默认 3 行和 1 行之间）
-- vim.keymap.set({ "n", "v", "i" }, "<ScrollWheelUp>", "<C-y><C-y>", { desc = "Scroll up 2 lines" })
-- vim.keymap.set({ "n", "v", "i" }, "<ScrollWheelDown>", "<C-e><C-e>", { desc = "Scroll down 2 lines" })
