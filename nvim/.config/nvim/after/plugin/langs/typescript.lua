--local autogroup_ts_lsp = vim.api.nvim_create_augroup("ts_lsp", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.tsx", "*.ts" },
	callback = function()
		require("typescript").actions.addMissingImports()
		--require("typescript").actions.addMissingImports({sync = true})
		--require("typescript").actions.removeUnused()
	end,
	--group = autogroup_ts_lsp,
})
