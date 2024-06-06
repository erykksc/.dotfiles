return {
	{
		"github/copilot.vim",
		config = function()
			vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
			})
			vim.g.copilot_no_tab_map = true
		end,
	},
	-- {
	-- 	"CopilotC-Nvim/CopilotChat.nvim",
	-- 	branch = "canary",
	-- 	dependencies = {
	-- 		{ "github/copilot.lua" }, -- or github/copilot.vim
	-- 		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	-- 	},
	-- 	opts = {
	-- 		debug = false, -- Enable debugging
	-- 		-- See Configuration section for rest
	-- 	},
	-- 	-- Quick chat with Copilot
	-- 	vim.keymap.set("n", "<leader>ccq", function()
	-- 		local input = vim.fn.input("Quick Chat: ")
	-- 		if input ~= "" then
	-- 			require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
	-- 		end
	-- 	end, { desc = "CopilotChat - Quick chat" }),
	-- },
}
