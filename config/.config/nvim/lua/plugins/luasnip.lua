return {
	"L3MON4D3/LuaSnip",
	build = (function()
		-- Build Step is needed for regex support in snippets.
		-- This step is not supported in many windows environments.
		-- Remove the below condition to re-enable on windows.
		if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
			return
		end
		return "make install_jsregexp"
	end)(),
	dependencies = {
		{
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
	},
	config = function()
		-- require("luasnip.loaders.from_lua").load({ paths = { "/Users/erykksc/.dotfiles/.config/nvim/lua/snippets" } })
		require("luasnip.loaders.from_snipmate").lazy_load()
	end,
	keys = {
		{
			"<C-K>",
			function()
				require("luasnip").expand()
			end,
			mode = "i",
			silent = true,
			desc = "Expand snippet",
		},
		{
			"<C-L>",
			function()
				require("luasnip").jump(1)
			end,
			mode = { "i", "s" },
			silent = true,
			desc = "Jump forward in snippet",
		},
		{
			"<C-J>",
			function()
				require("luasnip").jump(-1)
			end,
			mode = { "i", "s" },
			silent = true,
			desc = "Jump backward in snippet",
		},
		{
			"<C-E>",
			function()
				local ls = require("luasnip")
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end,
			mode = { "i", "s" },
			silent = true,
			desc = "Change choice in snippet",
		},
	},
}
