vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text

local git_blame = require('gitblame')

local function blame()
	if git_blame.is_blame_text_available() then
		return git_blame.get_current_blame_text()
	else
		return [[]]
	end
end

local function lsp_client()
	local clients = vim.lsp.get_clients()
	local ret = ""
	for i, c in ipairs(clients) do
		if i > 1 then
			ret = ret .. ", "
		end
		ret = ret .. c.name
	end
	return ret
end

require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'gruvbox_dark',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { blame },
		lualine_x = { 'fileformat', lsp_client },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	}
}
