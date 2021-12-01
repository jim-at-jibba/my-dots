-- async formatting
-- https://www.reddit.com/r/neovim/comments/jvisg5/lets_talk_formatting_again/
-- vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
--     if err ~= nil or result == nil then
--         return
--     end
--     if not vim.api.nvim_buf_get_option(bufnr, "modified") then
--         local view = vim.fn.winsaveview()
--         vim.lsp.util.apply_text_edits(result, bufnr)
--         vim.fn.winrestview(view)
--         vim.api.nvim_command("noautocmd :update")
--     end
-- end

vim.lsp.handlers["textDocument/formatting"] = function(err, result, ctx)
    if err ~= nil or result == nil then
        return
    end
    if
        vim.api.nvim_buf_get_var(ctx.bufnr, "init_changedtick") == vim.api.nvim_buf_get_var(ctx.bufnr, "changedtick")
    then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, ctx.bufnr)
        vim.fn.winrestview(view)
        if ctx.bufnr == vim.api.nvim_get_current_buf() then
            vim.b.saving_format = true
            vim.cmd [[update]]
            vim.b.saving_format = false
        end
    end
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
    vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
            virtual_text = false,
            signs = true,
            underline = true,
            update_in_insert = false
        }
    )(...)
end

