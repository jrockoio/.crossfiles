-- Cache compiled Lua chunks where supported.
if vim.loader and vim.loader.enable then
  vim.loader.enable()
end

require('dacfg')
