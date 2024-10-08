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
-- TODO: Move to lazy
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer manages itself
  -- Add your plugins here

  use {
    "williamboman/mason-lspconfig.nvim",
    "williamboman/mason.nvim",
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
    'SergioRibera/cmp-dotenv',
    requires = { 'hrsh7th/nvim-cmp' },
    run = function()
      require('cmp').setup.buffer {
        sources = {
          { name = 'dotenv' },
        },
      }
    end
  }

  use "rafamadriz/friendly-snippets"

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
    'MeanderingProgrammer/markdown.nvim',
    requires = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('render-markdown').setup()
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim', 'BurntSuchi/ripgrep' }
    }
  }

  use { "catppuccin/nvim", as = "catppuccin" }

  use 'feline-nvim/feline.nvim'

  --- Telescope extensions
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
  use 'nvim-telescope/telescope-fzf-writer.nvim'
  use 'nvim-telescope/telescope-frecency.nvim'
  use 'nvim-telescope/telescope-project.nvim'
  use 'nvim-telescope/telescope-dap.nvim'
  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  }
  use({
    "dharmx/telescope-media.nvim",
    config = function()
      require("telescope").load_extension("media")
    end,
  })

  --- Directory Buffer Editor
  use 'stevearc/oil.nvim'

  --- Command Line popup
  use {
    "folke/noice.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      --- Optional
      "rcarriga/nvim-notify",
    }
  }
  -- tmux navigation
  use 'christoomey/vim-tmux-navigator'

  -- Indents
  use 'lukas-reineke/indent-blankline.nvim'

  -- Icons in suggestions
  use 'onsails/lspkind.nvim'

  -- init.lua dev
  use 'folke/neodev.nvim'

  -- copilot
  use 'zbirenbaum/copilot.lua'

  -- Github
  use {
    'ldelossa/gh.nvim',
    requires = { { 'ldelossa/litee.nvim' } }
  }

  use {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    requires = { 'nvim-lua/plenary.nvim', 'zbirenbaum/copilot.lua' }
  }

  use {
    'folke/todo-comments.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }
  use {
    'folke/trouble.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
  }

  use { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' }
  use 'luukvbaal/statuscol.nvim'


  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
  -- Dashboard
  use {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        theme = 'hyper',
        change_to_vcs_root = true,
        config = {
          week_header = {
            enable = true,
          },
          project = {
            enable = true,
            limit = 10,
          },

          shortcut = {
            { desc = '󰊳 Update',
              group = '@property',
              action = 'PackerSync',
              key = 'u'
            },
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
            {
              desc= 'Check Health',
              group = '@property',
              action = 'checkhealth',
              key = 'h',
              icon = ' ',
            }
          },

          footer = { "" }
        }
      }
    end,
    requires = { 'nvim-tree/nvim-web-devicons' }
  }
end)

require("oil").setup()

require("catppuccin").setup({
  flavor = "macchiato",
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

require 'telescope'.load_extension('project')
require 'telescope'.load_extension('fzf')
require 'telescope'.load_extension('frecency')
require 'telescope'.load_extension('fzf_writer')
require 'telescope'.load_extension('noice')
--- require 'telescope'.load_extension('file_browser')

local canned = require("telescope._extensions.media.lib.canned")


require('telescope').setup {
  defaults = {
    file_ignore_patterns = { ".git" },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
    },
  },
  extensions = {
    media = {
      backend = "chafa", -- image/gif backend
      on_confirm_single = canned.single.copy_path,
      on_confirm_muliple = canned.multiple.bulk_copy,
    }
  }
}
vim.api.nvim_create_autocmd("FileType", { pattern = "TelescopeResults", command = [[setlocal nofoldenable]] })

-- Copilot
require('copilot').setup({
  panel = {
    enabled = true,
    auto_refresh = true,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      --accept = "<M-l>",
      accept = "<Tab>",
      accept_word = false,
      accept_line = false,
      next = "<M-j>",
      prev = "<M-k>",
      --dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = true,
    markdown = true,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 18.x
  server_opts_overrides = {},
})

vim.cmd.colorscheme "catppuccin"

local wk = require("which-key")

local git_mappings = {
  { "<leader>g",  group = "Git" },
  { "<leader>gb", "<cmd>Git blame<cr>",  desc = "Blame" },
  { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
  { "<leader>gd", "<cmd>Git diff<cr>",   desc = "Diff" },
  { "<leader>gl", "<cmd>Git log<cr>",    desc = "Log" },
  { "<leader>gp", "<cmd>Git push<cr>",   desc = "Push" },
  { "<leader>gr", "<cmd>Git rebase<cr>", desc = "Rebase" },
  { "<leader>gs", "<cmd>Git<cr>",        desc = "Status" },
}
local mappings = {
  { "<leader><leader>",  group = "Find" },
  { "<leader><leader>W", "<cmd>Telescope live_grep<cr>",                 desc = "Find Word" },
  { "<leader><leader>b", "<cmd>Telescope buffers<cr>",                   desc = "Find Buffer" },
  { "<leader><leader>f", "<cmd>Telescope find_files<cr>",                desc = "Find File" },
  { "<leader><leader>h", "<cmd>Telescope help_tags<cr>",                 desc = "Find Help" },
  { "<leader><leader>m", "<cmd>Telescope media<cr>",                     desc = "Find Media Files" },
  { "<leader><leader>n", "<cmd>Telescope noice<cr>",                     desc = "Find Noice" },
  { "<leader><leader>p", "<cmd>Telescope project<cr>",                   desc = "Find Project" },
  { "<leader><leader>r", "<cmd>Telescope oldfiles<cr>",                  desc = "Find Recent File" },
  { "<leader><leader>s", "<cmd>Telescope frecency<cr>",                  desc = "Find Frecency" },
  { "<leader><leader>t", "<cmd>Telescope treesitter<cr>",                desc = "Find Treesitter" },
  { "<leader><leader>w", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in Buffer" },
  { "<leader><leader>z", "<cmd>Telescope fzf writer<cr>",                desc = "Find FZF Writer" },
  { "<leader>e",         "<cmd>NvimTreeToggle<cr>",                      desc = "Toggle File Explorer" },
  { "<leader>t",         "<cmd>split | terminal<cr>",                    desc = "Open Terminal" },
}

wk.add(git_mappings, { prefix = "<leader>" })
wk.add(mappings, { prefix = "<leader>" })


vim.opt.number = true

-- Ctrl+h/j/k/l to navigate windows
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- Buffer navigation
vim.api.nvim_set_keymap('n', '<leader>bn', ':bnext<CR>', { noremap = true, silent = true, desc = "Next buffer" })
vim.api.nvim_set_keymap('n', '<leader>bp', ':bprevious<CR>', { noremap = true, silent = true, desc = "Previous buffer" })
vim.api.nvim_set_keymap('n', '<leader>bd', ':bp|bd#<CR>', { noremap = true, silent = true, desc = "Delete buffer" })

--- Tab buffer switching
-- Switch to the next buffer
vim.api.nvim_set_keymap('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
-- Switch to the previous buffer
vim.api.nvim_set_keymap('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })

local lspkind = require('lspkind')
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
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
  }),
  formatting = {
    fields = { 'abbr', 'kind', 'menu' },
    expandable_indicator = true,
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      -- can also be a function to dynamically calculate max width such as
      -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
      ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      --- before = function (entry, vim_item)
      ---  ...
      ---  return vim_item
      ---end
    })
  }
})

require("luasnip.loaders.from_vscode").lazy_load()


require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})
require("mason-lspconfig").setup({
  -- your configuration here
})

require("neodev").setup({})
vim.lsp.start({
  name = "lua-language-server",
  cmd = { "lua-language-server" },
  before_init = require("neodev.lsp").before_init,
  root_dir = vim.fn.getcwd(),
  settings = { Lua = {} },
})
-- Ansible Lsp
-- Function to check if the content is likely part of an Ansible playbook
local function is_ansible(content)
  local ansible_keywords = {
    "hosts:",
    "tasks:",
    "handlers:",
    "vars:",
    "include:",
    "roles:",
    "become:",
    "ansible.builtin."
  }
  for _, keyword in ipairs(ansible_keywords) do
    if content:match(keyword) then
      return true
    end
  end
  return false
end

-- Custom filetype detection
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.yml,*.yaml",
  callback = function(args)
    local lines = vim.api.nvim_buf_get_lines(args.buf, 0, 10, false) -- Check first 10 lines
    local content = table.concat(lines, "\n")
    if is_ansible(content) then
      vim.bo[args.buf].filetype = 'yaml.ansible'
    else
      vim.bo[args.buf].filetype = 'yaml'
    end
  end
}) -- LSP setup specific for Ansible if the filetype is ansible.yaml
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.yml,*.yaml",
  callback = function(args)
    local lines = vim.api.nvim_buf_get_lines(args.buf, 0, 10, false) -- Check first 10 lines
    local content = table.concat(lines, "\n")
    if is_ansible(content) then
      vim.bo[args.buf].filetype = 'ansible.yaml'
    else
      vim.bo[args.buf].filetype = 'yaml'
    end
  end
}) -- LSP setup specific for Ansible if the filetype is ansible.yaml


vim.api.nvim_create_autocmd("FileType", {
  pattern = "ansible.yaml",
  callback = function()
    require('lspconfig')['ansiblels'].setup {
      settings = {
        ansible = {
          ansible = { path = "ansible" },
          ansibleLint = { enabled = true, path = "ansible-lint" },
          python = { interpreterPath = "python" }
        }
      }
    }
  end
})

local lspconfig = require 'lspconfig'
lspconfig.jedi_language_server.setup {}
lspconfig.bashls.setup {}
lspconfig.clangd.setup {
  cmd = { "clangd", "--background-index" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
}
lspconfig.cmake.setup {}
lspconfig.dockerls.setup {}
lspconfig.jsonls.setup {}
lspconfig.html.setup {}
lspconfig.zk.setup {}
lspconfig.lua_ls.setup {}
lspconfig.ansiblels.setup {}
lspconfig.quick_lint_js.setup {}
lspconfig.typescript_language_server.setup {}
--- go
lspconfig.gopls.setup {
  cmd = { "gopls", "serve" },
}

local signs = {
  Error = "",
  Warn = "",
  Hint = "",
  Info = " "
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>Q', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Toggle Trouble' })


vim.keymap.set('n', '<leader>\"', "<cmd>split<CR>", { desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>%', "<cmd>vsplit<CR>", { desc = 'Vertical split' })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer:quick_match_key
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    opts.desc = 'Go to definition'
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    opts.desc = 'Go to type declaration'
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    opts.desc = 'Hover'
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    opts.desc = 'Go to implementation'
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    opts.desc = 'Signature help'
    vim.keymap.set('n', '<C-g>', vim.lsp.buf.signature_help, opts)
    opts.desc = 'Add Workspace'
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    opts.desc = 'Remove Workspace'
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    opts.desc = 'List Workspaces'
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    opts.desc = 'Type definition'
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    opts.desc = 'Rename'
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    opts.desc = 'Code action'
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    opts.desc = 'References'
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    opts.desc = 'Format'
    vim.keymap.set('n', '<leader>F', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local cmp_nvim_lsp = require "cmp_nvim_lsp"

require("lspconfig").clangd.setup {
  on_attach = on_attach,
  capabilities = cmp_nvim_lsp.default_capabilities(),
  cmd = {
    "clangd",
  },
}

require('gitsigns').setup {
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 1000,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',


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
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    --- Actions
    map('n', '<leader>hs', gs.stage_hunk, { desc = "Stage Hunk" })
    map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset Hunk" })
    map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, { desc = "Stage Hunk" })
    map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, { desc = "Reset Hunk" })
    map('n', '<leader>hS', gs.stage_buffer, { desc = "Stage Buffer" })
    map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
    map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset Buffer" })
    map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview Hunk" })
    map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "Blame" })
    map('n', '<leader>htb', gs.toggle_current_line_blame, { desc = "Toggle Blame" })
    map('n', '<leader>hd', gs.diffthis, { desc = "Diff" })
    map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Diff HEAD" })
    map('n', '<leader>htd', gs.toggle_deleted, { desc = "Toggle Deleted" })

    --- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
wk.add({"<leader>h", group = "GitSigns"})

require("ibl").setup()
require("ibl").overwrite {
  exclude = {
    filetypes = { "NvimTree", "dashboard", "packer", "TelescopePrompt", "TelescopeResults" },
    buftypes = { "terminal", "TelescopePrompt", "TelescopeResults" },
  },
}

require("telescope").load_extension("noice")
-- Command Terminal
require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  cmdline = {
    format = {
      cmdline = { pattern = "^:", icon = "", lang = "vim" },
      search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex", view = "cmdline" },
      search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex", view = "cmdline" },
      filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
      lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
      help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
      input = {}, -- Used by input()
      substitue = { kind = "search", pattern = "^:%%?s/", icon = "", lang = "regex", view = "cmdline" },

    },
  },
  views = {
    cmdline_popup = {
      position = {
        row = "50%",
        col = "50%",
      },
      border = {
        style = "none",
        padding = { 1, 2 },
      },
      win_options = {
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      },
    },
    popupmenu = {
      relative = "editor",
      position = {
        row = "50%",
        col = "auto",
      },
      border = {
        style = "none",
        padding = { 1, 0, -5, 0 },
      },
      win_options = {
        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      },
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true,         -- use a classic bottom cmdline for search
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false,       -- add a border to hover docs and signature help
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        --- kind = "",
        find = "written",
      },
      opts = { skip = true },
    },

    {
      filter = {
        event = "msg_show",
        find = "replace with",
      },
      view = "cmdline",
    },

    --- Route long messages to split
    {
      filter = {
        event = "msg_show",
        any = { { min_height = 5 }, { min_width = 200 } },
        ["not"] = {
          kind = { "confirm", "confirm_sub", "return_prompt", "quickfix", "search_count" },
        },
        blocking = false,
      },
      view = "messages",
      opts = { stop = true },
    },

    --- Anoying Messages
    {
      filter = {
        event = "msg_show",
        any = {
          { find = "; after #%d+" },
          { find = "; before #%d+" },
          { find = "fewer lines" },
        },
      },
      view = "messages",
      opts = { skip = true },
    },
  }
})

vim.keymap.set("n", "<leader>nd", "<cmd>Noice dismiss<cr>", { desc = "Dismiss noice" })
vim.keymap.set("n", "<leader>nh", "<cmd>Noice history<cr>", { desc = "Noice history" })

-- Github
require('litee.lib').setup()
require('litee.gh').setup({
  -- deprecated, around for compatability for now.
  jump_mode             = "invoking",
  -- remap the arrow keys to resize any litee.nvim windows.
  map_resize_keys       = false,
  -- do not map any keys inside any gh.nvim buffers.
  disable_keymaps       = false,
  -- the icon set to use.
  icon_set              = "default",
  -- any custom icons to use.
  icon_set_custom       = nil,
  -- whether to register the @username and #issue_number omnifunc completion
  -- in buffers which start with .git/
  git_buffer_completion = true,
  -- defines keymaps in gh.nvim buffers.
  keymaps               = {
    -- when inside a gh.nvim panel, this key will open a node if it has
    -- any futher functionality. for example, hitting <CR> on a commit node
    -- will open the commit's changed files in a new gh.nvim panel.
    open = "<CR>",
    -- when inside a gh.nvim panel, expand a collapsed node
    expand = "zo",
    -- when inside a gh.nvim panel, collpased and expanded node
    collapse = "zc",
    -- when cursor is over a "#1234" formatted issue or PR, open its details
    -- and comments in a new tab.
    goto_issue = "gd",
    -- show any details about a node, typically, this reveals commit messages
    -- and submitted review bodys.
    details = "d",
    -- inside a convo buffer, submit a comment
    submit_comment = "<cr>",
    -- inside a convo buffer, when your cursor is ontop of a comment, open
    -- up a set of actions that can be performed.
    actions = "<C-a>",
    -- inside a thread convo buffer, resolve the thread.
    resolve_thread = "<C-r>",
    -- inside a gh.nvim panel, if possible, open the node's web URL in your
    -- browser. useful particularily for digging into external failed CI
    -- checks.
    goto_web = "gx"
  }
})

require("CopilotChat").setup({
  mappings = {
    reset = {
      normal = '<C-n>',
      insert = '<C-n>'
    },
  },
})

local function quickChat(selection)
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, { selection = selection })
  end
end

wk.add({ "<leader>cc", group = "Copilot Chat" })
vim.keymap.set("n", "<leader>cce", "<cmd>CopilotChatExplain<cr>", { desc = "Copilot Chat Explain" })
vim.keymap.set("n", "<leader>cct", "<cmd>CopilotChatToggle<cr>", { desc = "Copilot Chat Toggle" })
vim.keymap.set("n", "<leader>ccq", function() quickChat(require("CopilotChat.select").buffer) end,
  { desc = "Copilot Quick Chat" })
vim.keymap.set("v", "<leader>ccq", function() quickChat(require("CopilotChat.select").visual) end,
  { desc = "Copilot Quick Chat" })
vim.keymap.set("v", "<leader>cce", "<cmd>CopilotChatExplain<cr>", { desc = "Copilot Chat Explain" })
vim.keymap.set("n", "<leader>ccp", function()
  local actions = require("CopilotChat.actions")
  require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
end, { desc = "Copilot Chat Prompt" })
vim.keymap.set("v", "<leader>ccp", function()
  local actions = require("CopilotChat.actions")
  require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
end, { desc = "Copilot Chat Prompt" })

vim.keymap.set("n", "<leader>ccc", "<cmd>CopilotChatCommit<cr>", { desc = "Copilot Chat Commit" })

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'copilot-*',
  callback = function()
    -- turn off line number, status bar for this buffer

    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    vim.wo.cursorline = false

    -- Set the width of the buffer to be 1/3 of the screen
    vim.api.nvim_win_set_width(0, math.floor(vim.o.columns / 3))
  end
})

require("todo-comments").setup {}
vim.keymap.set("n", "<leader><leader>td", "<cmd>TodoTelescope<cr>", { desc = "Todo Telescope" })
vim.keymap.set("n", "<leader>Td", "<cmd>TodoTrouble<cr>", { desc = "Todo Loc List" })
require('trouble').setup {}

vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

-- Option 2: nvim lsp as LSP client
-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}
local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
  require('lspconfig')[ls].setup({
    capabilities = capabilities
    -- you can add other fields for setting up lsp server in this table
  })
end

local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (' 󰁂 %d '):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, 'MoreMsg' })
  return newVirtText
end

require('ufo').setup({
  fold_virt_text_handler = handler,
})

-- Disable status line and line numbers in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.o.laststatus = 0
  end
})

-- Restore settings when leaving terminal buffers
vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*",
  callback = function()
    vim.wo.number = true
    vim.wo.relativenumber = true
    vim.o.laststatus = 2
  end
})

local builtin = require('statuscol.builtin')
require('statuscol').setup({
  segments = {
    {
      sign = {
        name = { ".*" },
        text = { ".*" },
        maxwidth = 1,
        colwidth = 1,
        auto = true,
        wrap = true
      },
      click = "v:lua.ScSa"
    },
    {
      text = { builtin.lnumfunc, " " },
      condition = { builtin.not_empty, true },
      click = "v:lua.ScLa",
    }
  },
})
