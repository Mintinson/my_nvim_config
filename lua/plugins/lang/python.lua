-- Python language configuration
-- This file contains all Python-specific plugins and configurations


return {
  -- Treesitter: syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "python" },
    },
    opts_extend = { "ensure_installed" },
  },

  -- Mason: install formatters/linters
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "ruff",
      },
    },
    opts_extend = { "ensure_installed" },
  },

  -- Mason-lspconfig: install LSP servers
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "ty",
      },
    },
    opts_extend = { "ensure_installed" },
  },

    -- ty LSP 配置（Neovim 0.11+）
    {
        "neovim/nvim-lspconfig",
        optional = true,
        init = function()
            -- 使用 Neovim 0.11+ 的原生 LSP 配置 API
            vim.lsp.config("ty", {
                cmd = { "ty", "server" },
                filetypes = { "python" },
                -- root_markers = {
                --     "ty.toml",
                --     "pyproject.toml",
                --     "setup.py",
                --     "setup.cfg",
                --     "requirements.txt",
                --     ".git",
                -- },
                settings = {
                    -- 根据 https://docs.astral.sh/ty/reference/editor-settings/
                    -- 注意：settings 直接放配置，不需要 "ty" 嵌套
                    
                    -- Python 版本（可选）
                    -- pythonVersion = "3.12",
                    
                    -- Python 平台（可选）
                    -- pythonPlatform = "Linux",

                    -- Inlay hints 配置
                    -- https://docs.astral.sh/ty/reference/editor-settings/#inlayhints
                    inlayHints = {
                        -- 通用开关
                        enable = true,
                        -- 显示参数名提示
                        parameterNames = true,
                        -- 显示变量类型提示
                        variableTypes = true,
                        -- 显示函数返回类型提示
                        functionReturnTypes = true,
                        -- 显示泛型类型参数
                        genericTypes = true,
                    },
                },
            })

            -- 启用 ty LSP
            vim.lsp.enable("ty")
        end,
    },

    

  -- Conform: formatting
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = {"ruff_organize_imports", "ruff_format",  },
      },
    },
  },
  -- Linting
  {
		"mfussenegger/nvim-lint",
        optional = true,
        opts = {
            linters_by_ft = {
                python = { "ruff" },
            },
        },
  },

  -- python environment
  {
    "linux-cultist/venv-selector.nvim",
    branch = "main", -- use the branch for the new version
    cmd = "VenvSelect",
    ft = "python", -- only load on python files (from cache)
    dependencies = {
            "neovim/nvim-lspconfig",
        },
    opts = {
      settings = {
        options = {
            notify_user_on_venv_activation = true,
        }
      },
                  -- 关键：指定支持的 Python LSP 名称
            name = { "ty", "pyright", "pylsp", "basedpyright" },
            -- 或者在新版本中使用：
            -- changed_venv_hooks = { "ty" },
    },
    keys = {{"<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Python Virtual Env", ft = "python"} },
  }

}