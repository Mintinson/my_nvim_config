-- Server-specific overrides; defaults come from nvim-lspconfig.
return {
    settings = {
        haskell = {
            -- 插件配置
            plugin = {
                -- 代码补全
                ["ghcide-completions"] = {
                    config = {
                        autoExtendOn = true, -- 自动扩展语言扩展
                        snippetsOn = true,   -- 启用代码片段
                    },
                },
                -- 类型签名
                ["ghcide-type-lenses"] = {
                    globalOn = true, -- 显示类型透镜
                },
                -- Hlint 集成
                hlint = {
                    globalOn = true, -- 启用 hlint 诊断
                },
                -- 格式化（如果使用 hls 内置格式化）
                fourmolu = {
                    config = {
                        external = true, -- 使用外部 fourmolu
                    },
                },
            },
            -- 格式化提供者
            formattingProvider = "fourmolu",
        },
    },
}
