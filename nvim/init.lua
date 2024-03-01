
--- Set space as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end


require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer manages itself
  -- Add your plugins here
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer' -- Buffer completions
  use 'hrsh7th/cmp-path' -- Path completions
  use 'L3MON4D3/LuaSnip' -- Snippet engine

  use 'neovim/nvim-lspconfig' -- Quickstart configurations for the Nvim LSP client
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
      'hrsh7th/cmp-buffer', -- Buffer completions
      'hrsh7th/cmp-path', -- Path completions
      'hrsh7th/cmp-cmdline', -- Cmdline completions
      'saadparwaiz1/cmp_luasnip', -- Snippet completions
      'L3MON4D3/LuaSnip', -- Snippet engine
    }
  }
  use {
  'nvim-treesitter/nvim-treesitter',
        run = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
  }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    config = function() require'nvim-tree'.setup {} end
  }

  use 'tpope/vim-fugitive'
  use 'nvim-lualine/lualine.nvim' -- Statusline

  use 'folke/which-key.nvim' -- Plugin for keybinding hints
  use {'romgrk/barbar.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  
  use { "gmr458/vscode_modern_theme.nvim" }
  use { "catppuccin/nvim", as = "catppuccin" }

  --- Telescope extensions
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope-fzy-native.nvim'
  use 'nvim-telescope/telescope-media-files.nvim'
  use 'nvim-telescope/telescope-fzf-writer.nvim'
  use 'nvim-telescope/telescope-frecency.nvim'
  use 'nvim-telescope/telescope-project.nvim'
  use 'nvim-telescope/telescope-dap.nvim'
  --- Markdown Wiki
  use 'vimwiki/vimwiki'


  -- Dashboard
  use {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        theme = 'hyper',
        config = {
          week_header = {
           enable = true,
          },
          shortcut = {
            { desc = '󰊳 Update', group = '@property', action = 'PackerSync', key = 'u' },
            {
              icon = ' ',
              icon_hl = '@variable',
              desc = 'Files',
              group = 'Label',
              action = 'Telescope find_files',
              key = 'f',
            },
           {
	      desc = ' Configuration',
	      group = '@property',
              action = 'e ~/.config/nvim/init.lua',
	      key = 'c',
            },
            {
              desc = ' dotfiles',
              group = 'Number',
              action = 'Telescope dotfiles',
              key = 'd',
            },
          },
	}
       }
    end,
    requires = {'nvim-tree/nvim-web-devicons'}
  }


end)

require('nvim-web-devicons').setup {
 -- your configuration here
}
vim.cmd.colorscheme "catppuccin"

local wk = require("which-key")

local git_mappings = {
  ["g"] = {
    name = "Git",
    s = { "<cmd>Git<cr>", "Status" },
    b = { "<cmd>Git blame<cr>", "Blame" },
    c = { "<cmd>Git commit<cr>", "Commit" },
    p = { "<cmd>Git push<cr>", "Push" },
    l = { "<cmd>Git pull<cr>", "Pull" },
    m = { "<cmd>Git merge<cr>", "Merge" },
    r = { "<cmd>Git rebase<cr>", "Rebase" },
    d = { "<cmd>Git diff<cr>", "Diff" },
  },
}
local mappings = {
  ["<leader>"] = {
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    b = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    p = { "<cmd>Telescope projects<cr>", "Find Project" },
    r = { "<cmd>Telescope oldfiles<cr>", "Find Recent File" },
    t = { "<cmd>Telescope treesitter<cr>", "Find Treesitter" },
    m = { "<cmd>Telescope media_files<cr>", "Find Media Files" },
    w = { "<cmd>Telescope wiki index<cr>", "Find Wiki" },
    s = { "<cmd>Telescope frecency<cr>", "Find Frecency" },
    z = { "<cmd>Telescope fzf writer<cr>", "Find FZF Writer" },
  },
  ["<leader>e"] = { "<cmd>NvimTreeToggle<cr>", "Toggle NvimTree" },
  ["<leader>q"] = { "<cmd>q<cr>", "Quit" },
  ["<leader>w"] = { "<cmd>w<cr>", "Save" },
  ["<leader>x"] = { "<cmd>x<cr>", "Save and Quit" },
  ["<leader>o"] = { "<cmd>e .<cr>", "Open File Explorer" },
  ["<leader>t"] = { "<cmd>split | terminal<cr>", "Open Terminal" },
  --- Close window
  ["<leader>c"] = { "<C-w>c", "Close Window" }, 


}
wk.register(git_mappings, { prefix = "<leader>" })
wk.register(mappings, { prefix = "<leader>" })

vim.opt.number = true

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Ctrl+h/j/k/l to navigate windows
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap = true, silent = true})

-- Buffer navigation
map('n', '<Leader>bn', ':bnext<CR>', opts) -- Next buffer
map('n', '<Leader>bp', ':bprevious<CR>', opts) -- Previous buffer
map('n', '<Leader>bd', ':bd<CR>', opts) -- Close buffer

-- Example mapping for opening the terminal
map('n', '<Leader>t', ':split | terminal<CR>', opts) -- Open terminal in horizontal split
vim.api.nvim_set_keymap('n', '<Leader>f', ':Telescope find_files<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
  })
})


local nvim_lsp = require'lspconfig'

nvim_lsp.pyright.setup{}

require("luasnip.loaders.from_vscode").lazy_load()

