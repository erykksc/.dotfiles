return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		config = function(_)
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				highlight = {
					enable = true,
					disable = { "latex", "bibtex" },
				},
				indent = { enable = true },
			})
		end,
	},
	-- {
	-- 	"nvim-treesitter/nvim-treesitter",
	-- 	lazy = false,
	-- 	branch = "main",
	-- 	build = ":TSUpdate",
	-- 	config = function()
	-- 		local nvimTreesitter = require("nvim-treesitter")
	-- 		local availableLangs = nvimTreesitter.get_available()
	-- 		local installedLangs = nvimTreesitter.get_installed()
	--
	-- 		vim.api.nvim_create_autocmd("FileType", {
	-- 			pattern = "*",
	-- 			callback = function(args)
	-- 				local bufnr = args.buf
	-- 				local ft = args.match
	-- 				-- lang not recognized (probably pluginn buffer)
	-- 				local lang = vim.treesitter.language.get_lang(ft)
	-- 				if not lang then
	-- 					return
	-- 				end
	-- 				-- no grammar for lang
	-- 				if not vim.tbl_contains(availableLangs, lang) then
	-- 					return false
	-- 				end
	-- 				-- grammar not installed
	-- 				if not vim.tbl_contains(installedLangs, lang) then
	-- 					nvimTreesitter.install(lang):wait(300000) -- max. 5 minutes
	-- 				end
	--
	-- 				-- Check so tree-sitter can see the newly installed parser
	-- 				local parser_installed = pcall(vim.treesitter.get_parser, bufnr, lang)
	-- 				if not parser_installed then
	-- 					vim.notify(
	-- 						"Failed to get parser for " .. lang .. " after installation",
	-- 						vim.log.levels.WARN,
	-- 						{ title = "core/treesitter" }
	-- 					)
	-- 					return
	-- 				end
	--
	-- 				-- syntax highlighting, provided by Neovim
	-- 				vim.treesitter.stop(bufnr)
	-- 				vim.treesitter.start()
	-- 				-- folds, provided by Neovim
	-- 				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	-- 				-- indentation, provided by nvim-treesitter
	-- 				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	-- 			end,
	-- 		})
	-- 	end,
	-- },
	{
		"nvim-treesitter/nvim-treesitter-context",
	},
}
