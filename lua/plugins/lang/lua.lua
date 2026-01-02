-- Lua language configuration
-- This file contains all Lua-specific plugins and configurations

return {
  -- Treesitter: syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "lua", "luadoc", "luap" },
    },
    opts_extend = { "ensure_installed" },
  },

  -- Mason: install formatters/linters
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "stylua",
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
        "lua_ls",
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
        lua = { "stylua" },
      },
    },
  },

  -- LazyDev: better Neovim Lua development experience
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}