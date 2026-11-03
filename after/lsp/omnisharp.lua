-- Server-specific overrides; defaults come from nvim-lspconfig.
return {
    settings = {
        FormattingOptions = {
            EnableEditorConfigSupport = true, -- 支持 .editorconfig
            OrganizeImports = true,           -- 自动整理 using
        },
        MsBuild = {
            LoadProjectsOnDemand = false, -- 启动时加载所有项目
        },
        RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,           -- 启用 Roslyn 分析器
            EnableImportCompletion = true,           -- 启用导入补全
            AnalyzeOpenDocumentsOnly = true,         -- 只分析打开的文档（提升性能）
            EnableDecompilationSupport = true,       -- 启用反编译支持
            InlayHintsOptions = {
                EnableForParameters = true,          -- 参数名提示
                ForLiteralParameters = true,         -- 字面量参数提示
                ForIndexerParameters = true,         -- 索引器参数提示
                EnableForTypes = true,               -- 类型提示
                ForImplicitVariableTypes = true,     -- var 类型提示
                ForLambdaParameterTypes = true,      -- Lambda 参数类型提示
                ForImplicitObjectCreation = true,    -- new() 类型提示
            },
        },
        Sdk = {
            IncludePrereleases = false, -- 不包含预览版 SDK
        },
    },
}
