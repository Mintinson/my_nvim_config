-- Server-specific overrides; defaults come from nvim-lspconfig.
return {
    settings = {
        zls = {
            enable_snippets = true,
            enable_argument_placeholders = true,
            enable_ast_check_diagnostics = true,
            enable_autofix = true,
            enable_import_embedfile_argument_completions = true,
            warn_style = true,
            enable_semantic_tokens = true,
            enable_inlay_hints = true,
            inlay_hints_show_builtin = true,
            inlay_hints_exclude_single_argument = true,
            inlay_hints_hide_redundant_param_names = false,
            inlay_hints_hide_redundant_param_names_last_token = false,
            operator_completions = true,
            include_imports = true,
        },
    },
}
