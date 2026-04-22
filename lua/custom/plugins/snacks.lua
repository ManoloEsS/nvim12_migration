require('snacks').setup({
  bigfile = { enabled = true },
  dashboard = { enabled = false },
  explorer = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true, timeout = 3000 },
  picker = {
    enabled = true,
    sources = {
      explorer = {
        auto_close = true,
        layout = {
          preset = 'default',
          preview = true,
        },
      },
    },
  },
  quickfile = { enabled = true },
  scope = { enabled = false },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  styles = { notification = {} },
})

-- Snacks Picker Keymaps
local function sn(method) return function(...) return Snacks.picker[method](...) end end
vim.keymap.set('n', '<leader><space>', sn 'smart', { desc = 'Smart Find Files' })
vim.keymap.set('n', '<leader>,', sn 'buffers', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>/', sn 'grep', { desc = 'Grep' })
vim.keymap.set('n', '<leader>:', sn 'command_history', { desc = 'Command History' })
vim.keymap.set('n', '<leader>n', function() Snacks.notifier.show_history() end, { desc = 'Notification History' })
vim.keymap.set('n', '<leader>e', function() Snacks.explorer() end, { desc = 'File Explorer' })
vim.keymap.set('n', '<leader>ff', sn 'files', { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', sn 'git_files', { desc = 'Find Git Files' })
vim.keymap.set('n', '<leader>fp', sn 'projects', { desc = 'Projects' })
vim.keymap.set('n', '<leader>fr', sn 'recent', { desc = 'Recent' })
vim.keymap.set('n', '<leader>gb', sn 'git_branches', { desc = 'Git Branches' })
vim.keymap.set('n', '<leader>gl', sn 'git_log', { desc = 'Git Log' })
vim.keymap.set('n', '<leader>gs', sn 'git_status', { desc = 'Git Status' })
vim.keymap.set('n', '<leader>gS', sn 'git_stash', { desc = 'Git Stash' })
vim.keymap.set('n', '<leader>gd', sn 'git_diff', { desc = 'Git Diff' })
vim.keymap.set('n', '<leader>sh', sn 'help', { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', sn 'keymaps', { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', sn 'files', { desc = '[S]earch [F]iles' })
vim.keymap.set({ 'n', 'v' }, '<leader>sw', sn 'grep_word', { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', sn 'grep', { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', sn 'diagnostics', { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', sn 'resume', { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', function() Snacks.picker.builtin() end, { desc = '[S]earch Recent Files' })
vim.keymap.set('n', '<leader>sc', sn 'commands', { desc = '[S]earch [C]ommands' })
vim.keymap.set('n', '<leader><leader>', sn 'buffers', { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sn', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })

-- LSP Attach keymaps using Snacks picker
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('snacks-lsp-keymaps', { clear = true }),
  callback = function(event)
    local buf = event.buf
    vim.keymap.set('n', 'grr', vim.lsp.buf.references, { buffer = buf, desc = '[G]oto [R]eferences' })
    vim.keymap.set('n', 'gri', vim.lsp.buf.implementation, { buffer = buf, desc = '[G]oto [I]mplementation' })
    vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { buffer = buf, desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'grt', vim.lsp.buf.type_definition, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    vim.keymap.set('n', 'gO', function() Snacks.picker.lsp_symbols() end, { buffer = buf, desc = 'LSP D[o]cument Symbols' })
    vim.keymap.set('n', 'gW', function() Snacks.picker.lsp_workspace_symbols() end, { buffer = buf, desc = 'LSP [W]orkspace Symbols' })
  end,
})

-- Snacks toggle bindings
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
    Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
    Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
    Snacks.toggle.diagnostics():map '<leader>ud'
    Snacks.toggle.line_number():map '<leader>ul'
    Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
    Snacks.toggle.treesitter():map '<leader>uT'
    Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
    Snacks.toggle.inlay_hints():map '<leader>uh'
    Snacks.toggle.indent():map '<leader>ug'
    Snacks.toggle.dim():map '<leader>uD'
  end,
})
