return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Rust
    use 'neovim/nvim-lspconfig'
    use 'simrat39/rust-tools.nvim'
    use {
        'saecki/crates.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('crates').setup()
        end,
    }

    -- cmp
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/nvim-cmp'

    use {
        'jose-elias-alvarez/null-ls.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    }

    -- use 'hrsh7th/cmp-vsnip'
    -- use 'hrsh7th/vim-vsnip'
    use 'L3MON4D3/LuaSnip'
    use "rafamadriz/friendly-snippets"
    use { 'saadparwaiz1/cmp_luasnip' }

    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    -- Debugging
    use 'nvim-lua/plenary.nvim'
    use 'mfussenegger/nvim-dap'
    use { 'mfussenegger/nvim-dap-python', branch = "multi-session" }
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use { 'williamboman/mason.nvim' }
    use { 'williamboman/mason-lspconfig.nvim' }

    -- Color
    use 'doums/darcula'
    use { "derfetzer/darcula-solid.nvim", branch = "lsp-reference", requires = "rktjmp/lush.nvim" }
    use "EdenEast/nightfox.nvim"
    use 'folke/tokyonight.nvim'
    use { "ellisonleao/gruvbox.nvim" }

    -- Other
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use {
        'lewis6991/gitsigns.nvim',
        -- tag = 'release' -- To use the latest release
    }
    use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }
    use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons' }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    use 'simrat39/symbols-outline.nvim'
    use 'lukas-reineke/indent-blankline.nvim'
    if vim.fn.has("win32") == 0 then
        use {
            'rmagatti/auto-session',
            config = function()
                require('auto-session').setup {}
            end
        }
    end
    use { 'akinsho/toggleterm.nvim', tag = 'v2.*' }
    use 'ggandor/leap.nvim'
    use({
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    })
    use {
        "derfetzer/pytask.nvim",
        config = function() require("pytask").setup() end
    }
    use { 'rafcamlet/nvim-luapad', requires = "antoinemadec/FixCursorHold.nvim" }

    -- Telescope
    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' }, { "nvim-telescope/telescope-live-grep-args.nvim" } } }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'nvim-telescope/telescope-ui-select.nvim' }

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }

end)
