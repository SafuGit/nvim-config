-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {

    {
        'mrjones2014/legendary.nvim',
        -- since legendary.nvim handles all your keymaps/commands,
        -- its recommended to load legendary.nvim before other plugins
        priority = 10000,
        lazy = false,
        -- sqlite is only needed if you want to use frecency sorting
        -- dependencies = { 'kkharji/sqlite.lua' }
    },

    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- add your plugins here
    { 'echasnovski/mini.nvim', version = false },

    { 'williamboman/mason.nvim',
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",},

    {
        "NeogitOrg/neogit",
        dependencies = {
          "nvim-lua/plenary.nvim",         -- required
          "sindrets/diffview.nvim",        -- optional - Diff integration
      
          -- Only one of these is needed, not both.
          "nvim-telescope/telescope.nvim", -- optional
          "ibhagwan/fzf-lua",              -- optional
        },
        config = true
      },

    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },

    {"smolck/command-completion.nvim"},

    {
        'stevearc/dressing.nvim',
        opts = {},
    },

    { "CRAG666/code_runner.nvim", config = true },

    {'akinsho/toggleterm.nvim', version = "*", config = true},

    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

      {
        "sontungexpt/url-open",
        event = "VeryLazy",
        cmd = "URLOpenUnderCursor",
        config = function()
            local status_ok, url_open = pcall(require, "url-open")
            if not status_ok then
                return
            end
            url_open.setup ({})
        end,
    },

    {
        'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
      },

    {'m4xshen/autoclose.nvim'},

    {'junegunn/rainbow_parentheses.vim'}

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- Require Setups
require('command-completion').setup()
require('mason').setup()
require('mini.completion').setup({})
require('mini.comment').setup({})
require('mini.notify').setup({})
require('mini.icons').setup({})
require('mini.statusline').setup({})
require('mini.sessions').setup({})
require('autoclose').setup({})

local status, starter = pcall(require, "mini.starter")
if not status then
	return
end

require('mini.starter').setup({
    content_hooks = {
		starter.gen_hook.adding_bullet(""),
		starter.gen_hook.aligning("center", "center"),
	},
	evaluate_single = true,
	footer = os.date(),
	-- header = table.concat({
	-- 	[[  /\ \▔\___  ___/\   /(●)_ __ ___  ]],
	-- 	[[ /  \/ / _ \/ _ \ \ / / | '_ ` _ \ ]],
	-- 	[[/ /\  /  __/ (_) \ V /| | | | | | |]],
	-- 	[[\_\ \/ \___|\___/ \_/ |_|_| |_| |_|]],
	-- 	[[───────────────────────────────────]],
	-- }, "\n"),

    header = table.concat({
        [[   ____     ___    _   ___     ]],
        [[  / __/__ _/ _/_ _| | / (_)_ _ ]],
        [[ _\ \/ _ `/ _/ // / |/ / /  ' \]],
        [[/___/\_,_/_/ \_,_/|___/_/_/_/_/]],
        [[───────────────────────────────]],
    }, "\n"),

	query_updaters = [[abcdefghilmoqrstuvwxyz0123456789_-,.ABCDEFGHIJKLMOQRSTUVWXYZ]],
	items = {
        starter.sections.recent_files(10, false),
        -- Use this if you set up 'mini.sessions'
        starter.sections.sessions(5, true),
		{ action = "Lazy", name = "Update Plugins", section = "Plugins" },
        { action = "Telescope find_files", name = "Find Files", section = "Telescope"},
        { action = "Telescope file_browser", name = "File Browser", section = "Telescope"},

		-- { action = "enew", name = "E: New Buffer", section = "Builtin actions" },
		-- { action = "qall!", name = "Q: Quit Neovim", section = "Builtin actions" },
        starter.sections.builtin_actions(),
	},
})

vim.cmd([[
  augroup MiniStarterJK
    au!
    au User MiniStarterOpened nmap <buffer> j <Cmd>lua MiniStarter.update_current_item('next')<CR>
    au User MiniStarterOpened nmap <buffer> k <Cmd>lua MiniStarter.update_current_item('prev')<CR>
    au User MiniStarterOpened nmap <buffer> <C-p> <Cmd>Telescope find_files<CR>
    au User MiniStarterOpened nmap <buffer> <C-n> <Cmd>Telescope file_browser<CR>
    au User MiniStarterOpened nmap <buffer> <C-t> <Cmd>ToggleTerm<CR>
    au User MiniStarterOpened nmap <buffer> <C-g> <Cmd>Neogit<CR>
    au User MiniStarterOpened nmap <buffer> <C-f> <Cmd>Oil<CR>
  augroup END
]])

-- LSP

require('mason-lspconfig').setup({
    ensure_installed = {
        'ruff_lsp',
        'rust_analyzer'
    },
})

require("lspconfig").rust_analyzer.setup({
    diagnostics = {
        update_in_insert = true
    }
})

require("lspconfig").ruff_lsp.setup({
    diagnostics = {
        update_in_insert = true
    }
})


-- Configs

vim.cmd.colorscheme "catppuccin-mocha"
local bufferline = require('bufferline')
bufferline.setup({
    options = {
        -- or you can combine these e.g.
        -- style_preset = {
        --     bufferline.style_preset.no_italic,
        --     bufferline.style_preset.no_bold
        -- },
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                separator = true -- use a "true" to enable the default, or set your own character
            }
        },

        diagnostics = "nvim_lsp",

        }
    })

require('dressing').setup({
    select = {
        get_config = function(opts)
            if opts.kind == 'legendary.nvim' then
                return {
                    telescope = {
                    sorter = require('telescope.sorters').fuzzy_with_index_bias({})
                    }
                }
            else
                return {}
            end
        end
        }
    })

-- Keybindings
require('legendary').setup({
    extensions = {
        lazy_nvim = true
    },

    keymaps = {
        { '<leader>ff', ':Telescope find_files', description = 'Telescope Find files' },
        { '<leader>fb', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', description = 'Telescope file browser' },
        {'<leader>tt', ':Telescope Commands'},
        -- {'<leader>r', ':RunCode', description = 'Run Code'},
        -- {'<leader>rf', ':RunFile', description = 'Run Current File'},
        -- {'<leader>rft', ':RunFile tab', desciptrion = 'Run Current File in tab'},
        -- {'<leader>rp', ':RunProject', description = 'Run Current Project'},
        -- {'<leader>rc', ':RunClose', description = 'Run And Close'},
    }
})

vim.keymap.set('n', '<leader>l', ':Legendary<CR>')
vim.keymap.set('n', '<leader>ff', ':Telescope find_files')
vim.keymap.set('n', '<leader>fb', ':Telescope file_browser path=%:p:h select_buffer=true<CR>')
vim.keymap.set('n', '<leader>tt', ':Telescope commands')
vim.keymap.set('n', '<C-t>', ':ToggleTerm<CR>') 
vim.keymap.set('n', '<C-g>', ':Neogit<CR>')
vim.keymap.set('n', '<C-f>', ':Oil<CR>')
vim.keymap.set('n', '<leader>r', ':q<CR>')
vim.keymap.set('n', '<C-s>', ':w<CR>')

-- vim.keymap.set('n', '<leader>r', ':RunCode<CR>', { noremap = true, silent = false })
-- vim.keymap.set('n', '<leader>rf', ':RunFile<CR>', { noremap = true, silent = false })
-- vim.keymap.set('n', '<leader>rft', ':RunFile tab<CR>', { noremap = true, silent = false })
-- vim.keymap.set('n', '<leader>rp', ':RunProject<CR>', { noremap = true, silent = false })
-- vim.keymap.set('n', '<leader>rc', ':RunClose<CR>', { noremap = true, silent = false })
-- vim.keymap.set('n', '<leader>crf', ':CRFiletype<CR>', { noremap = true, silent = false })
-- vim.keymap.set('n', '<leader>crp', ':CRProjects<CR>', { noremap = true, silent = false })