return {{
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = {
            enabled = true
        },
        dashboard = {
            enabled = true
        },
        explorer = {
            enabled = false
        },
        image = {
            enabled = true,
            doc = {
                inline = false,
                float = false,
                max_width = 80,
                max_height = 40
            },
            math = {
                latex = {
                    font_size = "small"
                }
            }
        },
        indent = {
            enabled = true,
            animate = {
                enabled = true
            },
            indent = {
                only_scope = true
            },
            scope = {
                enabled = true, -- enable highlighting the current scope
                underline = true -- underline the start of the scope
            },
            chunk = {
                -- when enabled, scopes will be rendered as chunks, except for the top-level scope which will be rendered as a scope.
                enabled = true
            }
        },
        input = {
            enabled = true
        },
        picker = {
            enabled = true
        },
        notifier = {
            enabled = true,
            style = "notification"
        },
        quickfile = {
            enabled = true
        },
        scope = {
            enabled = true
        },
        scroll = {
            enabled = true
        },
        statuscolumn = {
            enabled = true
        },
        words = {
            enabled = true
        }
    }
}}
