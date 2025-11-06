-- lsp installer
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "gopls", "ts_ls" },
  automatic_installation = true
})

require('mason-tool-installer').setup({
  -- Install these linters, formatters, debuggers automatically
  ensure_installed = {
    'java-debug-adapter',
    'java-test',
  },
})

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
  -- debug = true
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  local single_jump = { jump_to_single_result = true }
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

vim.lsp.config("*", {
  capabilities = capabilities,
  on_attach = on_attach,
})

vim.lsp.enable({
  'ccls',
  'rust_analyzer',
  'basedpyright',
  'terraformls',
  'tailwindcss',
  'eslint',
  'jsonls',
  'cucumber_language_server',
})

require("typescript-tools").setup {
  on_attach = on_attach,
  settings = {
    tsserver_plugins = {
      "@styled/typescript-styled-plugin",
    }
  }
}


vim.lsp.config.gopls = {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        composites = false
      },
      staticcheck = true,
      buildFlags = { "-tags=int" }
    }
  }
}
vim.lsp.enable("gopls")

vim.lsp.config.lua_ls = {
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
vim.lsp.enable("lua_ls")

vim.lsp.config.yamlls = {
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://github-pages.cloud.capitalone.com/cyber-sre-automation/BogieValidator/schema/bogiefile.json"] =
        "/Bogiefile",
      },
    },
  }
}
vim.lsp.enable("yamlls")

capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config.cssls = {
  capabilities = capabilities,
}
vim.lsp.enable("cssls")

vim.lsp.config.jsonls = {
  capabilities = capabilities,
}
vim.lsp.enable("jsonls")


return { on_attach = on_attach, capabilities = capabilities }
