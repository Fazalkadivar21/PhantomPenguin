vim.opt.number = false
vim.opt.relativenumber = true

vim.opt.tabstop = 4        -- Width of tab character
vim.opt.shiftwidth = 4     -- Width for autoindents
vim.opt.expandtab = true   -- Converts tabs to spaces
vim.opt.softtabstop = 4    -- Width when hitting Tab or Backspace

vim.opt.fillchars = { eob = " " }

vim.opt.background = "dark" -- set this to dark or light
vim.cmd("colorscheme oxocarbon")

vim.opt.clipboard = "unnamedplus"

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- LSP Keybindings
vim.keymap.set('n', '<leader>f', function()
  vim.lsp.buf.format { async = true }
end, { desc = 'Format file' })

vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
