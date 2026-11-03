# Neovim 配置

面向 Neovim 0.12 稳定版，使用 lazy.nvim 管理插件；`lazy-lock.json` 固定验证过的提交。

## LSP 职责划分

| 位置 / 组件 | 职责 |
| --- | --- |
| `lua/config/servers.lua` | 唯一服务器清单，同时供自动安装和统一启用读取 |
| Mason | 安装服务器、格式化器、lint 和调试工具，不配置客户端 |
| mason-lspconfig | 将服务器名映射到 Mason 包并确保安装；`automatic_enable = false` |
| nvim-lspconfig | 提供上游默认命令、文件类型、项目根目录检测 |
| `after/lsp/<server>.lua` | 仅声明需要覆盖的设置，不调用 setup 或 enable |
| `lua/plugins/lsp.lua` | 补全 capabilities、诊断、LspAttach 快捷键；最后统一调用一次 `vim.lsp.enable()` |
| `lua/plugins/lang/<language>.lua` | 语言相关解析器、格式化、lint、调试，不启动 LSP |

例如增加 TypeScript 支持：

1. 在 `lua/config/servers.lua` 加入 `"ts_ls"`。Mason 安装和原生启用自动读取同一份清单。
2. 需要覆盖服务器设置时，新建 `after/lsp/ts_ls.lua`，返回配置表；没有差异时不建文件。
3. 需要解析器、formatter 或 DAP 时，在语言模块添加相应配置。

不要在语言插件的 `opts` 回调里执行 `vim.lsp.config/enable`，也不要重新打开 Mason 自动启用。
原生启用会根据文件类型和项目根目录按需启动进程，并非启动编辑器时运行所有服务器。
系统已有的 LSP 不需要再次配置路径；Mason 将其安装目录加入 PATH。
Python 使用 ty 提供类型/补全，Ruff 通过 nvim-lint 和 Conform 提供 lint/格式化，避免重复诊断。

## Treesitter 与 UI

使用 nvim-treesitter `main` API：安装器处理解析器，`FileType` 事件调用原生
`vim.treesitter.start()`，缩进使用新的 `indentexpr()`。语言模块中的
`ensure_installed` 是本配置自有的安装清单，不传入上游 `setup()`。
更新插件时 `:TSUpdate` 同步解析器。需要 tree-sitter-cli >= 0.26.1、C 编译器、curl 和 tar。

Noice 管理命令行、hover 和签名帮助；Fidget 显示 LSP / CodeCompanion 进度；
Snacks 管理普通通知。Python DAP 使用 Mason 的独立 debugpy 环境，项目依赖仍由项目环境管理。

## 更新与检查

- `:Lazy update`：按声明的分支或稳定标签更新所有插件，并更新锁文件。
- `:TSUpdate`：更新已安装解析器。
- `:checkhealth lazy nvim-treesitter vim.lsp blink.cmp`：检查运行环境和 LSP。
- `:Mason`：管理外部工具；工具版本独立于插件锁文件。
- `:Lazy restore`：恢复到当前锁文件记录的插件提交。

2026-11-01 已检查 Neovim 官方发布和 Fedora 仓库，0.12.6 为当前稳定版本；
全部 54 个锁定插件已检查更新，Treesitter 从旧 master 迁移至 main。
升级前配置和插件提交记录备份在 `~/.local/state/nvim-upgrade-20261101/`。
