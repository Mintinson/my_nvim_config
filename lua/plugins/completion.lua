return {{
    'saghen/blink.cmp',
    event = {'BufReadPost', 'BufNewFile'},
    -- optional: provides snippets for the snippet source
    dependencies = { -- 'rafamadriz/friendly-snippets'
    {
        "xzbdmw/colorful-menu.nvim",
        opts = {}
    }, "nvim-tree/nvim-web-devicons", "onsails/lspkind.nvim", "fang2hou/blink-copilot"},

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
            preset = 'default',
            ['<C-u>'] = {"scroll_documentation_up", 'fallback'},
            ['<C-d>'] = {"scroll_documentation_down", 'fallback'}
        },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono'
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            documentation = {
                auto_show = true
            },
            -- menu 配置应该在 completion 内部
            menu = {
                draw = {
                    columns = {{"kind_icon"}, {
                        "label",
                        gap = 1
                    }},
                    components = {
                        label = {
                            width = { fill = true, max = 60 },
                            text = function(ctx)
                                return require('colorful-menu').blink_components_text(ctx)
                            end,
                            highlight = function(ctx)
                                return require('colorful-menu').blink_components_highlight(ctx)
                            end
                        }
                    }
                }
            }
        },

        cmdline = {
            completion = {
                menu = {
                    auto_show = true
                }
            }
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            -- default = { 'lsp', 'path', 'snippets', 'buffer' },
            default = function()
                local success, node = pcall(vim.treesitter.get_node)
                if success and node and vim.tbl_contains({"comment", "line_comment", "block_comment"}, node:type()) then
                    return {"buffer"}
                else
                    return {"copilot", "lsp", "path", "snippets", "buffer"}
                end
            end,

            -- 所有 provider 配置都应该在 providers 内部
            providers = {
                -- lazydev = {
                --     name = "LazyDev",
                --     module = "lazydev.integrations.blink",
                --     -- make lazydev completions top priority (see `:h blink.cmp`)
                --     score_offset = 95
                -- },
                copilot = {
                    name = "copilot",
                    module = "blink-copilot",
                    score_offset = 100,
                    async = true,
                    opts = {
                        kind_icon = "",
                        kind_hl = "DevIconCopilot"
                    }
                },
                path = {
                    score_offset = 95,
                    opts = {
                        get_cwd = function(_)
                            return vim.fn.getcwd()
                        end
                    }
                },
                buffer = {
                    score_offset = 20
                },
                lsp = {
                    -- Filter text items from the LSP provider, since we have the buffer provider for that
                    transform_items = function(_, items)
                        return vim.tbl_filter(function(item)
                            return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
                        end, items)
                    end,
                    score_offset = 60,
                    fallbacks = {"buffer"}
                },
                -- Hide snippets after trigger character
                snippets = {
                    score_offset = 70,
                    should_show_items = function(ctx)
                        return ctx.trigger.initial_kind ~= "trigger_character"
                    end,
                    fallbacks = {"buffer"}
                }
            }
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = {
            implementation = "prefer_rust_with_warning"
        }
    },
    opts_extend = {"sources.default"}
}}
