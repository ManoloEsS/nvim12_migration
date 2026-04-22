local harpoon = require 'harpoon'
harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
    key = function() return vim.uv.cwd() end,
  },
})

vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = 'Harpoon [A]dd file' })
vim.keymap.set('n', '<leader>hm', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon [M]enu' })
vim.keymap.set('n', '<A-h>', function() harpoon:list():select(1) end, { desc = 'Harpoon mark [1]' })
vim.keymap.set('n', '<A-j>', function() harpoon:list():select(2) end, { desc = 'Harpoon mark [2]' })
vim.keymap.set('n', '<A-k>', function() harpoon:list():select(3) end, { desc = 'Harpoon mark [3]' })
vim.keymap.set('n', '<A-l>', function() harpoon:list():select(4) end, { desc = 'Harpoon mark [4]' })
vim.keymap.set('n', '<leader>hn', function() harpoon:list():next() end, { desc = 'Harpoon [N]ext' })
vim.keymap.set('n', '<leader>hp', function() harpoon:list():prev() end, { desc = 'Harpoon [P]revious' })
