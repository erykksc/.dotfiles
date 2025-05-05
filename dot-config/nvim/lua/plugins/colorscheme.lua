return {
	-- {
	-- 	"folke/tokyonight.nvim",
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
	-- },

	{
		"projekt0n/github-nvim-theme",
		priority = 1000,
	},
	{
		"shaunsingh/nord.nvim",
		priority = 1000,
	},

	-- {
	-- 	"rebelot/kanagawa.nvim",
	-- },

	-- {
	-- 	"olimorris/onedarkpro.nvim",
	-- },
	{ "dracula/vim" },

	{
		"erykksc/ghostty-theme-sync.nvim",
		branch = "main",
		opts = {
			persist_nvim_theme = true,
			nvim_config_path = "~/.config/nvim/lua/plugins/colorscheme.lua", -- Add your configuration here
		},
	},
	{
		"f-person/auto-dark-mode.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.cmd.colorscheme("nord")
				vim.opt.background = "dark"
			end,
			set_light_mode = function()
				-- vim.cmd.colorscheme("github_light_default")
				vim.opt.background = "light"
			end,
		},
	},
}
