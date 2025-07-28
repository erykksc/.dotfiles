return {
	{ "projekt0n/github-nvim-theme" },
	{ "RRethy/base16-nvim" },
	{
		"Shatur/neovim-ayu",
		lazy = false,
		priority = 1000,
		config = function()
			local colors = require("ayu.colors")
			colors.generate(true) -- Pass `true` to enable mirage
			require("ayu").setup({
				overrides = {
					LineNr = { fg = colors.comment },
				},
			})
			vim.cmd.colorscheme("ayu-mirage")
		end,
	},
	-- {
	-- 	"f-person/auto-dark-mode.nvim",
	-- 	opts = {
	-- 		set_dark_mode = function()
	-- 			-- vim.api.nvim_set_option_value("background", "dark", {})
	-- 			vim.cmd.colorscheme("base16-ayu-mirage")
	-- 		end,
	-- 		set_light_mode = function()
	-- 			-- vim.api.nvim_set_option_value("background", "light", {})
	-- 			vim.cmd.colorscheme("base16-ayu-light")
	-- 		end,
	-- 		update_interval = 3000,
	-- 		fallback = "dark",
	-- 	},
	-- },
}
