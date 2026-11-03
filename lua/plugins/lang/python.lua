-- ============================================================================
-- Python 语言配置
-- 工具、格式化和调试；LSP 差异配置见 after/lsp/，启用清单见 config/servers.lua
-- ============================================================================

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
        "mason-org/mason.nvim",
        optional = true,
        opts = {
            ensure_installed = {
                "ruff",
                "debugpy",
            },
        },
        opts_extend = { "ensure_installed" },
    },

    -- Conform: formatting
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                python = { "ruff_organize_imports", "ruff_format" },
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

    -- Python environment selector
    {
        "linux-cultist/venv-selector.nvim",
        branch = "main",
        cmd = "VenvSelect",
        ft = "python",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        opts = {
            settings = {
                options = {
                    notify_user_on_venv_activation = true,
                },
            },
        },
        keys = {
            { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Python Virtual Env", ft = "python" },
        },
    },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")

      -- See `https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation`
      dap.adapters.python = function(cb, config)
        if config.request == "attach" then
          ---@diagnostic disable-next-line: undefined-field
          local port = (config.connect or config).port
          ---@diagnostic disable-next-line: undefined-field
          local host = (config.connect or config).host or "127.0.0.1"
          cb({
            type = "server",
            port = assert(port, "`connect.port` is required for a python `attach` configuration"),
            host = host,
            options = {
              source_filetype = "python",
            },
          })
        else
          cb({
            type = "executable",
            command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
            args = { "-m", "debugpy.adapter" },
            options = {
              source_filetype = "python",
            },
          })
        end
      end

      dap.configurations.python = {
        {
          -- The first three options are required by nvim-dap
          type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = "launch",
          name = "[Python] Launch file",

          -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
          program = "${file}", -- This configuration will launch the current file if used.
          -- You can also dynamically get arguments, e.g., from user input:
          args = function()
            local args_str = vim.fn.input("Commandline args: ")
            return vim.split(args_str, " ", { plain = true })
          end,
        },
      }
    end,
  },
}
