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
end, { noremap = true, silent = true , desc = "Code Action" })