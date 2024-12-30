return {
	{
		"projekt0n/github-nvim-theme",
	},
	{
		"rebelot/kanagawa.nvim",
		priority = 1000, -- Ensure it loads first
		config = function()
			vim.cmd("colorscheme kanagawa")
		end,
	},
	{
		"olimorris/onedarkpro.nvim",
	},
	{
		"f-person/auto-dark-mode.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.cmd("colorscheme kanagawa")
				vim.opt.background = "dark"
			end,
			set_light_mode = function()
				vim.cmd("colorscheme github_light")
				-- vim.opt.background = "light"
			end,
		},
	},
}
