let g:telescope_cache_results = 1
let g:telescope_prime_fuzzy_find  = 1

nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <leader>b :lua require('telescope.builtin').buffers({show_all_buffers = true})<CR>
nnoremap <leader>f :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For >")})<CR>
nnoremap <leader>f :lua require('telescope.builtin').live_grep()<CR>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap <Leader>bc :lua require('telescope.builtin').git_bcommits()<CR>
nnoremap <Leader>g :lua require('telescope.builtin').git_status()<CR>
nnoremap <Leader>cR :lua require('telescope.builtin').reloader()<CR>
nnoremap <Leader>sn :lua require'telescope'.extensions.ultisnips.ultisnips{}<CR>
nnoremap <Leader>ns :Telescope neoclip<CR>

" nnoremap <Leader>ca :lua require('telescope.builtin').lsp_code_actions()<CR>

lua << EOF
local actions = require('telescope.actions')
local trouble = require("trouble.providers.telescope")

require('telescope').setup{
  defaults = {
    -- TEMP FIX: https://github.com/nvim-telescope/telescope.nvim/issues/484
    set_env = { ['COLORTERM'] = 'truecolor' },
    file_sorter = require('telescope.sorters').get_fzy_sorter,
    prompt_prefix = "🦄 ",
    color_devicons = true,

        file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-q>"] = actions.send_to_qflist,
                ["<c-t>"] = trouble.open_with_trouble,
            },
            n = { ["<c-t>"] = trouble.open_with_trouble },
        }
  },
  extensions = {
      fzy_native = {
          override_generic_sorter = false,
          override_file_sorter = true,
      }
  }
}

require('telescope').load_extension('fzy_native')
require('telescope').load_extension('neoclip')
-- require('telescope').load_extension('ultisnips')

EOF
