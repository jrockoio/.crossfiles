require('dacfg.plugins')

if vim.env.COPILOT == '1' then
  require('dacfg.config.copilot')
end

vim.g.gitblame_date_format = '%r'

vim.o.winbar = "%=%m %f"
vim.o.ch = 0

vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.swapfile = false
vim.opt.colorcolumn = "100,110"
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.inccommand = "nosplit"

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.smartindent = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- floatterm
vim.g.floaterm_width = .95
vim.g.floaterm_height = .8

-- Comment.nvim
require('Comment').setup({
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

local ft = require('Comment.ft')
ft.drools = { '//%s', '/*%s*/' }

-- {{{ colorscheme
--local colorscheme = "gruvbox"
--local colorscheme = "tokyonight-night"
-- local colorscheme = "tokyonight-day"
--local colorscheme = "tokyonight-moon"
local colorscheme = "tokyonight-storm"

local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not ok then
  vim.cmd('colorscheme default')
end
-- }}}

-- lf.vim
--vim.g.lf_command_override = 'lfub'

-- hardtime
--vim.g.hardtime_default_on = 1


vim.cmd('filetype plugin on')


require("nvim-surround").setup()
require "fidget".setup {}

-- nvim-test
local nvimtest = require("nvim-test")
require('nvim-test.runners.go-test'):setup {
  command = "richgo"
}
nvimtest.setup()
