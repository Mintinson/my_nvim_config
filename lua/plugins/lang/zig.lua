-- Zig language configuration
-- This file contains all Zig-specific plugins and configurations

return {
  -- Treesitter: syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "zig" },
    },
    opts_extend = { "ensure_installed" },
  },

  -- Mason-lspconfig: install LSP servers
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "zls", -- Zig Language Server
      },
    },
    opts_extend = { "ensure_installed" },
  },

  -- Conform: formatting (zls has built-in formatter)
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        zig = { "zls" },
      },
    },
  },
}
