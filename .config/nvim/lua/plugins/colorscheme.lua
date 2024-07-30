return {
	{
		"catppuccin/nvim",
		config = function()
			require("catppuccin").setup({
				integrations = {
					harpoon = true,
					mason = true,
				},
			})
		end,
	},
	{
		"f-person/auto-dark-mode.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.opt.background = "dark"
				vim.cmd("colorscheme catppuccin-mocha")
			end,
			set_light_mode = function()
				vim.opt.background = "light"
				vim.cmd("colorscheme catppuccin-latte")
			end,
		},
	},
}
