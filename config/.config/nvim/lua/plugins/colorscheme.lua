return {
	{
		"projekt0n/github-nvim-theme",
	},
	{
		"rebelot/kanagawa.nvim",
	},
	{
		"olimorris/onedarkpro.nvim",
		priority = 1000, -- Ensure it loads first
		config = function()
			vim.cmd("colorscheme onedark")
		end,
	},
	{
		"f-person/auto-dark-mode.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.cmd("colorscheme onedark")
				-- vim.opt.background = "dark"
			end,
			set_light_mode = function()
				vim.cmd("colorscheme onelight")
				-- vim.opt.background = "light"
			end,
		},
	},
}
