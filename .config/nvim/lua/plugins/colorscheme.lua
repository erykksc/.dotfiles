return {
	{
		"projekt0n/github-nvim-theme",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			vim.cmd("colorscheme github_dark")
		end,
	},
	{
		"rebelot/kanagawa.nvim",
	},
	{
		"navarasu/onedark.nvim",
	},
	{
		"f-person/auto-dark-mode.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				-- vim.opt.background = "dark"
				-- vim.cmd("colorscheme catppuccin-mocha")
				-- vim.cmd("colorscheme kanagawa")
				vim.cmd("colorscheme github_dark")
			end,
			set_light_mode = function()
				-- vim.opt.background = "light"
				-- vim.cmd("colorscheme catppuccin-latte")
				vim.cmd("colorscheme github_light")
			end,
		},
	},
}
