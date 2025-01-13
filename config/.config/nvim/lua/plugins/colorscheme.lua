return {
	{
		"folke/tokyonight.nvim",
		-- lazy = false,
		-- priority = 1000,
		-- opts = {
		-- 	style = "moon",
		-- 	transparent = false,
		-- 	terminal_colors = true,
		-- 	styles = {
		-- 		comments = { italic = false },
		-- 		keywords = { italic = false },
		-- 		sidebars = "dark",
		-- 		floats = "dark",
		-- 	},
		-- },
		-- config = function()
		-- 	vim.cmd("colorscheme tokyonight")
		-- end,
	},

	{
		"projekt0n/github-nvim-theme",
		priority = 1000,
	},
	{
		"rebelot/kanagawa.nvim",
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
				vim.cmd("colorscheme github_dark_default")
				-- vim.opt.background = "dark"
			end,
			set_light_mode = function()
				vim.cmd("colorscheme github_light")
				-- vim.opt.background = "light"
			end,
		},
	},
}
