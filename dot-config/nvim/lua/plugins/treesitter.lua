return {
	{                                  -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter", -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		branch = "master",
		-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				branch = "master",
			},
		},
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "bash", "c", "html", "lua", "luadoc", "markdown", "vim", "vimdoc" },
			auto_install = true,
			highlight = {
				enable = true,
				disable = { "latex", "bibtex" },
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby", "markdown" },
			},
			indent = { enable = true, disable = { "ruby" } },
			textobjects = {
				lsp_interop = {
					enable = true,
					border = "none",
					floating_preview_opts = {},
					-- peek_definition_code = {
					-- 	["<leader>pf"] = "@function.outer",
					-- 	["<leader>pc"] = "@class.outer",
					-- },
				},
				select = {
					enable = true,
					keymaps = {
						["if"] = "@function.inner",
						["af"] = "@function.outer",
						["ia"] = "@parameter.inner",
						["aa"] = "@parameter.outer",
						["ic"] = "@class.inner",
						["ac"] = "@class.outer",
					},
					selection_modes = {
						-- ["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						-- ["@class.outer"] = "<c-v>", -- blockwise
					},
					include_surrounding_whitespace = false,
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]f"] = "@function.outer",
						["]a"] = "@parameter.inner",
					},
					goto_next_end = {
						["]F"] = "@function.outer",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
					},
				},
			},
		},
		config = function(_, opts)
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup(opts)

			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

			-- create repeatable diagnostic motions
			local next_diag, prev_diag = ts_repeat_move.make_repeatable_move_pair(
				function() vim.diagnostic.jump({ count = 1, float = true }) end,
				function() vim.diagnostic.jump({ count = -1, float = true }) end
			)

			-- override the default mappings so they become repeatable with ; and ,
			vim.keymap.set({ "n", "x", "o" }, "]d", next_diag, { desc = "Next diagnostic" })
			vim.keymap.set({ "n", "x", "o" }, "[d", prev_diag, { desc = "Prev diagnostic" })

			-- create repeatable quicklist motions
			local cnext, cprev = ts_repeat_move.make_repeatable_move_pair(
				function() vim.cmd.cnext() end,
				function() vim.cmd.cprev() end
			)

			vim.keymap.set({ "n", "x", "o" }, "]q", cnext, { desc = "Next item on quicklist" })
			vim.keymap.set({ "n", "x", "o" }, "[q", cprev, { desc = "Prev item on quicklist" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			enable = true,         -- Enable this plugin (Can be enabled/disabled later via commands)
			max_lines = 0,         -- How many lines the window should span. Values <= 0 mean no limit.
			min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
			line_numbers = true,
			multiline_threshold = 20, -- Maximum number of lines to show for a single context
			trim_scope = "outer",  -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
			mode = "cursor",       -- Line used to calculate context. Choices: 'cursor', 'topline'
			-- Separator between context and content. Should be a single character string, like '-'.
			-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
			separator = nil,
			zindex = 20,  -- The Z-index of the context window
			on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
		},
	},
}
