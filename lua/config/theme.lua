-- Theme abstraction layer for easy theme switching
local M = {}

-- Ayu dark palette (matching ayu-dark variant)
M.ayu_dark = {
    -- Base colors
    bg = "#0A0E14",
    fg = "#B3B1AD",
    
    -- UI colors
    primary = "#E6B450",
    secondary = "#39BAE6",
    accent = "#FF8F40",
    
    -- Semantic colors
    success = "#C2D94C",
    warning = "#E6B450",
    error = "#F07178",
    info = "#39BAE6",
    hint = "#95E6CB",
    
    -- Syntax colors
    comment = "#5C6773",
    keyword = "#FF8F40",
    string = "#C2D94C",
    function_name = "#FFB454",
    variable = "#FFEE99",
    
    -- UI specific colors
    selection = "#273747",
    search = "#414B5F",
    visual = "#273747",
    cursor_line = "#131721",
    line_nr = "#3E4B59",
    match_paren = "#6C7B8F",
    surface = "#0F131A",
    overlay = "#232834",
    
    -- Status indicator colors (for copilot, etc)
    green = "#C2D94C",
    red = "#F07178",
    peach = "#FF8F40",
    mauve = "#D4BFFF",
}

-- Active theme colors
M.colors = M.ayu_dark

-- Theme metadata
M.name = "ayu-dark"
M.lualine_theme = "ayu"

return M
