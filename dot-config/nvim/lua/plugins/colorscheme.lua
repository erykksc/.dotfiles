return {
	-- { "projekt0n/github-nvim-theme" },
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
}
