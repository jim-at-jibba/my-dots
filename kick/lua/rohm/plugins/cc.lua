return {
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    config = true,
    opts = { terminal_cmd = '~/.claude/local/claude' },
    keys = {
      { '<leader>a', nil, desc = 'AI/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
      {
        '<leader>as',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil' },
      },
      -- Diff management
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
  },
  {
    'pittcat/claude-fzf.nvim',
    dependencies = {
      'ibhagwan/fzf-lua',
      'coder/claudecode.nvim',
    },
    opts = {
      auto_context = true,
      batch_size = 10,
    },
    cmd = { 'ClaudeFzf', 'ClaudeFzfFiles', 'ClaudeFzfGrep', 'ClaudeFzfBuffers', 'ClaudeFzfGitFiles' },
    keys = {
      { '<leader>cf', '<cmd>ClaudeFzfFiles<cr>', desc = 'Claude: Add files' },
      { '<leader>cg', '<cmd>ClaudeFzfGrep<cr>', desc = 'Claude: Search and add' },
      { '<leader>cb', '<cmd>ClaudeFzfBuffers<cr>', desc = 'Claude: Add buffers' },
      { '<leader>cgf', '<cmd>ClaudeFzfGitFiles<cr>', desc = 'Claude: Add Git files' },
    },
  },
}
