local masonPackages = require('mason-packages')
local servers = masonPackages.servers
local daps = masonPackages.daps
local formattersAndLinters = masonPackages.formattersAndLinters
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- PLUGINS
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  -- Terminal based LazyGit
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        open_mapping = [[<C-\>]],
      }
    end,
  },

  -- Detect tabstop and shiftwidth automatically
  -- 'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {
      plugins = {
        marks = false,
        registers = false,
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = false,
          nav = false,
          z = false,
          g = false,
        },
      },
      layout = {
        height = { min = 4, max = 10 },
        align = 'center',
      },
    },
    dependencies = {
      -- icons
      'echasnovski/mini.icons',
    },
  },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      -- on_attach = function(bufnr)
      -- vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
      -- vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
      -- vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      -- end,
    },
  },

  {
    -- Theme inspired by Atom
    'bluz71/vim-moonfly-colors',
    priority = 1000,
    name = 'moonfly',
    lazy = false,
    config = function()
      vim.cmd.colorscheme 'moonfly'
      vim.cmd 'hi normal guibg=none ctermbg=none'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'moonfly',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = 'ibl',
    opts = {
      indent = { char = '┇' },
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',         opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'windwp/nvim-ts-autotag',
    },
    build = ':TSUpdate',
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       This is an example of adding plugins from the lua/kickstart/plugins/*.lua directory.
  -- require 'kickstart.plugins.YourPlugin',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
  -- Quickly switch between bookmarked buffers
  { 'ThePrimeagen/harpoon' },

  -- Add an emoji search to telescope
  { 'xiyaowong/telescope-emoji.nvim' },

  -- Persist sessions to return to later
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    config = function()
      require('persistence').setup {
        dir = vim.fn.expand(vim.fn.stdpath 'config' .. '/session/'),
        options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
      }
    end,
  },

  -- Reordering of long lines
  {
    'AckslD/nvim-trevj.lua',
    config = function()
      require('trevj').setup()
    end,
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- Virtual Environment selector for python
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
    branch = 'regexp',
    opts = {
      name = { 'venv', '.venv' },
    },
    event = 'VeryLazy',
  },

  -- Autoclosing features
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  -- File tree
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
        view = {
          number = true,
          relativenumber = true,
          width = 40,
          float = {
            enable = false,
            open_win_config = function()
              local gwidth = vim.api.nvim_list_uis()[1].width
              local gheight = vim.api.nvim_list_uis()[1].height
              local width = math.floor(gwidth * 0.8)
              local height = math.floor(gheight * 0.8)

              return {
                border = 'rounded',
                relative = 'editor',
                width = width,
                height = height,
                row = (gheight - height) * 0.3,
                col = (gwidth - width) * 0.5,
              }
            end,
          },
        },
        filters = {
          git_ignored = false,
        },
      }
    end,
  },

  -- Beautify Tabs
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
  },

  -- Extend LSP with formatters and linters

  -- Adding debugger
  {
    'mfussenegger/nvim-dap',
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
    config = function(_, opts)
      require('dapui').setup(opts)
    end,
  },
  {
    'leoluz/nvim-dap-go',
    ft = 'go',
    dependencies = 'mfussenegger/nvim-dap',
    config = function(_, opts)
      require('dap-go').setup(opts)
    end,
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
    },
    opts = {
      handlers = {
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
        codelldb = function(config)
          config.configurations[1]['args'] = function()
            local args_string = vim.fn.input 'Input arguments: '
            return vim.split(args_string, ' ')
          end
          require('mason-nvim-dap').default_setup(config)
        end,
      },
    },
  },
}, {})

-- VIM GLOBALS
-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
vim.o.pumheight = 10

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.guicursor = ''
vim.o.smartindent = true
vim.o.wrap = false
vim.o.incsearch = true
vim.o.scrolloff = 8
vim.o.colorcolumn = '80'
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- PLUGINS CONFIG
-- [[ Basic Keymaps ]]

-- set which-key variable for all future bindings
local wk = require 'which-key'

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Debugger ]]
wk.add {
  { "<leader>d", group = "Debug" },
  { "<leader>db", "<cmd>DapToggleBreakpoint<CR>", desc = "Toggle Breakpoint" },
  { "<leader>dc", "<cmd>DapContinue<CR>", desc = "Continue" },
  { "<leader>dg",
    function()
      require('dap-go').debug_test()
    end, desc = "Debug Go Test" },
  { "<leader>dh", "<cmd>DapStepOut<CR>", desc = "Step Out" },
  { "<leader>dl", "<cmd>DapStepInto<CR>", desc = "Step Into" },
  { "<leader>do", "<cmd>DapStepOver<CR>", desc = "Step Over" },
  { "<leader>dq", "<cmd>DapTerminate<CR>", desc = "Quit Debugger" },
  { "<leader>dr", "<cmd>DapToggleRepl<CR>", desc = "REPL" },
  { "<leader>ds",
    function()
      require('dapui').toggle()
    end, desc = "Toggle Debug Window" },
}

local dap, dapui = require 'dap', require 'dapui'
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

-- [[ Configure null-ls ]]

-- Disable tsserver formatting
require('lspconfig').ts_ls.setup {
  capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
  end,
}

-- [[ Configure bufferline ]]
require('bufferline').setup {}

wk.add({
  { "<leader>b", group = "Buffer" },
  { "<leader>bb", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous Tab" },
  { "<leader>bh", "<C-w>s", desc = "Split Horizontal" },
  { "<leader>bj", "<cmd>BufferLinePick<CR>", desc = "Jump to Buffer" },
  { "<leader>bn", "<cmd>BufferLineCycleNext<CR>", desc = "Next Tab" },
  { "<leader>bo", "<cmd>BufferLineCloseLeft<CR><cmd>BufferLineCloseRight<CR>", desc = "Close All Other Tabs" },
  { "<leader>bv", "<C-w>v", desc = "Split Vertical" },
  { "<leader>c", "<cmd>bdelete! %<CR>", desc = "Close Tab" },
})

-- [[ Configure nvim-tree ]]
-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
--   pattern = { "*" },
--   command = ':silent! Explore'
-- })

-- [[ Condfigure trevj ]]
wk.add({
  { "<leader>j", function() require('trevj').format_at_cursor() end, desc = "Create line Breaks" },
})

-- [[ Configure harpoon ]]
local mark = require 'harpoon.mark'
local ui = require 'harpoon.ui'

wk.add({
  { "<leader>h", group = "Harpoon/Highlighting" },
  { "<leader>ha", mark.add_file, desc = "Add File to Harpoon" },
  { "<leader>he", ui.toggle_quick_menu, desc = "Harpoon Explorer" },
  { "<leader>hh", "<cmd>noh<CR>", desc = "Remove Highlighting" },
})

vim.keymap.set('n', '<C-h>', function()
  ui.nav_file(1)
end)
vim.keymap.set('n', '<C-t>', function()
  ui.nav_file(2)
end)

-- [[ Configure markdown-preview ]]
wk.add({
  { "<leader>m", group = "Markdown" },
  { "<leader>mp", "<Plug>MarkdownPreview", desc = "Markdown Preview" },
  { "<leader>ms", "<Plug>MarkdownPreviewStop", desc = "Markdown Preview Stop" },
})

-- [[ Configure persistence ]]
wk.add({
  { "<leader>S", group = "Sessions" },
  { "<leader>SQ", "<cmd>lua require('persistence').stop()<cr>", desc = "Quit without saving session" },
  { "<leader>Sc", "<cmd>lua require('persistence').load()<cr>", desc = "Restore last session for current dir" },
  { "<leader>Sl", "<cmd>lua require('persistence').load({ last = true })<cr>", desc = "Restore last session" },
  { "<leader>Sq", "<cmd>qa<cr>", desc = "Quit with saving" },
})

-- [[ Configure NvimTree ]]
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Open File Tree' })

-- [[ Configure ToggleTerm ]]
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', '<esc>', opts)
  vim.keymap.set('t', '<C-[>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'

local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new {
  cmd = 'lazygit',
  hidden = true,
  dir = 'git_dir',
  direction = 'float',
  float_opts = {
    border = 'none',
    width = 100000,
    height = 100000,
  },
  on_open = function(term)
    vim.cmd 'startinsert!'
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
  end,
  -- function to run on closing the terminal
  on_close = function() end,
  count = 99,
}

function Lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap('n', '<leader>gg', '<cmd>lua Lazygit_toggle()<CR>',
  { desc = 'Lazygit', noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-1>', '<cmd>ToggleTerm 1 direction=horizontal dir=%:p:h<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-2>', '<cmd>ToggleTerm 2 direction=vertical dir=%:p:h<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-3>', '<cmd>ToggleTerm 3 direction=float dir=%:p:h<CR>',
  { noremap = true, silent = true })

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--hidden',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '-g',
      '!**/.git/*',
      '-g',
      '!**/node_modules/*',
      '-u',
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      find_command = {
        'rg',
        '--files',
        '--hidden',
        '-g',
        '!**/.git/*',
        '-g',
        '!**/node_modules/*',
        '-u',
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'emoji')

-- See `:help telescope.builtin`
-- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
-- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sg', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
-- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>st', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>se', '<cmd>Telescope emoji<CR>', { desc = '[S]earch [E]mojis' })

-- [[ Configure Comment ]]
require('Comment').setup {
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'markdown' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,
  autotag = {
    enable = true,
  },
  enable_autocmd = false,

  highlight = { enable = true },
  indent = { enable = false },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = false,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>lk', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<leader>lj', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>lm', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>ll', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>lr', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>lc', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gs', '<cmd>ClangdSwitchSourceHeader<cr>', 'Switch Source/Header (C/C++)')
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>lD', vim.lsp.buf.type_definition, 'Type [D]efinition')
  -- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  -- nmap('<leader>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, '[W]orkspace [L]ist Folders')

  nmap('<leader>lf', vim.lsp.buf.format, 'Format Current Buffer')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.

-- Setup neovim lua configuration
require('neodev').setup {
  library = { plugins = { 'nvim-dap-ui' }, types = true },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

-- Add Mason DAPs here to auto-install them
require('mason-nvim-dap').setup {
  ensure_installed = daps,
}

-- Add any remaining Mason installs here, mainly formatters and linters
local registry = require 'mason-registry'

registry.refresh(function()
  for _, pkg_name in ipairs(formattersAndLinters) do
    local pkg = registry.get_package(pkg_name)
    if not pkg:is_installed() then
      pkg:install()
    end
  end
end)

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}
local cmp_autopairs = require 'nvim-autopairs.completion.cmp'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<Enter>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      -- select = true,
    },
    -- ['<Tab>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   elseif luasnip.expand_or_locally_jumpable() then
    --     luasnip.expand_or_jump()
    --   else
    --     fallback()
    --   end
    -- end, { 'i', 's' }),
    -- ['<S-Tab>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_prev_item()
    --   elseif luasnip.locally_jumpable(-1) then
    --     luasnip.jump(-1)
    --   else
    --     fallback()
    --   end
    -- end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

-- KEYMAPS
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', '<M-j>', '<cmd>m+<CR>==')
vim.keymap.set('n', '<M-k>', '<cmd>m-2<CR>==')
vim.keymap.set('v', '<M-j>', ":'<,'>m '>+1<CR>gv=gv")
vim.keymap.set('v', '<M-k>', ":'<,'>m '<-2<CR>gv=gv")
vim.keymap.del('n', 'gc')
vim.keymap.del('n', 'gb')

wk.add {
  { "gb", group = 'Blockwise Comment' },
  { "gc", group = 'Linewise Comment' },
}

wk.add({
  { "<leader>g", group = "Git" },
  { "<leader>k", group = "Code Actions" },
  { "<leader>kc", "<cmd>!clang++ -Wall -std=c++14 -Wextra -pedantic -o %:p:h/app %<CR>", desc = "Compile C++" },
  { "<leader>kd", "<cmd>!clang++ -Wall -std=c++14 -Wextra -pedantic -g -o %:p:h/app %<CR>", desc = "Compile C++ Debug" },
  { "<leader>km", "<cmd>!make -C %:p:h<CR>", desc = "Run Make (Current Dir)" },
  { "<leader>l", group = "LSP" },
  { "<leader>p", group = "System Paste" },
  { "<leader>pP", '"+P', desc = "System Paste Above" },
  { "<leader>pp", '"+p', desc = "System Paste Below" },
  { "<leader>pv", "<cmd>Ex<CR>", desc = "View Files" },
  { "<leader>q", "<cmd>q<CR>", desc = "Quit" },
  { "<leader>r", "<cmd>edit<CR>", desc = "Refresh File" },
  { "<leader>s", group = "Search" },
  { "<leader>v", '"_d', desc = "Void Delete" },
  { "<leader>w", "<cmd>w<CR>", desc = "Save" },
  { "<leader>x", "<cmd>!chmod +x %<CR>", desc = "Make Executable" },
  { "<leader>y", group = "System Yank" },
  { "<leader>yY", '"+Y', desc = "System Yank Entire Line" },
  { "<leader>yy", '"+y', desc = "System Yank" },
})

wk.add({
  {
    mode = { "v" },
    { "<leader>v", '"_d', desc = "Void Delete" },
    { "<leader>y", group = "System Yank" },
    { "<leader>yy", '"+y', desc = "System Yank" },
  },
  { "<leader>p", group = "System Paste", mode = "x" },
  { "<leader>pd", '"_dp', desc = "Delete to Void Paste", mode = "x" },
})

-- CLEAN UP --
--------------
vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
  pattern = { '*' },
  command = '!eslint_d stop',
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
