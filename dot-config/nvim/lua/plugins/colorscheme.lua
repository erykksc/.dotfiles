return {
	{
		"projekt0n/github-nvim-theme",
	},
	{
		"RRethy/base16-nvim",
		config = function()
			vim.cmd.colorscheme("base16-ayu-mirage")
		end
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
