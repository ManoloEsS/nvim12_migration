--[[
=====================================================================
====================== KICKSTART.NVIM =========================
=====================================================================
vim: ts=2 sts=2 sw=2 et

Migrated to Neovim 0.12 built-in plugin manager: vim.pack
See `:help vim.pack` for more info.
=====================================================================
--]]

vim.opt.rtp:prepend(vim.fn.stdpath 'config')

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- [[ Setting options ]]
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.winborder = 'rounded'

-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Diagnostic Config ]]
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
  jump = { float = true },
}

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Create directory if it does not exist when saving',
  group = vim.api.nvim_create_augroup('kickstart-mkdir', { clear = true }),
  callback = function()
    local dir = vim.fn.fnamemodify(vim.fn.bufname(), ':p:h')
    if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, 'p') end
  end,
})

-- [[ Plugin Installation: vim.pack ]]
-- See `:help vim.pack` for more info
-- confirm = false skips interactive prompts during install
vim.pack.add({
  -- Dependencies
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',

  -- Core plugins
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/saghen/blink.cmp',
  'https://github.com/L3MON4D3/LuaSnip',

  -- LSP
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/j-hui/fidget.nvim',

  -- Formatting & Completion
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/folke/todo-comments.nvim',

  -- UI
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/folke/snacks.nvim',

  -- Utilities
  'https://github.com/nvim-mini/mini.nvim',
  'https://github.com/ThePrimeagen/harpoon',
  'https://github.com/numToStr/FTerm.nvim',
  'https://github.com/windwp/nvim-ts-autotag',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/mfussenegger/nvim-lint',
  'https://github.com/NMAC427/guess-indent.nvim',
  'https://github.com/ThePrimeagen/99.nvim', -- Re-enabled for Neovim 0.12 migration
}, { confirm = false })

-- [[ Plugin Configuration ]]

-- Treesitter (main branch - new API for neovim 0.12)
vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' }, { confirm = false })
require('nvim-treesitter').setup({
  ensure_installed = { 'lua', 'luadoc', 'c', 'diff', 'vim', 'vimdoc', 'query', 'bash', 'python', 'html', 'markdown', 'markdown_inline' },
})

-- Guess indent
require('guess-indent').setup({})

-- Which-key
require('which-key').setup({
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
})

-- Blink.cmp
require('blink.cmp').setup({
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = { documentation = { auto_show = false }, menu = { border = 'none' } },
  sources = { default = { 'lsp', 'path', 'snippets' } },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true, window = { border = 'none' } },
})

-- Autopairs (integrates with blink.cmp automatically)
require('nvim-autopairs').setup({})

-- LSP Configuration
local servers = {
  stylua = {},
  lua_ls = {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end
      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
        workspace = { checkThirdParty = false },
      })
    end,
  },
}

require('mason').setup()
require('mason-lspconfig').setup({ automatic_enable = true })
require('mason-tool-installer').setup({ ensure_installed = vim.tbl_keys(servers) })

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end

-- LSP Attach keymaps
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local buf = event.buf
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = buf, desc = 'LSP: ' .. desc })
    end
    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { buffer = buf, group = highlight_augroup, callback = vim.lsp.buf.document_highlight })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { buffer = buf, group = highlight_augroup, callback = vim.lsp.buf.clear_references })
    end
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- Clean up document highlight refs when LSP detaches from a buffer
vim.api.nvim_create_autocmd('LspDetach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
  callback = function(event)
    vim.lsp.buf.clear_references()
    vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event.buf }
  end,
})

-- Fidget
require('fidget').setup({
  notification = { window = { winblend = 0 } },
})

-- Conform
require('conform').setup({
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then return nil end
    return { timeout_ms = 500, lsp_format = 'fallback' }
  end,
  formatters_by_ft = { lua = { 'stylua' } },
})

-- nvim-lint
local lint = require 'lint'
lint.linters_by_ft = {
  markdown = { 'markdownlint' },
}
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('lint', { clear = true }),
  callback = function()
    if vim.bo.modifiable then lint.try_lint() end
  end,
})

-- Todo-comments
require('todo-comments').setup({ signs = false })

-- Colorscheme
require('tokyonight').setup({
  transparent = true,
  styles = { comments = { italic = false }, floats = 'transparent', sidebars = 'transparent' },
})
vim.cmd.colorscheme 'tokyonight-night'

-- Mini.nvim
require('mini.ai').setup({ n_lines = 500 })
require('mini.surround').setup()
require('mini.statusline').setup({ use_icons = vim.g.have_nerd_font })

-- [[ Custom keymaps from lua/custom/keymaps.lua ]]
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = '[P]rev [V]iew files' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = '[M]ove line down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = '[M]ove line up' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = '[J]oin lines' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = '[D]own half page' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = '[U]p half page' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = '[N]ext search result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = '[-]rev search result' })
vim.keymap.set('n', '=ap', "ma=ap'a", { desc = '[A]uto [P]aragraph' })
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = '[P]aste from black hole' })
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = '[Y]ank to clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = '[Y]ank line to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d', { desc = '[D]elete to black hole' })
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz', { desc = '[K]ext location' })
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz', { desc = '[J]rev location' })
vim.keymap.set('t', '<C-a>', '<C-\\><C-n>', { desc = '[E]xit terminal' })
vim.keymap.set('n', '<leader>a', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]], { desc = '[A]ll in file' })
vim.keymap.set('n', '<leader>w', '<C-w>=', { desc = 'Make equal splits' })

-- UndoTree (native in Neovim 0.12)
vim.keymap.set('n', '<leader>u', '<cmd>Undotree<CR>', { desc = 'UndoTree Toggle' })

-- Format keymap
vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format({ async = true, lsp_format = 'fallback' }) end, { desc = '[F]ormat buffer' })

-- [[ Custom requires ]]
require 'custom.options'
require 'custom.keymaps'
require 'custom.go'
require 'custom.highlights'
require 'custom.plugins.gitsigns'
require 'custom.plugins.autotag'
require 'custom.plugins.fterm_undotree'
require 'custom.plugins.snacks'
require 'custom.plugins.harpoon'
require 'custom.plugins.99'

-- vim: ts=2 sts=2 sw=2 et
