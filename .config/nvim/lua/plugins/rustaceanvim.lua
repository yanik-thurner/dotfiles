-- lua/plugins/rustaceanvim.lua
-- Replaces the rust_analyzer entry in your lspconfig servers table.
-- Provides :RustLsp debuggables, :RustLsp run, :RustLsp testables, etc.
-- Requires nvim-dap + codelldb (see debug.lua) for debugging support.

---@module 'lazy'
---@type LazySpec
return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false,
  init = function()
    vim.g.rustaceanvim = {
      server = {
        settings = {
          ['rust-analyzer'] = {
            diagnostics = {
              styleLints = { enable = true },
            },
          },
        },
      },
    }
  end,
  keys = {
    { '<leader>rd', function() vim.cmd.RustLsp 'debuggables' end, desc = '[R]ust [D]ebuggables', ft = 'rust' },
    { '<leader>rr', function() vim.cmd.RustLsp 'runnables' end, desc = '[R]ust [R]unnables', ft = 'rust' },
    { '<leader>rt', function() vim.cmd.RustLsp 'testables' end, desc = '[R]ust [T]estables', ft = 'rust' },
    { '<leader>re', function() vim.cmd.RustLsp 'explainError' end, desc = '[R]ust [E]xplain Error', ft = 'rust' },
  },
}
