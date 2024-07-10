return {
	"olimorris/onedarkpro.nvim",
	"projekt0n/github-nvim-theme",
	"ellisonleao/gruvbox.nvim",
	"catppuccin/nvim",
	"gbprod/nord.nvim",
	"sainnhe/everforest",
	"shaunsingh/solarized.nvim",
	"folke/tokyonight.nvim",
	{ "rose-pine/neovim", name = "rose-pine" },
	"Mofiqul/dracula.nvim",
	-- lazy = false,
	-- priority = 1000,
	-- init = function()
	-- 	-- vim.cmd("colorscheme github_dark")
	-- 	vim.cmd("colorscheme onedark")
	-- end,
	{
		"f-person/auto-dark-mode.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.opt.background = "dark"
				vim.cmd("colorscheme catppuccin")
			end,
			set_light_mode = function()
				vim.opt.background = "light"
				vim.cmd("colorscheme catppuccin-latte")
			end,
		},
	},
}
