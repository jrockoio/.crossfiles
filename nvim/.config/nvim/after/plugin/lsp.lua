-- lsp installer
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "gopls", "tsserver" },
	automatic_installation = true
})
require("nvim-lsp-installer").setup {}

local null_ls = require("null-ls")
require("null-ls").setup({
	sources = {
		null_ls.builtins.code_actions.shellcheck,
		null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.diagnostics.golangci_lint.with({
        diagnostics_format = "#{m} (#{s})",
    }),
		null_ls.builtins.formatting.prettierd.with({
			condition = function(utils)
				return utils.has_file({ ".prettierrc" })
			end,
		}),
		null_ls.builtins.diagnostics.actionlint,
    null_ls.builtins.diagnostics.misspell,
	},
	debug = true
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	local single_jump = { jump_to_single_result = true }
	--vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gD', function() require('fzf-lua').lsp_declarations(single_jump) end, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	--vim.keymap.set('n', 'gd', function() require('fzf-lua').lsp_definitions(single_jump) end, bufopts)
	vim.keymap.set('n', 'gh', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, bufopts)
	vim.keymap.set('n', 'gi', function() require('fzf-lua').lsp_implementations(single_jump) end, bufopts)
	vim.keymap.set('n', '<leader>fd', require('fzf-lua').lsp_document_diagnostics, bufopts)
	vim.keymap.set('n', '<leader>wd', require('fzf-lua').lsp_workspace_diagnostics, bufopts)
	vim.keymap.set('n', '<leader>fs', require('fzf-lua').lsp_document_symbols, bufopts)
	vim.keymap.set('n', '<leader>ws', require('fzf-lua').lsp_live_workspace_symbols, bufopts)
	vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('i', '<C-c>', vim.lsp.buf.completion, bufopts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, bufopts)
	vim.keymap.set('n', '<leader>?', require('fzf-lua').keymaps, bufopts)
	if client.name == "gopls" then
		vim.keymap.set('n', '<C-c>', '<esc>:GoFillStruct<cr>', bufopts)
		vim.keymap.set('i', '<C-c>', '<esc>:GoFillStruct<cr>', bufopts)
	end
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = require('lspconfig')
local servers = { 'ccls', 'rust_analyzer', 'pyright', 'terraformls', 'tailwindcss', 'eslint' , 'jsonls'}
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
end

require("typescript").setup({
	server = { -- pass options to lspconfig's setup method
		on_attach = on_attach,
		capabilities = capabilities,
	},
})

lspconfig.gopls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				composites = false
			},
			staticcheck = true,
			buildFlags =  {"-tags=int"}
		}
	}
}

lspconfig.lua_ls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			format = {
				enable = true,
				defaultConfig = {
					indent_style = "tab"
				}
			},
			diagnostics = {
				globals = { 'vim', 'require', 'client', 'awesome', 'screen', 'tag' }
			},
			telemetry = {
				enable = false,
			}
		}
	}
}

lspconfig.yamlls.setup {
	settings = {
		yaml = {
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
			},
		},
	}
}

capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.cssls.setup {
	capabilities = capabilities,
}
lspconfig.jsonls.setup{
	capabilities = capabilities,
}
