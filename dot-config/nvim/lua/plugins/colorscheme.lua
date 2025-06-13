return {
	{
		"projekt0n/github-nvim-theme",
	},
	{
		"RRethy/base16-nvim",
	},
	{
		"f-person/auto-dark-mode.nvim",
		opts = {
			set_dark_mode = function()
				-- vim.api.nvim_set_option_value("background", "dark", {})
				vim.cmd.colorscheme("github_dark_default")
			end,
			set_light_mode = function()
				-- vim.api.nvim_set_option_value("background", "light", {})
				vim.cmd.colorscheme("github_light_default")
			end,
			update_interval = 3000,
			fallback = "dark",
		},
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
