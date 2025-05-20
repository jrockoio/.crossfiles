local opts = { noremap = true, silent = true }

--diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

--fzf
vim.keymap.set('n', '<c-p>', function() require('fzf-lua').files({ fzf_cli_args="-i" }) end, opts)
-- vim.keymap.set('n', '<c-f>', function() require('fzf-lua').live_grep_native({ fzf_cli_args="-i" }) end, opts)
vim.keymap.set('n', '<c-f>', function() require('fzf-lua').live_grep_native() end, opts)
vim.keymap.set('n', '<c-l>', function() require('fzf-lua').live_grep_resume() end, opts)
vim.keymap.set('n', '<leader>k', require('fzf-lua').grep_cword, opts)
vim.keymap.set('n', '<leader>K', require('fzf-lua').grep_cWORD, opts)
vim.keymap.set('v', '<leader>k', require('fzf-lua').grep_visual, opts)

--gitgutter
vim.keymap.set('n', '<leader>d', ":GitGutterPreviewHunk<cr>", opts)
vim.keymap.set('n', '<leader>uh', ":GitGutterUndoHunk<cr>", opts)

--gitlinker
vim.keymap.set('n', '<leader>og',
	function()
		require "gitlinker".get_buf_range_url("n", { action_callback = require "gitlinker.actions".open_in_browser })
	end, opts
)
vim.keymap.set('v', '<leader>og',
	function()
		require "gitlinker".get_buf_range_url("v", { action_callback = require "gitlinker.actions".open_in_browser })
	end
)


-- split/join
vim.g.splitjoin_split_mapping = ''
vim.g.splitjoin_join_mapping = ''
vim.keymap.set('n', 'gS', ':SplitjoinSplit<cr><cr>', opts)
vim.keymap.set('n', 'gJ', ':SplitjoinJoin<cr><cr>', opts)


-- replace space with ",<cr>"
vim.keymap.set('n', '<leader>ji', [[:s/,\ /",\r"/g]], opts)
-- replace space with newlines
vim.keymap.set('n', '<leader>js', [[:s/\ /\r/g<cr>]], opts)


-- nvim-test
vim.keymap.set('n', '<leader>tn', ':TestNearest<cr>', opts)
vim.keymap.set('n', '<leader>tf', ':TestFile<cr>', opts)
vim.keymap.set('n', '<leader>tl', ':TestLast<cr>', opts)
vim.keymap.set('n', '<leader>tv', ':TestVisit<cr>', opts)

-- replace in file
vim.keymap.set('n', '<leader>r',
	function()
		vim.fn.setreg('s', vim.fn.expand("<cword>"))
		--vim.api.nvim_feedkeys(":%s/<C-r>s//g<Left><Left>", 'n', false)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(':%s/<C-r>s//g<Left><Left>',true,false,true),'m',true)
	end, opts
)
--grepper wip
--vim.keymap.set('v', '<leader>r',
  --function()
     ----vim.api.nvim_feedkeys(string.format(":lua print('%s')", require('dacfg.utils').buf_vtext()), 'n', false)
    --local cmd = ':%s/escape(\'' .. require('dacfg.utils').buf_vtext() .. '\', \'. \\\')//g<Left><Left>'
    --vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd,true,false,true),'m',true)
  --end , opts
--)
--vim.keymap.set('v', '<leader>r',
  --function()
    --vim.cmd("\"sy")
    --vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(':%s/<C-r>s//g<Left><Left>',true,false,true),'m',true)
    ----local cmd = ':%s/' .. require('dacfg.utils').buf_vtext() .. '//g<Left><Left>'
    ----vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd,true,false,true),'m',true)
	--end , opts
--)
--vim.keymap.set('n', '<leader>R', " \z
--:let @s='<'.expand('<cword>').'>'<CR> \z
--:Grepper -cword -noprompt<CR> \z
--:cfdo %s/<C-r>s//g | update \z
--<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left> \z
--"	, opts)
