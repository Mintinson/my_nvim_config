local M = {}

function M.setup()
    -- ========================================================================
    -- Yank 后显示通知
    -- ========================================================================
    -- vim.api.nvim_create_autocmd("TextYankPost", {
    --     group = vim.api.nvim_create_augroup("YankNotify", { clear = true }),
    --     callback = function()
    --         local event = vim.v.event
    --         if event.operator ~= "y" then
    --             return
    --         end

    --         local lines = #event.regcontents
    --         local chars = 0
    --         for _, line in ipairs(event.regcontents) do
    --             chars = chars + #line
    --         end

    --         local msg = lines == 1
    --             and string.format("Yanked %d chars", chars)
    --             or string.format("Yanked %d lines (%d chars)", lines, chars)

    --         vim.notify(msg, vim.log.levels.INFO, { title = "Yank" })
    --     end,
    -- })

    -- ========================================================================
    -- 打开文件时恢复光标位置
    -- ========================================================================
    vim.api.nvim_create_autocmd("BufReadPost", {
        group = vim.api.nvim_create_augroup("RestoreCursor", { clear = true }),
        callback = function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local line_count = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= line_count then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end,
    })

    -- ========================================================================
    -- 退出时确认保存（类似 LazyVim）
    -- ========================================================================
    vim.api.nvim_create_autocmd("QuitPre", {
        group = vim.api.nvim_create_augroup("ConfirmQuit", { clear = true }),
        callback = function()
            -- 获取所有未保存的 buffer
            local unsaved = {}
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) 
                    and vim.bo[buf].modified 
                    and vim.bo[buf].buftype == "" 
                    and vim.api.nvim_buf_get_name(buf) ~= "" then
                    table.insert(unsaved, {
                        buf = buf,
                        name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t"),
                    })
                end
            end

            if #unsaved == 0 then
                return
            end

            -- 构建文件列表
            local file_list = {}
            for _, f in ipairs(unsaved) do
                table.insert(file_list, "  • " .. f.name)
            end

            -- 使用 vim.ui.select 显示选项
            local choices = {
                "Save All and Quit",
                "Discard All and Quit", 
                "Cancel",
            }

            vim.ui.select(choices, {
                prompt = "Unsaved changes in:\n" .. table.concat(file_list, "\n") .. "\n\nWhat would you like to do?",
            }, function(choice)
                if choice == "Save All and Quit" then
                    vim.cmd("wall")  -- 保存所有
                    vim.cmd("qa")    -- 退出
                elseif choice == "Discard All and Quit" then
                    vim.cmd("qa!")   -- 强制退出
                end
                -- Cancel 或 nil：什么都不做，阻止退出
            end)

            -- 阻止默认退出行为，让用户选择
            vim.cmd("throw 'QuitPre handled'")
        end,
    })
end

return M