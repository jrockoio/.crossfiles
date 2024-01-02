local bufopts = { noremap = true, silent = true}
vim.keymap.set('n', '<leader>f', ':%! jq \'.\'<cr>', bufopts)
