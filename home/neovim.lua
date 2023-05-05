-- -------
-- Library
-- -------
local wk = require('which-key');
function map(mode, shortcut, command)
    vim.api.nvim_set_keymap(mode, shortcut, command, {
        noremap = true,
        silent = true
    })
end
function nmap(shortcut, command)
    map('n', shortcut, command)
end
function imap(shortcut, command)
    map('i', shortcut, command)
end

wkmap = function(opts, mappings)
    wk.register(mappings, opts)
end

wk_nmap = function(mappings)
    wkmap({
        mode = 'n'
    }, mappings)
end
wk_imap = function(mappings)
    wkmap({
        mode = 'i'
    }, mappings)
end

-- ------
-- Config
-- ------

-- nmap('<c-s>', ':w<cr>')
wk_nmap({
    ["<leader>"] = {
        s = {":w<cr>", "save file"}
    }
})
vim.cmd([[
set nobackup
set number
set termguicolors " 24-bit colors
colorscheme gruvbox
]])

-- I don't care about tabs.
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

