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
    opts = {
      char = '┇',
      show_trailing_blankline_indent = false,
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
    'iamcco/markdown-preview.nvim',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },

  -- Virtual Environment selector for python
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim' },
    config = true,
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
  {
    'JulesVerne22/null-ls.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
  },

  -- Adding debugger
  {
    'mfussenegger/nvim-dap',
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = 'mfussenegger/nvim-dap',
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
      'mfussenegger/nvim-dap'
    },
    opts = {
      handlers = {}
    }
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
wk.register {
  ['<leader>d'] = {
    name = 'Debug',
    c = { '<cmd>DapContinue<CR>', 'Continue' },
    o = { '<cmd>DapStepOver<CR>', 'Step Over' },
    l = { '<cmd>DapStepInto<CR>', 'Step Into' },
    h = { '<cmd>DapStepOut<CR>', 'Step Out' },
    b = { '<cmd>DapToggleBreakpoint<CR>', 'Toggle Breakpoint' },
    r = { '<cmd>DapToggleRepl<CR>', 'REPL' },
    g = {
      function()
        require('dap-go').debug_test()
      end,
      'Debug Go Test',
    },
    q = { '<cmd>DapTerminate<CR>', 'Quit Debugger' },
    s = {
      function()
        require('dapui').toggle()
      end,
      'Toggle Debug Window',
    },
  },
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
local null_ls = require 'null-ls'
null_ls.setup {
  sources = {
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.diagnostics.flake8.with {
      extra_args = { '--extend-ignore', 'E501' },
    },
    null_ls.builtins.formatting.black.with {
      extra_args = { '--fast' },
    },
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.clang_format.with {
      extra_args = { '--style="{BasedOnStyle: llvm, IndentWidth: 4, TabWidth: 4}"' }
    },
  },
}

-- [[ Configure bufferline ]]
require('bufferline').setup {}

wk.register({
  b = {
    name = 'Buffer',
    b = { '<cmd>BufferLineCyclePrev<CR>', 'Previous Tab' },
    n = { '<cmd>BufferLineCycleNext<CR>', 'Next Tab' },
    j = { '<cmd>BufferLinePick<CR>', 'Jump to Buffer' },
    o = { '<cmd>BufferLineCloseLeft<CR><cmd>BufferLineCloseRight<CR>', 'Close All Other Tabs' },
    v = { '<C-w>v', 'Split Vertical' },
    h = { '<C-w>s', 'Split Horizontal' },
  },
  c = { '<cmd>bdelete! %<CR>', 'Close Tab' },
}, { prefix = '<leader>' })

-- [[ Configure nvim-tree ]]
-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
--   pattern = { "*" },
--   command = ':silent! Explore'
-- })

-- [[ Condfigure trevj ]]
wk.register {
  ['<leader>j'] = {
    function()
      require('trevj').format_at_cursor()
    end,
    'Create Line Breaks',
  },
}

-- [[ Configure harpoon ]]
local mark = require 'harpoon.mark'
local ui = require 'harpoon.ui'

wk.register {
  ['<leader>h'] = {
    name = 'Harpoon/Highlighting',
    a = { mark.add_file, 'Add File to Harpoon' },
    e = { ui.toggle_quick_menu, 'Harpoon Explorer' },
    h = { '<cmd>noh<CR>', 'Remove Highlighting' },
  },
}

vim.keymap.set('n', '<C-h>', function()
  ui.nav_file(1)
end)
vim.keymap.set('n', '<C-t>', function()
  ui.nav_file(2)
end)

-- [[ Configure markdown-preview ]]
wk.register({
  m = {
    name = 'Markdown',
    p = { '<Plug>MarkdownPreview', 'Markdown Preview' },
    s = { '<Plug>MarkdownPreviewStop', 'Markdown Preview Stop' },
  },
}, { prefix = '<leader>' })

-- [[ Configure persistence ]]
wk.register({
  S = {
    name = 'Sessions',
    c = { "<cmd>lua require('persistence').load()<cr>", 'Restore last session for current dir' },
    l = { "<cmd>lua require('persistence').load({ last = true })<cr>", 'Restore last session' },
    q = { '<cmd>qa<cr>', 'Quit with saving' },
    Q = { "<cmd>lua require('persistence').stop()<cr>", 'Quit without saving session' },
  },
}, { prefix = '<leader>' })

-- [[ Configure NvimTree ]]
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Open File Tree' })

-- [[ Configure ToggleTerm ]]
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<C-]', [[<C-\><C-n>]], opts)
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
  on_open = function()
    vim.cmd 'startinsert!'
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
vim.api.nvim_set_keymap('n', '<M-1>', '<cmd>ToggleTerm 1 direction=horizontal<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-2>', '<cmd>ToggleTerm 2 direction=vertical<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<M-3>', '<cmd>ToggleTerm 3 direction=float<CR>', { noremap = true, silent = true })

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
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

-- vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
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
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,
  autotag = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },

  highlight = { enable = true },
  indent = { enable = true },
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
local servers = {
  clangd = {},
  gopls = {},
  pyright = {},
  rust_analyzer = {},
  tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

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

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

require("mason-nvim-dap").setup({
  ensure_installed = {
    "delve",
    "codelldb"
  }
})

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

wk.register({
  q = { '<cmd>q<CR>', 'Quit' },
  w = { '<cmd>w<CR>', 'Save' },
  g = { name = 'Git' },
  l = { name = 'LSP' },
  r = { '<cmd>edit<CR>', 'Refresh File'},
  s = { name = 'Search' },
  p = {
    name = 'System Paste',
    p = { '"+p', 'System Paste Below' },
    P = { '"+P', 'System Paste Above' },
    v = { '<cmd>Ex<CR>', 'View Files' },
  },
  y = {
    name = 'System Yank',
    y = { '"+y', 'System Yank' },
    Y = { '"+Y', 'System Yank Entire Line' },
  },
  v = { '"_d', 'Void Delete' },
  x = { '<cmd>!chmod +x %<CR>', 'Make Executable' },
}, { prefix = '<leader>' })

wk.register({
  p = {
    name = 'System Paste',
    d = { '"_dP', 'Delete to Void Paste', mode = 'x' },
    mode = 'x',
  },
  y = {
    name = 'System Yank',
    y = { '"+y', 'System Yank' },
    mode = 'v',
  },
  v = { '"_d', 'Void Delete', mode = 'v' },
}, { prefix = '<leader>' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
