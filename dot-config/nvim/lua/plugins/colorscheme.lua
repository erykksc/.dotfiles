return {
	{
		"projekt0n/github-nvim-theme",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("github_dark_default")
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
