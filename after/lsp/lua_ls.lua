-- Server-specific overrides; defaults come from nvim-lspconfig.
return {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- 如果需要，可以添加更多库路径
                },
            },
            completion = {
                callSnippet = "Replace",
            },
            hint = {
                enable = true,
                setType = true,
                paramType = true,
                paramName = "Literal",
                semicolon = "Disable",
                arrayIndex = "Disable",
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
