require('fzf-lua').setup {
  keymap = {
    fzf = {
      ["ctrl-a"] = "select-all+accept",
      -- Only valid with fzf previewers (bat/cat/git/etc)
      -- V these don't work V
      ["ctrl-d"] = "preview-page-down",
      ["ctrl-u"] = "preview-page-up",
    },
  },
  winopts = {
		width = .98,
    preview = {
      layout = 'flex'
    },
  },
  files = {
    fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude vendor"
  },
  fzf_opts = {
    ['--layout'] = 'reverse-list',
  },
  grep = {
    rg_opts = "--column --line-number --hidden --no-heading --color=always --smart-case --max-columns=512 \z
			-g '!.git/*' \z
			-g '!package-lock.json' \z
			-g '!vendor/*'",
  },
}
