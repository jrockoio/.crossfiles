-- Run gofmt + goimport on save
--
-- vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent !lua require('go.format').goimport()<CR> ]], false)

-- local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.go",
--   callback = function()
--    require('go.format').goimports()
--   end,
--   group = format_sync_grp,
-- })

require("go").setup()

--vim.api.nvim_exec([[ autocmd FileType go nnoremap <buffer> <leader>tf :GoTestFunc -F <CR> ]], false)
--vim.api.nvim_exec([[ autocmd FileType go nnoremap <buffer> <leader>tc :lua require"go.term".close() <CR> ]], false)
