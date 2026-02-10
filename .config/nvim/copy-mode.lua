-- ~/.config/nvim/copy-mode.lua
--
vim.opt.runtimepath:append(vim.fn.stdpath 'data' .. '/lazy/baleia.nvim')
vim.g.baleia = require('baleia').setup {}

vim.cmd 'hi Normal ctermbg=NONE'

-- Use terminal colors to blend in
vim.opt.termguicolors = false

-- Hide all chrome
vim.opt.signcolumn = 'no'
vim.opt.fillchars = { eob = ' ' } -- Hide ~ on empty lines
vim.opt.laststatus = 0
vim.opt.cmdheight = 0
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.shortmess:append 'I'

local function quit() vim.cmd 'qa!' end

-- Block insert/replace modes
for _, key in ipairs { 'a', 'A', 'i', 'I', 'o', 'O', 'R', 'c', 'C', 's', 'S', 'd', 'D', 'x', 'X', 'r', 'p', 'P', 'u', 'U' } do
  vim.keymap.set('n', key, '<Nop>')
end

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Pipe yanked text into clipboard(s)',
  callback = function()
    local text = table.concat(vim.v.event.regcontents, '\n')
    vim.fn.jobstart({ 'wl-copy', '--', text }, { detach = true })
    vim.fn.jobstart({ 'tmux', 'set-buffer', '--', text }, { detach = true })
    vim.defer_fn(quit, 10)
  end,
})

-- Buffer settings
vim.opt.swapfile = false
vim.opt.virtualedit = 'onemore'
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.virtualedit = 'onemore'

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Exit keys
vim.keymap.set('n', 'q', quit)
vim.keymap.set('n', '<Esc>', quit)
vim.keymap.set('n', '<CR>', quit)
vim.keymap.set('n', '<Space>', quit)

local function exit_pane(dir)
  return function()
    vim.fn.jobstart('tmux select-pane -' .. dir, { detach = true })
    quit()
  end
end

vim.keymap.set('n', '<C-h>', exit_pane 'L', { silent = true })
vim.keymap.set('n', '<C-j>', exit_pane 'D', { silent = true })
vim.keymap.set('n', '<C-k>', exit_pane 'U', { silent = true })
vim.keymap.set('n', '<C-l>', exit_pane 'R', { silent = true })

vim.api.nvim_create_autocmd('BufReadPost', {
  once = true,
  callback = function()
    local line = tonumber(vim.env.COPY_LINE) or 1
    local col = tonumber(vim.env.COPY_COL) or 0
    local buf = vim.api.nvim_get_current_buf()

    vim.bo[buf].buftype = 'nofile'
    vim.g.baleia = require('baleia').setup {}
    vim.g.baleia.once(buf)
    vim.api.nvim_win_set_cursor(0, { line, col })
  end,
})
