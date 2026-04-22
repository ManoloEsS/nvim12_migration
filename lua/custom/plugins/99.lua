local _99 = require '99'
local cwd = vim.uv.cwd()
local basename = vim.fs.basename(cwd)

_99.setup({
  provider = _99.Providers.OpenCodeProvider,
  model = 'opencode/big-pickle',
  logger = {
    level = _99.INFO,
    path = '/tmp/' .. basename .. '.99.debug',
    print_on_error = true,
  },
})

vim.keymap.set('n', '<leader>9s', function() _99.search() end, { desc = '[9]9 Search' })
vim.keymap.set('v', '<leader>9v', function() _99.visual() end, { desc = '[9]9 Visual' })