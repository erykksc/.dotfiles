return {
	{
		"projekt0n/github-nvim-theme",
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.cmd.colorscheme("tokyonight-night")
			-- Set the background to dark
			vim.o.background = "dark" -- or "light" for light mode
		end,
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
