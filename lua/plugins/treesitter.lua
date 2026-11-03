return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        -- This list belongs to our installer, not upstream setup().
        opts = {
            ensure_installed = {
                "c", "lua", "vim", "vimdoc", "query", "elixir", "heex",
                "javascript", "html", "markdown", "markdown_inline", "json", "bash",
            },
        },
        opts_extend = { "ensure_installed" },
        config = function(_, opts)
            local ts = require("nvim-treesitter")
            ts.setup({})
            ts.install(vim.fn.uniq(vim.fn.sort(vim.deepcopy(opts.ensure_installed))), { max_jobs = 4 })
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
                callback = function(event)
                    if vim.bo[event.buf].buftype ~= "" or vim.b[event.buf].snacks_bigfile then
                        return
                    end
                    -- Unsupported filetypes keep their native syntax and indentation.
                    if pcall(vim.treesitter.start, event.buf) then
                        vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
}
