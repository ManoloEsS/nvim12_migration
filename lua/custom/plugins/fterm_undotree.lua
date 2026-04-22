local fterm = require 'FTerm'
local custom_term = fterm:new({
  ft = 'fterm_custom',
  cmd = vim.o.shell,
  dimensions = { height = 0.6, width = 0.5, x = 0.95, y = 0.95 },
  border = 'rounded',
})

function _G._toggle_term() custom_term:toggle() end
vim.keymap.set('n', '<C-t>', '<CMD>lua _toggle_term()<CR>', { desc = '[T]oggle Terminal' })
vim.keymap.set('t', '<C-t>', '<C-\\><C-n><CMD>lua _toggle_term()<CR>', { desc = '[T]oggle Terminal' })
