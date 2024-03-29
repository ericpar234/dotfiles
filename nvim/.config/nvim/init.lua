--- Define vim for linter
local vim = vim or {}

-- Bootstrap packer.nvim
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  local result = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
  print("Git clone result: " .. result)
  vim.cmd [[packadd packer.nvim]]
  print("packadd command executed")
end

--- Set space as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--- Vim Indenting
local o = vim.o

o.expandtab = true
o.smartindent = true
o.tabstop = 2
o.shiftwidth = 2

-- Enable Term gui colors
vim.opt.termguicolors = true

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer manages itself
  -- Add your plugins here
  use 'hrsh7th/cmp-nvim-lsp'   -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer'     -- Buffer completions
  use 'hrsh7th/cmp-path'       -- Path completions
  use 'L3MON4D3/LuaSnip'       -- Snippet engine

  use {
    "williamboman/nvim-lsp-installer",
    "neovim/nvim-lspconfig",
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',     -- LSP source for nvim-cmp
      'hrsh7th/cmp-buffer',       -- Buffer completions
      'hrsh7th/cmp-path',         -- Path completions
      'hrsh7th/cmp-cmdline',      -- Cmdline completions
      'saadparwaiz1/cmp_luasnip', -- Snippet completions
      'L3MON4D3/LuaSnip',         -- Snippet engine
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
    config = function() require 'nvim-tree'.setup {} end
  }

  use 'tpope/vim-fugitive'

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }

  use 'nvim-lualine/lualine.nvim' -- Statusline

  use 'folke/which-key.nvim'      -- Plugin for keybinding hints
  use { 'romgrk/barbar.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use { "gmr458/vscode_modern_theme.nvim" }
  use { "catppuccin/nvim", as = "catppuccin" }

  use 'feline-nvim/feline.nvim'

  --- Telescope extensions
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope-fzf-native.nvim'
  use 'nvim-telescope/telescope-fzy-native.nvim'
  use 'nvim-telescope/telescope-media-files.nvim'
  use 'nvim-telescope/telescope-fzf-writer.nvim'
  use 'nvim-telescope/telescope-frecency.nvim'
  use 'nvim-telescope/telescope-project.nvim'
  use 'nvim-telescope/telescope-dap.nvim'

  -- Auto complete in the command line
  use {
    'gelguy/wilder.nvim',
    config = function()
      -- config goes here
    end,
  }


  -- tmux navigation
  use 'christoomey/vim-tmux-navigator'
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
              action = 'e ~/dotfiles',
              key = 'd',
            },
          },
        }
      }
    end,
    requires = { 'nvim-tree/nvim-web-devicons' }
  }
end)

require("catppuccin").setup({
  flavor = "mocha",
  integrations = {
    treesitter = true,
    which_key = true,
  },
}

)

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    package.loaded["feline"] = nil
    package.loaded["catppuccin.groups.integrations.feline"] = nil
    require("feline").setup {
      components = require("catppuccin.groups.integrations.feline").get(),
    }
  end,
})

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
    name = "File",
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
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- Buffer navigation
map('n', '<Leader>bn', ':bnext<CR>', opts)     -- Next buffer
map('n', '<Leader>bp', ':bprevious<CR>', opts) -- Previous buffer
map('n', '<Leader>bd', ':bd<CR>', opts)        -- Close buffer

-- Example mapping for opening the terminal
map('n', '<Leader>t', ':split | terminal<CR>', opts) -- Open terminal in horizontal split
vim.api.nvim_set_keymap('n', '<Leader>f', ':Telescope find_files<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

local cmp = require 'cmp'

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


require("nvim-lsp-installer").setup({
  automatic_installation = true,
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
})

require("luasnip.loaders.from_vscode").lazy_load()


local lspconfig = require 'lspconfig'
lspconfig.jedi_language_server.setup {}
lspconfig.bashls.setup {}
lspconfig.clangd.setup {}
lspconfig.cmake.setup {}
lspconfig.dockerls.setup {}
lspconfig.jsonls.setup {}
lspconfig.html.setup {}
lspconfig.zk.setup {}
lspconfig.lua_ls.setup {}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setloclist, { desc = 'Set location list' })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local lsp_mappings = {
      gD            = {"Go to declaration", vim.lsp.buf.declaration},
      gd            = {"Go to definition", vim.lsp.buf.definition},
      K             = {"Hover", vim.lsp.buf.hover},
      gi            = {"Go to implementation", vim.lsp.buf.implementation},
      ['<C-g>']     = {"Signature help", vim.lsp.buf.signature_help},
      ['<space>wa'] = {"Add workspace folder", vim.lsp.buf.add_workspace_folder},
      ['<space>wr'] = {"Remove workspace folder", vim.lsp.buf.remove_workspace_folder},
      ['<space>wl'] = {"List workspace folders", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end},
      ['<space>D']  = {"Type definition", vim.lsp.buf.type_definition},
      ['<space>rn'] = {"Rename", vim.lsp.buf.rename},
      ['<space>ca'] = {"Code action", vim.lsp.buf.code_action},
      gr            = {"References", vim.lsp.buf.references},
      ['<space>F']  = {"Format", function() vim.lsp.buf.format { async = true } end},
    }

    -- Set the mappings with Neovim
    for k, v in pairs(lsp_mappings) do
      vim.keymap.set('n', k, v[2], { buffer = ev.buf, desc = v[1] })
    end

    -- Prepare which-key mapping structure
    local wk_mappings = {}
    for k, v in pairs(lsp_mappings) do
      wk_mappings[k] = { v[2], v[1] }
    end

    -- Register with which-key
    local wk = require("which-key")
    vim.defer_fn(function()
      wk.register(wk_mappings, { buffer = ev.buf })
    end, 1000) -- Adjust the delay as needed
  end,
})


require('gitsigns').setup {
  signs = {
    add = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    delete = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    topdelete = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
  },
  numhl = false,
  linehl = false,
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  current_line_blame = true, -- Toggle with ':Gitsigns toggle_current_line_blame'
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 200,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false,
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    --- Actions
    --- map('n', '<leader>hs', gs.stage_hunk)
    --- map('n', '<leader>hr', gs.reset_hunk)
    --- map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    --- map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    --- map('n', '<leader>hS', gs.stage_buffer)
    --- map('n', '<leader>hu', gs.undo_stage_hunk)
    --- map('n', '<leader>hR', gs.reset_buffer)
    --- map('n', '<leader>hp', gs.preview_hunk)
    --- map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    --- map('n', '<leader>tb', gs.toggle_current_line_blame)
    --- map('n', '<leader>hd', gs.diffthis)
    --- map('n', '<leader>hD', function() gs.diffthis('~') end)
    --- map('n', '<leader>td', gs.toggle_deleted)

    ---  Text object
    --- map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}


local gitsigns_mapping = {
  ["h"] = {
    name = "Gitsigns",
    s = { "<cmd>lua require('gitsigns').stage_hunk()<CR>", "Stage Hunk" },
    r = { "<cmd>lua require('gitsigns').reset_hunk()<CR>", "Reset Hunk" },
    S = { "<cmd>lua require('gitsigns').stage_buffer()<CR>", "Stage Buffer" },
    u = { "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>", "Undo Stage Hunk" },
    R = { "<cmd>lua require('gitsigns').reset_buffer()<CR>", "Reset Buffer" },
    p = { "<cmd>lua require('gitsigns').preview_hunk()<CR>", "Preview Hunk" },
    b = { "<cmd>lua require('gitsigns').blame_line(true)<CR>", "Blame" },
    d = { "<cmd>lua require('gitsigns').diffthis()<CR>", "Diff" },
    D = { "<cmd>lua require('gitsigns').diffthis('HEAD')<CR>", "Diff HEAD" },
    ["t"] = {
      name = "Toggle",
      b = { "<cmd>lua require('gitsigns').toggle_current_line_blame()<CR>", "Toggle Blame" },
      d = { "<cmd>lua require('gitsigns').toggle_deleted()<CR>", "Toggle Deleted" },
    }
  },
}

local gitsigns_visual_mapping = {
  ["h"] = {
    name = "Gitsigns",
    s = { "<cmd>lua require('gitsigns').stage_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>", "Stage Hunk" },
    r = { "<cmd>lua require('gitsigns').reset_hunk({vim.fn.line('.'), vim.fn.line('v')})<CR>", "Reset Hunk" },
  }
}

wk.register(gitsigns_mapping, { prefix = "<leader>" })
wk.register(gitsigns_visual_mapping, { mode = "v", prefix = "<leader>" })

--- Tab buffer switching
-- Switch to the next buffer
vim.api.nvim_set_keymap('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
-- Switch to the previous buffer
vim.api.nvim_set_keymap('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })

local wilder = require('wilder')
wilder.setup({
  modes = { ':', '/', '?', '!' },
  separator = ' ',
  next_key = '<Tab>',
  prev_key = '<S-Tab>',
  quick_match_key = '<C-j>',
  cycle_prev_key = '<C-k>',
  cycle_next_key = '<C-j>',
  cleanup = true,
  pipe_hl_groups = { 'Directory', 'ErrorMsg', 'WildMenu' },
  setup = {
    ['*'] = {
      after = function()
        vim.cmd [[set wildcharm=<Tab>]]
      end,
    },
  },
})

wilder.set_option('renderer', wilder.renderer_mux({
  [':'] = wilder.popupmenu_renderer({
    highlighter = wilder.basic_highlighter(),
  }),
  ['/'] = wilder.wildmenu_renderer({
    highlighter = wilder.basic_highlighter(),
  }),
}))
