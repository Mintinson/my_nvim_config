vim.g.loaded_netrw = 1
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

vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.expandtab = true

require("config.lazy")

require("keymapping")
