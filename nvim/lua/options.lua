local options = {
    tabstop = 2,
    softtabstop = 2,
    shiftwidth = 2,
    expandtab = true,
    smartindent = true,
    hlsearch = true,
    paste = true,
    number = true,
    hidden = true,
    errorbells = true,
    spell = true,
    splitbelow = true,
    splitright = true,
    relativenumber = true,
    nu = true,
    scrolloff = 8,
    completeopt = { "menu", "menuone", "noinsert", "noselect"},
    signcolumn = "yes",
    updatetime = 100,
    timeoutlen = 500,
    incsearch = true,
    showmode = true,
    foldenable = true,
    foldlevel = 99,
    foldmethod = "expr",
    foldexpr = "nvim_treesitter#foldexpr()",
    backup = true,
    writebackup = true,
    swapfile = true,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.opt.shortmess:append("c")
vim.g.vim_json_warnings = false