-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


vim.g.mapleader = " "

local plugins = {}

if vim.env.COPILOT == '1' then
  table.insert(plugins, 'github/copilot.vim')
  table.insert(plugins, {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
    },
    opts = {
      -- model = "gpt-4o",
      -- debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  })
end

table.insert(plugins, {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'nvimtools/none-ls.nvim',
      'pmizio/typescript-tools.nvim',
      'nvim-lua/plenary.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      require('dacfg.lsp')
    end,
  },

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    lazy = false,
    config = function()
      require("nvim-treesitter.install").prefer_git = true
      require 'nvim-treesitter.configs'.setup {
        -- for windwp/nvim-ts-autotag
        autotag = {
          enable = true,
        },

        -- for Comment.nvim
        context_commentstring = {
          config = {
            javascript = {
              __default = '// %s',
              jsx_element = '{/* %s */}',
              jsx_fragment = '{/* %s */}',
              jsx_attribute = '// %s',
              comment = '// %s',
            },
            typescript = { __default = '// %s', __multiline = '/* %s */' },
          },
        },

        -- A list of parser names, or "all"
        ensure_installed = {
          "go",
          "lua",
          "html",
          "json",
          "bash",
          "css",
          "javascript",
          "typescript",
          "tsx",
          "java",
          "markdown",
          "toml",
          "python",
          "yaml",
        },

        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          disable = function(_, bufnr)
            local uv = vim.uv or vim.loop
            local ok, stats = pcall(uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
            return ok and stats and stats.size > 200 * 1024
          end,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        }
      }
    end,
  },

  -- completion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Autocompletion
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      -- Snippets
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      require('dacfg.completion')
    end,
  },

  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
  },

  -- movement
  { 'takac/vim-hardtime', cmd = { 'HardTimeToggle', 'HardTimeOn', 'HardTimeOff' } },
  {
    'jinh0/eyeliner.nvim',
    event = 'VeryLazy',
    config = function()
      require 'eyeliner'.setup {
        highlight_on_key = true, -- show highlights only after keypress
        dim = true
      }
    end
  },
  {
    'ThePrimeagen/harpoon',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = { '<leader>a', '<C-e>', '<C-j>', '<C-k>', '<C-l>', '<C-;>' },
    config = function()
      require('dacfg.harpoon')
    end,
  },

  -- lint
  { 'mfussenegger/nvim-lint', event = 'BufReadPost' },

  --caddyfile
  { 'isobit/vim-caddyfile', ft = 'caddy' },

  -- find/replace
  {
    'nvim-pack/nvim-spectre',
    dependencies = 'nvim-lua/plenary.nvim',
    lazy = true,
  },

  --grepper
  { 'mhinz/vim-grepper', cmd = 'Grepper' },

  -- fzf
  {
    'ibhagwan/fzf-lua',
    lazy = true,
    dependencies = { 'kyazdani42/nvim-web-devicons' }, -- optional for icon support
    config = function()
      require('dacfg.fzf')
    end,
  },

  -- debugging
  { 'mfussenegger/nvim-dap', lazy = true },
  { 'leoluz/nvim-dap-go', ft = 'go' },

  -- lf
  { 'VebbNix/lf-vim', cmd = 'Lf' },
  { 'ptzz/lf.vim', cmd = { 'Lf', 'LfCurrentFile' } },
  { 'voldikss/vim-floaterm', cmd = { 'FloatermNew', 'FloatermToggle', 'FloatermKill' } },

  -- git
  'airblade/vim-gitgutter',
  -- open in github
  {
    'ruifm/gitlinker.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    lazy = true,
    keys = { { '<leader>og', mode = { 'n', 'v' } } },
    config = function()
      require('dacfg.gitlinker')
    end,
  },

  { 'akinsho/git-conflict.nvim', version = "*", config = true, event = 'BufReadPost' },

  --editorconfig
  -- 'editorconfig/editorconfig-vim',

  -- auto-commenting
  { 'numToStr/Comment.nvim',     lazy = false },
  'JoosepAlviste/nvim-ts-context-commentstring',

  -- surround
  { 'kylechui/nvim-surround', event = 'VeryLazy', opts = {} },
  -- auto close brackets
  { 'rstacruz/vim-closer', event = 'InsertEnter' },
  -- auto end functions
  { 'tpope/vim-endwise', event = 'InsertEnter' },
  -- auto close html tags
  'windwp/nvim-ts-autotag',
  -- split/join
  { 'AndrewRadev/splitjoin.vim', keys = { 'gS', 'gJ' } },

  -- typescript
  {
    "pmizio/typescript-tools.nvim",
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- go
  -- {
  --   "ray-x/go.nvim",
  --   dependencies = { -- optional packages
  --     "ray-x/guihua.lua",
  --     -- "neovim/nvim-lspconfig",
  --   },
  --   -- config = function()
  --   --   require("go").setup({
  --   --     -- disable_defaults = true,
  --   --     verbose_tests = true,
  --   --     -- this doesn't work
  --   --     --lsp_cfg = {settings={gopls={analyses={composites= false }}}}
  --   --   })
  --   -- end,
  --   event = { "CmdlineEnter" },
  --   ft = { "go", 'gomod' },
  --   build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  -- },
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- lsp_keymaps = false,
      -- other options
    },
    config = function(lp, opts)
      require("go").setup(opts)
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require('go.format').goimports()
        end,
        group = format_sync_grp,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  -- java
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java', 'drools' },
  },
  { 'WhoIsSethDaniel/mason-tool-installer.nvim', lazy = true },

  -- nvim-test
  {
    "klen/nvim-test",
    cmd = { "TestNearest", "TestFile", "TestLast", "TestVisit" },
    config = function()
      require('nvim-test.runners.go-test'):setup { command = 'richgo' }
      require('nvim-test').setup()
    end,
  },

  -- lualine
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
      'kyazdani42/nvim-web-devicons',
      'f-person/git-blame.nvim',
      'f-person/lua-timeago',
    },
    config = function()
      require('dacfg.lualine')
    end,
  },

  -- tf syntax
  { 'hashivim/vim-terraform', ft = 'terraform' },
  -- just syntax
  { 'NoahTheDuke/vim-just', ft = 'just' },
  -- drools syntax'
  -- 'vim-scripts/drools.vim',

  -- Color scheme
  { 'dikiaap/minimalist', lazy = true },
  { 'morhetz/gruvbox', lazy = true },
  { 'folke/tokyonight.nvim', lazy = true },

})

require('lazy').setup(plugins, {
  performance = {
    rtp = {
      disabled_plugins = { 'tohtml', 'tutor' },
    },
  },
})
