return {
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
        { "<leader>qs", function() require("persistence").load() end, desc = "[Session] Restore Session" },
        { "<leader>qS", function() require("persistence").select() end, desc = "[Session] Select Session" },
        { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "[Session] Restore Last Session" },
        { "<leader>qd", function() require("persistence").stop() end, desc = "[Session] Don't Save Current Session" },
    },
},
}