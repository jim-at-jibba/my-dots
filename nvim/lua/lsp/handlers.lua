-- async formatting
-- https://www.reddit.com/r/neovim/comments/jvisg5/lets_talk_formatting_again/
vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then
        return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        vim.api.nvim_command("noautocmd :update")
    end
end

-- Diagnostics
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--   vim.lsp.diagnostic.on_publish_diagnostics, {
--     virtual_text = true,
--     signs = true,
--     update_in_insert = false,
--   }
-- )

vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
    vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false
        }
    )(...)
    -- pcall(vim.lsp.diagnostic.set_loclist, {open_loclist = false})
end


-- vim.lsp.handlers["textDocument/hover"] =
--     vim.lsp.with(
--     vim.lsp.handlers.hover,
--     {
--         border = vim.g.floating_window_border_dark
--     }
-- )
-- 
-- vim.lsp.handlers["textDocument/signatureHelp"] =
--     vim.lsp.with(
--     vim.lsp.handlers.signature_help,
--     {
--         border = vim.g.floating_window_border_dark
--     }
-- )
