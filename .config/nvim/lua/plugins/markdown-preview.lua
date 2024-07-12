return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	keys = { { "<leader>pm", "<cmd>MarkdownPreviewToggle<CR>", mode = "n", { desc = "Toggle Preview Markdown" } } },
}
