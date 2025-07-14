return {
	{
		"projekt0n/github-nvim-theme",
	},
	{
		"RRethy/base16-nvim",
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
	},
	{
		"f-person/auto-dark-mode.nvim",
		opts = {
			set_dark_mode = function()
				-- vim.api.nvim_set_option_value("background", "dark", {})
				vim.cmd.colorscheme("base16-ayu-mirage")
			end,
			set_light_mode = function()
				-- vim.api.nvim_set_option_value("background", "light", {})
				vim.cmd.colorscheme("base16-ayu-light")
			end,
			update_interval = 3000,
			fallback = "dark",
		},
	},
	{
		"Shatur/neovim-ayu",
		lazy = false,
		priority = 1000,
	},
	{
		"shaunsingh/nord.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"erykksc/ghostty-theme-sync.nvim",
		branch = "main",
		opts = {
			persist_nvim_theme = true,
			nvim_config_path = "~/.config/nvim/lua/plugins/colorscheme.lua", -- Add your configuration here
		},
	},
}
