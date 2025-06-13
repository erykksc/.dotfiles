return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		settings = {
			sync_on_ui_close = false,
			save_on_toggle = false,
		},
	},
	config = function(_, opts)
		local harpoon = require("harpoon")
		harpoon.setup(opts)

		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Add file to Harpoon" })
		vim.keymap.set("n", "<M-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Toggle Harpoon quick menu" })

		local keys = { "s", "d", "f", "g" }
		for i, key in ipairs(keys) do
			vim.keymap.set("n", "<M-" .. key .. ">", function()
				harpoon:list():select(i)
			end, { desc = "Select Harpoon file " .. i })
		end
	end,
}
