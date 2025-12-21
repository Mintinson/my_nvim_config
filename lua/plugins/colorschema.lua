return {{
    "Shatur/neovim-ayu",
    name = "ayu",
    priority = 1000,
    config = function()
        local theme = require("config.theme")
        
        -- Configure ayu theme
        require('ayu').setup({
            mirage = true,  -- Set to true for ayu-mirage
            terminal = true, -- Set terminal colors
            overrides = {},  -- Custom color overrides if needed
            
        })
        
        -- Apply the colorscheme
        vim.cmd.colorscheme(theme.name)
        
        -- Apply custom highlights using our theme abstraction layer
        local colors = theme.colors
        
        -- stylua: ignore
        local highlights = {
            LineNr = { fg = colors.line_nr },
            Visual = { bg = colors.visual },
            Search = { bg = colors.search },
            IncSearch = { bg = colors.warning, fg = colors.bg },
            CurSearch = { bg = colors.warning, fg = colors.bg },
            MatchParen = { bg = colors.match_paren, fg = colors.fg, bold = true },
        }
        
        -- Apply highlights
        for group, settings in pairs(highlights) do
            vim.api.nvim_set_hl(0, group, settings)
        end
    end
}}
