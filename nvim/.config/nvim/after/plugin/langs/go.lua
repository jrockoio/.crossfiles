require('go').setup({
	disable_defaults = true,
	verbose_tests = true,
	-- this doesn't work
	--lsp_cfg = {settings={gopls={analyses={composites= false }}}}
})

--require('dap-go').setup()

-- Run gofmt + goimport on save
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)
--vim.api.nvim_exec([[ autocmd FileType go nnoremap <buffer> <leader>tf :GoTestFunc -F <CR> ]], false)
--vim.api.nvim_exec([[ autocmd FileType go nnoremap <buffer> <leader>tc :lua require"go.term".close() <CR> ]], false)
