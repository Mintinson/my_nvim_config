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

