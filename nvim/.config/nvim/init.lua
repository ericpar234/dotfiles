---@diagnostic disable: undefined-global

-- =========================
-- Leader keys FIRST (lazy requires this before loading)
-- =========================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- =========================
-- Core options (kept from your config)
-- =========================
local o = vim.o

o.expandtab = true
o.smartindent = true
o.tabstop = 2
o.shiftwidth = 2

vim.opt.termguicolors = true
vim.opt.number = true

-- =========================
-- Bootstrap lazy.nvim
-- =========================
local fn = vim.fn
local lazypath = fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- Plugin specs (migrated from packer "use" blocks)
-- =========================
require('lazy').setup({
  -- mason + lspconfig
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim', dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' } },
  { 'neovim/nvim-lspconfig' },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
    },
  },
  {
    'SergioRibera/cmp-dotenv',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function()
      -- enable dotenv source when editing env files
      local group = vim.api.nvim_create_augroup('CmpDotenv', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        group = group,
        pattern = { '.env', '.env.*' },
        callback = function()
          require('cmp').setup.buffer({
            sources = require('cmp').config.sources({ { name = 'dotenv' } }),
          })
        end,
      })
    end,
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
  },

  -- Files & UI
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require(
        'nvim-tree').setup({})
    end
  },
  { 'tpope/vim-fugitive' },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns')
          .setup()
    end
  },
  { 'nvim-lualine/lualine.nvim' },
  { 'folke/which-key.nvim' },
  { 'romgrk/barbar.nvim',       dependencies = { 'nvim-tree/nvim-web-devicons' } },
  {
    'MeanderingProgrammer/markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    -- config = function() require('render-markdown').setup({ file_types = { 'markdown', 'copilot-chat' } }) end,
  },

  -- Telescope + extensions
  { 'nvim-telescope/telescope.nvim',              dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'nvim-telescope/telescope-fzf-native.nvim',   build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
  { 'nvim-telescope/telescope-fzf-writer.nvim' },
  { 'nvim-telescope/telescope-frecency.nvim' },
  { 'nvim-telescope/telescope-project.nvim' },
  { 'nvim-telescope/telescope-dap.nvim' },
  { 'nvim-telescope/telescope-file-browser.nvim', dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' } },
  { 'dharmx/telescope-media.nvim',                config = function() require('telescope').load_extension('media') end },
  { 'nvim-lua/popup.nvim' },
  { 'nvim-lua/plenary.nvim' },

  -- Colors/theme
  { 'catppuccin/nvim',                            name = 'catppuccin' },
  { 'feline-nvim/feline.nvim' },
  { 'bakudankun/pico-8.vim' },

  -- Directory buffer
  { 'stevearc/oil.nvim' },

  -- Command line / UI polish
  {
    'folke/noice.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
  },

  -- Tmux Navigator
  {
    "christoomey/vim-tmux-navigator",
  },

  -- Indent guides
  { 'lukas-reineke/indent-blankline.nvim' },

  -- LSP/UI extras
  { 'onsails/lspkind.nvim' },
  { 'folke/neodev.nvim' },

  -- GitHub
  { 'ldelossa/gh.nvim',                   dependencies = { 'ldelossa/litee.nvim' } },

  -- Copilot + Chat
  { 'zbirenbaum/copilot.lua' },
  { 'CopilotC-Nvim/CopilotChat.nvim',     dependencies = { 'nvim-lua/plenary.nvim', 'zbirenbaum/copilot.lua' } },

  -- TODO/diagnostics/folds/statuscol
  { 'folke/todo-comments.nvim',           dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'folke/trouble.nvim',                 dependencies = { 'nvim-tree/nvim-web-devicons' } },
  { 'kevinhwang91/nvim-ufo',              dependencies = { 'kevinhwang91/promise-async' } },
  { 'luukvbaal/statuscol.nvim' },

  -- Comments
  { 'numToStr/Comment.nvim',              config = function() require('Comment').setup() end },

  -- Rust
  { 'simrat39/rust-tools.nvim' },

  -- Zen
  { 'folke/zen-mode.nvim' },

  -- Dashboard
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('dashboard').setup({
        theme = 'hyper',
        change_to_vcs_root = true,
        shortcut_type = 'number',
        config = {
          week_header = { enable = true },
          project = { enable = false, limit = 10 },
          shortcut = {
            { icon = ' ', icon_hl = '@variable', desc = 'Files', group = 'Label', action = 'Telescope find_files', key = 'f' },
            { desc = ' Configuration', group = '@property', action = 'e ~/.config/nvim/init.lua', key = 'c' },
            { desc = ' dotfiles', group = 'Number', action = 'e ~/dotfiles', key = 'd' },
            { desc = 'Check Health', group = '@property', action = 'checkhealth', key = 'h', icon = ' ' },
            { desc = '󰊳 Update', group = '@property', action = 'Lazy sync', key = 'u' },
          },
          footer = { '' },
        },
      })
    end,
  },
}, {
  change_detection = { notify = false },
})

-- =========================
-- Your post-plugin config (mostly unchanged)
-- =========================

require('oil').setup({
  use_default_keymaps = false,
  view_options = { show_hidden = true },
  keymaps = { ["<CR>"] = 'actions.select' },
})

require('catppuccin').setup({
  flavor = 'macchiato',
  integrations = { treesitter = true, which_key = true },
})

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    package.loaded['feline'] = nil
    package.loaded['catppuccin.groups.integrations.feline'] = nil
    -- require('feline').setup { components = require('catppuccin.groups.integrations.feline').get(), }
  end,
})

require('nvim-web-devicons').setup({})

-- Telescope extensions
pcall(require('telescope').load_extension, 'project')
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'frecency')
pcall(require('telescope').load_extension, 'fzf_writer')
pcall(require('telescope').load_extension, 'noice')

local canned = require('telescope._extensions.media.lib.canned')
require('telescope').setup({
  defaults = {
    file_ignore_patterns = { '.git' },
    vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden' },
  },
  extensions = {
    media = { backend = 'chafa', on_confirm_single = canned.single.copy_path, on_confirm_muliple = canned.multiple.bulk_copy },
  },
})
vim.api.nvim_create_autocmd('FileType', { pattern = 'TelescopeResults', command = [[setlocal nofoldenable]] })

-- Copilot
require('copilot').setup({
  panel = {
    enabled = true,
    auto_refresh = true,
    keymap = { jump_prev = '[[', jump_next = ']]', accept = '<CR>', refresh = 'gr', open = '<M-CR>' },
    layout = { position = 'bottom', ratio = 0.4 },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = { accept = '<Tab>', accept_word = false, accept_line = false, next = '<M-j>', prev = '<M-k>' },
  },
  filetypes = { yaml = true, markdown = true, help = false, gitcommit = false, gitrebase = false, hgcommit = false, svn = false, cvs = false, ['.'] = false },
  copilot_node_command = 'node',
  server_opts_overrides = {},
})

vim.cmd.colorscheme('catppuccin')

-- which-key registrations
local wk = require('which-key')
local git_mappings = {
  { '<leader>g',  group = 'Git' },
  { '<leader>gb', '<cmd>Git blame<cr>',  desc = 'Blame' },
  { '<leader>gc', '<cmd>Git commit<cr>', desc = 'Commit' },
  { '<leader>gd', '<cmd>Git diff<cr>',   desc = 'Diff' },
  { '<leader>gl', '<cmd>Git log<cr>',    desc = 'Log' },
  { '<leader>gp', '<cmd>Git push<cr>',   desc = 'Push' },
  { '<leader>gr', '<cmd>Git rebase<cr>', desc = 'Rebase' },
  { '<leader>gs', '<cmd>Git<cr>',        desc = 'Status' },
}
local mappings = {
  { '<leader><leader>',  group = 'Find' },
  { '<leader><leader>W', '<cmd>Telescope live_grep<cr>',                 desc = 'Find Word' },
  { '<leader><leader>b', '<cmd>Telescope buffers<cr>',                   desc = 'Find Buffer' },
  { '<leader><leader>f', '<cmd>Telescope find_files<cr>',                desc = 'Find File' },
  { '<leader><leader>h', '<cmd>Telescope help_tags<cr>',                 desc = 'Find Help' },
  { '<leader><leader>m', '<cmd>Telescope media<cr>',                     desc = 'Find Media Files' },
  { '<leader><leader>n', '<cmd>Telescope noice<cr>',                     desc = 'Find Noice' },
  { '<leader><leader>p', '<cmd>Telescope project<cr>',                   desc = 'Find Project' },
  { '<leader><leader>r', '<cmd>Telescope oldfiles<cr>',                  desc = 'Find Recent File' },
  { '<leader><leader>s', '<cmd>Telescope frecency<cr>',                  desc = 'Find Frecency' },
  { '<leader><leader>t', '<cmd>Telescope treesitter<cr>',                desc = 'Find Treesitter' },
  { '<leader><leader>w', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'Find in Buffer' },
  { '<leader><leader>z', '<cmd>Telescope fzf writer<cr>',                desc = 'Find FZF Writer' },
  { '<leader>e',         '<cmd>NvimTreeToggle<cr>',                      desc = 'Toggle File Explorer' },
  { '<leader>t',         '<cmd>split | terminal<cr>',                    desc = 'Open Terminal' },
}
wk.add(git_mappings, { prefix = '<leader>' })
wk.add(mappings, { prefix = '<leader>' })

-- Window nav
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- Buffer nav
vim.api.nvim_set_keymap('n', '<leader>bn', ':bnext<CR>', { noremap = true, silent = true, desc = 'Next buffer' })
vim.api.nvim_set_keymap('n', '<leader>bp', ':bprevious<CR>', { noremap = true, silent = true, desc = 'Previous buffer' })
vim.api.nvim_set_keymap('n', '<leader>bd', ':bp|bd#<CR>', { noremap = true, silent = true, desc = 'Delete buffer' })
vim.api.nvim_set_keymap('n', '<leader>br', ':e#<CR>', { noremap = true, silent = true, desc = 'Restore buffer' })
vim.api.nvim_set_keymap('n', '<leader>bs', ':wincmd r<CR>', { noremap = true, silent = true, desc = 'Swap buffer' })

-- Tab-like buffer cycling
vim.api.nvim_set_keymap('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })

-- nvim-cmp
local lspkind = require('lspkind')
local cmp = require('cmp')

cmp.setup({
  snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'luasnip' }, { name = 'buffer' } }),
  formatting = {
    fields = { 'abbr', 'kind', 'menu' },
    expandable_indicator = true,
    format = lspkind.cmp_format({ mode = 'symbol', maxwidth = 50, ellipsis_char = '...', show_labelDetails = true }),
  },
})

-- mason & mason-lspconfig
require('mason').setup({ ui = { icons = { package_installed = '✓', package_pending = '➜', package_uninstalled = '✗' } } })
require('mason-lspconfig').setup({ automatic_installation = true, automatic_enable = false })

-- Ansible YAML detection
local function is_ansible(content)
  local ansible_keywords = { 'hosts:', 'tasks:', 'handlers:', 'vars:', 'include:', 'roles:', 'become:',
    'ansible.builtin.' }
  for _, keyword in ipairs(ansible_keywords) do if content:match(keyword) then return true end end
  return false
end

vim.api.nvim_create_autocmd('BufRead', {
  pattern = { '*.yml', '*.yaml' },
  callback = function(args)
    local lines = vim.api.nvim_buf_get_lines(args.buf, 0, 10, false)
    local content = table.concat(lines, '\n')
    vim.bo[args.buf].filetype = is_ansible(content) and 'yaml.ansible' or 'yaml'
  end,
})
vim.api.nvim_create_autocmd('BufNewFile', {
  pattern = { '*.yml', '*.yaml' },
  callback = function(args)
    local lines = vim.api.nvim_buf_get_lines(args.buf, 0, 10, false)
    local content = table.concat(lines, '\n')
    vim.bo[args.buf].filetype = is_ansible(content) and 'yaml.ansible' or 'yaml'
  end,
})

-- Zen Mode
vim.api.nvim_set_keymap('n', '<leader>Z', '<cmd>ZenMode<CR>', { noremap = true, silent = true, desc = 'Toggle Zen Mode' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'yaml.ansible',
  callback = function()
    require('lspconfig')['ansiblels'].setup({
      settings = { ansible = { ansible = { path = 'ansible' }, ansibleLint = { enabled = true, path = 'ansible-lint' }, python = { interpreterPath = 'python' } } },
    })
  end,
})

-- LSP capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
local default = lspconfig.util.default_config

default.capabilities = vim.tbl_deep_extend('force', default.capabilities or {}, capabilities)

-- Servers
lspconfig.jedi_language_server.setup({})
lspconfig.bashls.setup({})
lspconfig.clangd.setup({
  cmd = { 'clangd', '--background-index' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_dir =
      lspconfig.util.root_pattern('compile_commands.json', '.git')
})
lspconfig.cmake.setup({})
lspconfig.dockerls.setup({})
lspconfig.jsonls.setup({})
lspconfig.html.setup({})
lspconfig.zk.setup({})
lspconfig.lua_ls.setup({})
lspconfig.ansiblels.setup({})
lspconfig.quick_lint_js.setup({})
lspconfig.typescript_language_server.setup({})
lspconfig.yamlls.setup({})
lspconfig.gopls.setup({ cmd = { 'gopls', 'serve' } })

-- Diagnostics icons
--local signs = { Error = '', Warn = '', Hint = '', Info = ' ' }
--for type, icon in pairs(signs) do
--  vim.fn.sign_define('DiagnosticSign' .. type,
--    { text = icon, texthl = 'DiagnosticSign' .. type, numhl = 'DiagnosticSign' .. type })
--end


vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.HINT]  = "",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
})

-- Diagnostics mappings
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>Q', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Toggle Trouble' })

vim.keymap.set('n', '<leader>"', '<cmd>split<CR>', { desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>%', '<cmd>vsplit<CR>', { desc = 'Vertical split' })

-- LspAttach buffer-local keymaps
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = { buffer = ev.buf }
    opts.desc = 'Go to definition'; vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    opts.desc = 'Go to type declaration'; vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    opts.desc = 'Hover'; vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    opts.desc = 'Go to implementation'; vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    opts.desc = 'Signature help'; vim.keymap.set('n', '<C-g>', vim.lsp.buf.signature_help, opts)
    opts.desc = 'Add Workspace'; vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    opts.desc = 'Remove Workspace'; vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    opts.desc = 'List Workspaces'; vim.keymap.set('n', '<leader>wl',
      function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    opts.desc = 'Type definition'; vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    opts.desc = 'Rename'; vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    opts.desc = 'Code action'; vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    opts.desc = 'References'; vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    opts.desc = 'Format'; vim.keymap.set('n', '<leader>F', function() vim.lsp.buf.format({ async = true }) end, opts)
  end,
})

-- gitsigns (extended)
require('gitsigns').setup({
  current_line_blame = true,
  current_line_blame_opts = { virt_text = true, virt_text_pos = 'eol', delay = 1000 },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, opts)
      opts = opts or {}; opts.buffer = bufnr; vim.keymap.set(mode, l, r, opts)
    end
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      return '<Ignore>'
    end, { expr = true })
    map('n', '[c',
      function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true })
    map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage Hunk' })
    map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset Hunk' })
    map('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Stage Hunk' })
    map('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = 'Reset Hunk' })
    map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage Buffer' })
    map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo Stage Hunk' })
    map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset Buffer' })
    map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview Hunk' })
    map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { desc = 'Blame' })
    map('n', '<leader>htb', gs.toggle_current_line_blame, { desc = 'Toggle Blame' })
    map('n', '<leader>hd', gs.diffthis, { desc = 'Diff' })
    map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'Diff HEAD' })
    map('n', '<leader>htd', gs.toggle_deleted, { desc = 'Toggle Deleted' })
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end,
})
wk.add({ '<leader>h', group = 'GitSigns' })

-- indent-blankline (ibl)
require('ibl').setup()
require('ibl').overwrite({ exclude = { filetypes = { 'NvimTree', 'dashboard', 'lazy', 'TelescopePrompt', 'TelescopeResults' }, buftypes = { 'terminal', 'TelescopePrompt', 'TelescopeResults' } } })

-- noice
require('telescope').load_extension('noice')
vim.keymap.set('n', '<leader>nd', '<cmd>Noice dismiss<cr>', { desc = 'Dismiss noice' })
vim.keymap.set('n', '<leader>nh', '<cmd>Noice history<cr>', { desc = 'Noice history' })
require('noice').setup({
  lsp = { override = { ['vim.lsp.util.convert_input_to_markdown_lines'] = true, ['vim.lsp.util.stylize_markdown'] = true, ['cmp.entry.get_documentation'] = true, ['vim.ui.select'] = false, ['vim.ui.input'] = false } },
  cmdline = {
    format = {
      cmdline = { pattern = '^:', icon = '', lang = 'vim' },
      search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex', view = 'cmdline' },
      search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex', view = 'cmdline' },
      filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
      lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = '', lang = 'lua' },
      help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
      input = {},
      substitue = { kind = 'search', pattern = '^:%%?s/', icon = '', lang = 'regex', view = 'cmdline' },
    },
  },
  views = { cmdline_popup = { position = { row = '50%', col = '50%' }, border = { style = 'none', padding = { 1, 2 } }, win_options = { winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder' } }, popupmenu = { relative = 'editor', position = { row = '50%', col = 'auto' }, border = { style = 'none', padding = { 1, 0, -5, 0 } }, win_options = { winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder' } } },
  presets = { bottom_search = true, long_message_to_split = true, inc_rename = false, lsp_doc_border = false },
  routes = {
    { filter = { event = 'msg_show', find = 'written' },                                                                                                                                                    opts = { skip = true } },
    { filter = { event = 'msg_show', find = 'replace with' },                                                                                                                                               view = 'cmdline' },
    { filter = { event = 'msg_show', any = { { min_height = 5 }, { min_width = 200 } }, ['not'] = { kind = { 'confirm', 'confirm_sub', 'return_prompt', 'quickfix', 'search_count' } }, blocking = false }, view = 'messages',     opts = { stop = true } },
    { filter = { event = 'msg_show', any = { { find = '; after #%d+' }, { find = '; before #%d+' }, { find = 'fewer lines' } } },                                                                           view = 'messages',     opts = { skip = true } },
  },
})

-- GitHub integrations
require('litee.lib').setup()
require('litee.gh').setup({
  jump_mode = 'invoking',
  map_resize_keys = false,
  disable_keymaps = false,
  icon_set =
  'default',
  git_buffer_completion = true,
  keymaps = { open = '<CR>', expand = 'zo', collapse = 'zc', goto_issue = 'gd', details = 'd', submit_comment = '<cr>', actions = '<C-a>', resolve_thread = '<C-r>', goto_web = 'gx' }
})

-- CopilotChat
require('CopilotChat').setup({
  mappings = { reset = { normal = '<C-n>', insert = '<C-n>' } },
  window = { width = 0.3, height = 0.3 },
  model = 'gpt-4o-2024-11-20',
})
local function quickChat(selection)
  local input = vim.fn.input('Quick Chat: ')
  if input ~= '' then require('CopilotChat').ask(input, { selection = selection }) end
end
wk.add({ '<leader>cc', group = 'Copilot Chat' })
vim.keymap.set('n', '<leader>cce', '<cmd>CopilotChatExplain<cr>', { desc = 'Copilot Chat Explain' })
vim.keymap.set('n', '<leader>cct', '<cmd>CopilotChatToggle<cr>', { desc = 'Copilot Chat Toggle' })
vim.keymap.set('n', '<leader>ccq', function() quickChat(require('CopilotChat.select').buffer) end,
  { desc = 'Copilot Quick Chat' })
vim.keymap.set('v', '<leader>ccq', function() quickChat(require('CopilotChat.select').visual) end,
  { desc = 'Copilot Quick Chat' })
vim.keymap.set('v', '<leader>cce', '<cmd>CopilotChatExplain<cr>', { desc = 'Copilot Chat Explain' })
vim.keymap.set('n', '<leader>ccp',
  function()
    local actions = require('CopilotChat.actions'); require('CopilotChat.integrations.telescope').pick(actions
      .prompt_actions())
  end, { desc = 'Copilot Chat Prompt' })
vim.keymap.set('v', '<leader>ccp',
  function()
    local actions = require('CopilotChat.actions'); require('CopilotChat.integrations.telescope').pick(actions
      .prompt_actions())
  end, { desc = 'Copilot Chat Prompt' })
vim.keymap.set('n', '<leader>ccc', '<cmd>CopilotChatCommit<cr>', { desc = 'Copilot Chat Commit' })
vim.api.nvim_create_autocmd('BufEnter',
  {
    pattern = 'copilot-*',
    callback = function()
      vim.wo.number = false; vim.wo.relativenumber = false; vim.wo.signcolumn = 'no'; vim.wo.cursorline = false; vim.api
          .nvim_win_set_width(0, math.floor(vim.o.columns / 3))
    end
  })

-- todo-comments & trouble
require('todo-comments').setup({})
vim.keymap.set('n', '<leader><leader>td', '<cmd>TodoTelescope<cr>', { desc = 'Todo Telescope' })
vim.keymap.set('n', '<leader>Td', '<cmd>TodoTrouble<cr>', { desc = 'Todo Loc List' })
require('trouble').setup({})

-- UFO folds
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
local client_capabilities = vim.lsp.protocol.make_client_capabilities()
client_capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText, suffix, sufWidth, targetWidth, curWidth = {}, (' 󰁂 %d '):format(endLnum - lnum), 0, 0, 0
  sufWidth = vim.fn.strdisplaywidth(suffix)
  targetWidth = width - sufWidth
  for _, chunk in ipairs(virtText) do
    local chunkText, hlGroup = chunk[1], chunk[2]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if curWidth + chunkWidth < targetWidth then suffix = suffix .. string.rep(' ', targetWidth - curWidth - chunkWidth) end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, 'MoreMsg' })
  return newVirtText
end
require('ufo').setup({ fold_virt_text_handler = handler })

-- Terminal UI tweaks
vim.api.nvim_create_autocmd('TermOpen',
  {
    pattern = '*',
    callback = function()
      vim.wo.number = false; vim.wo.relativenumber = false; vim.o.laststatus = 0
    end
  })
vim.api.nvim_create_autocmd('TermClose',
  {
    pattern = '*',
    callback = function()
      vim.wo.number = true; vim.wo.relativenumber = true; vim.o.laststatus = 2
    end
  })

-- rust-tools
local rt = require('rust-tools')
rt.setup({
  server = {
    on_attach = function(bufnr)
      vim.keymap.set('n', '<Leader>K', rt.hover_actions.hover_actions, { buffer = bufnr }); vim.keymap.set('n',
        '<Leader>a',
        rt.code_action_group.code_action_group, { buffer = bufnr })
    end
  }
})

-- statuscol
local builtin = require('statuscol.builtin')
require('statuscol').setup({ segments = { { sign = { name = { '.*' }, text = { '.*' }, maxwidth = 1, colwidth = 1, auto = true, wrap = true }, click = 'v:lua.ScSa' }, { text = { builtin.lnumfunc, ' ' }, condition = { builtin.not_empty, true }, click = 'v:lua.ScLa' } } })

-- Formatting
vim.api.nvim_create_autocmd('FileType',
  { pattern = '*', callback = function() vim.opt_local.formatoptions:remove({ 'c', 'r', 'o' }) end })

-- Quieter startup
vim.opt.shortmess:append('I')

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- ensure the plugin doesn't add its own defaults
    vim.g.tmux_navigator_no_mappings = 1

    -- delete any earlier conflicting maps first
    pcall(vim.keymap.del, "n", "<C-h>")
    pcall(vim.keymap.del, "n", "<C-j>")
    pcall(vim.keymap.del, "n", "<C-k>")
    pcall(vim.keymap.del, "n", "<C-l>")
    pcall(vim.keymap.del, "t", "<C-h>")
    pcall(vim.keymap.del, "t", "<C-j>")
    pcall(vim.keymap.del, "t", "<C-k>")
    pcall(vim.keymap.del, "t", "<C-l>")

    -- rebind to the tmux navigator (normal + terminal mode)
    local map = vim.keymap.set
    local opts = { silent = true, desc = "tmux-navigator" }
    map({ "n", "t" }, "<C-h>", "<Cmd>TmuxNavigateLeft<CR>",  opts)
    map({ "n", "t" }, "<C-j>", "<Cmd>TmuxNavigateDown<CR>",  opts)
    map({ "n", "t" }, "<C-k>", "<Cmd>TmuxNavigateUp<CR>",    opts)
    map({ "n", "t" }, "<C-l>", "<Cmd>TmuxNavigateRight<CR>", opts)
    map({ "n", "t" }, "<C-\\>", "<Cmd>TmuxNavigatePrevious<CR>", opts)

    -- optional: some terminals send <C-h> as <BS>
    map({ "n", "t" }, "<BS>", "<Cmd>TmuxNavigateLeft<CR>", { silent = true, desc = "tmux-left (bs)" })
  end,
})
