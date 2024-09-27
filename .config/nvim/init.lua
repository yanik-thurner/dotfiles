--==================================--
--=== Source Legacy Vim Settings ===--
--==================================--
-- TODO fix
vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.o.packpath = vim.o.runtimepath
vim.cmd('source ~/.vimrc')

--==================================--
--======== Install Packages ========--
--==================================--
require('lazy-bootstrap')
require('lazy').setup {
    -- Theming
    {
        'Yazeed1s/oh-lucy.nvim',
        lazy = false,
        priority = 1000,
        config = function() vim.cmd([[colorscheme oh-lucy-evening]]) end,
    },
    'rasulomaroff/reactive.nvim',
    { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

    -- Syntax
    'nvim-treesitter/nvim-treesitter',
    { import = 'lsp' },

    -- UI
    {
        'nvim-telescope/telescope.nvim',
        opts = {
            pickers = {
                colorscheme = {
                    enable_preview = true,
                }
            }
        },
        requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzf-native.nvim' }
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-lualine/lualine.nvim',                requires = { 'nvim-tree/nvim-web-devicons' } }
}


--==================================--
--======= Configure Packages =======--
--==================================--

-- Treesitter
require('nvim-treesitter.install').update({ with_sync = true })()
require('nvim-treesitter.configs').setup {
    ensure_installed = {
        -- programming
        --        'comment',
        -- scripting
        'bash',
        'lua',
        -- misc
        'vim',
        'vimdoc'
    },
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true
    },
}
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- UI
require('telescope').setup()
require('telescope').load_extension('fzf')

require('reactive').setup {
    builtin = {
        cursorline = true,
        cursor = true,
        modemsg = true
    }
}
require('lualine').setup {}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fj', builtin.jumplist, {})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
