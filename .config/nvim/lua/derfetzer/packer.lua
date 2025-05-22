return {
    -- Rust
    "neovim/nvim-lspconfig",
    {
        'mrcjkb/rustaceanvim',
        version = '^6', -- Recommended
        lazy = false,   -- This plugin is already lazy
    },
    {
        "saecki/crates.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            -- Do nothing here since LSP functions cannot be imported at this moment
        end,
    },
    -- Wait for fix of https://github.com/nvim-java/nvim-java/issues/384
    -- "nvim-java/nvim-java",

    -- cmp
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/nvim-cmp",

    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- "hrsh7th/cmp-vsnip",
    -- "hrsh7th/vim-vsnip",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "saadparwaiz1/cmp_luasnip",

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },

    -- Debugging
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    { "rcarriga/nvim-dap-ui",   dependencies = { "mfussenegger/nvim-dap" } },

    { "williamboman/mason.nvim" },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
            require("mason-tool-installer").setup {
                ensure_installed = {
                    "black",
                    "clangd",
                    "codelldb",
                    "glow",
                    "hadolint",
                    "lua-language-server",
                    "basedpyright",
                    "ruff",
                    "rust-analyzer",
                    "selene",
                    "stylua",
                },
                auto_update = false,
                run_on_start = true,
            }
        end
    },

    -- Test
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim"
        },
    },
    "nvim-neotest/neotest-python",
    "rouge8/neotest-rust",

    -- Color
    "doums/darcula",
    { "briones-gabriel/darcula-solid.nvim", dependencies = "rktjmp/lush.nvim" },
    "EdenEast/nightfox.nvim",
    "folke/tokyonight.nvim",
    { "ellisonleao/gruvbox.nvim" },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
    },

    -- Other
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "lewis6991/gitsigns.nvim",
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
        },
        config = true,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to the default settings
            -- refer to the configuration section below
        }
    },
    "anuvyklack/hydra.nvim",
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    },
    "mbbill/undotree",
    { "akinsho/bufferline.nvim",             version = "v4.*", dependencies = "nvim-tree/nvim-web-devicons" },
    {
        'stevearc/aerial.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
    },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl",     opts = {} },
    {
        "rmagatti/auto-session",
        config = function()
            require("auto-session").setup {
                cwd_change_handling = true
            }
        end
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            shell = "nu"
        }
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    "ggandor/leap.nvim",
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to defaults
            })
        end
    },
    {
        "derfetzer/pytask.nvim",
        config = function() require("pytask").setup() end
    },
    { "rafcamlet/nvim-luapad",                    dependencies = "antoinemadec/FixCursorHold.nvim" },
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("trouble").setup {}
        end
    },
    "famiu/bufdelete.nvim",
    {
        "ellisonleao/glow.nvim",
        config = true,
        cmd = "Glow",
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope-live-grep-args.nvim" } }
    },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            -- NOTE: additional parser
            { "nushell/tree-sitter-nu" },
        },
        build = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
    },
    "nvim-treesitter/nvim-treesitter-context",

    {
        "ktunprasert/gui-font-resize.nvim",
        config = function() require("gui-font-resize").setup({ default_size = 10 }) end,
    },
}
