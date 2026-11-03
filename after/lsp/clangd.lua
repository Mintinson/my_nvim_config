-- Server-specific overrides; defaults come from nvim-lspconfig.
return {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--header-insertion-decorators",
        "--completion-style=detailed",
        "--function-arg-placeholders=0",
        "--experimental-modules-support",
    },
    init_options = {
        clangdFileStatus = true,
        usePlaceholders = true,
        completeUnimported = true,
        semanticHighlighting = true,
        fallbackFlags = { "-std=c++20" },
    },
}
