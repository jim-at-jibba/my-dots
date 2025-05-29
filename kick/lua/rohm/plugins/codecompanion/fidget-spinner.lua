local M = {}

local progress = require 'fidget.progress'
local handle = nil

function M:init()
  local group = vim.api.nvim_create_augroup('CodeCompanionFidgetHooks', {})

  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequest*',
    group = group,
    callback = function(request)
      if request.match == 'CodeCompanionRequestStarted' then
        handle = progress.handle.create {
          title = ' Requesting assistance',
          lsp_client = { name = 'CodeCompanion' },
        }
      elseif request.match == 'CodeCompanionRequestFinished' then
        if handle then
          handle:finish()
        end
      end
    end,
  })
end

return M
