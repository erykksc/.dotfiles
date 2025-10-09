vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- visual
vim.g.have_nerd_font = true
vim.g.netrw_banner = 0
vim.g.netrw_preview = 1
vim.opt.inccommand = "split" -- Preview substitutions live, as you type!
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.scrolloff = 8 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.wrap = false -- Disable line wrapping
vim.opt.number = true -- show absolute number on cursor line
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "+1"
vim.o.winborder = "single" -- Set the floating window border (like lsp hover)
vim.opt.listchars = {
	space = "·",
	trail = "·",
	nbsp = "␣",
	tab = "»>",
	extends = "»",
	precedes = "«",
	eol = "↲",
}
-- indentation
vim.opt.tabstop = 4 -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4 -- Number of spaces for each level of indentation
vim.opt.softtabstop = 4 -- Number of spaces a <Tab> or <BS> uses while editing
-- misc
vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim.
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250 -- Decrease update time
vim.o.swapfile = false

vim.keymap.set("x", "<leader>p", [["_dP]]) -- greatest remap ever

-- File Explorer
vim.keymap.set("n", "<leader>er", "<CMD>Rex<CR>", { desc = "[E]xplore [R]ex" })
vim.keymap.set("n", "<leader>ep", "<CMD>Explore .<CR>", { desc = "[E]xplore [P]roject" })
vim.keymap.set("n", "<leader>ef", "<CMD>Explore<CR>", { desc = "[E]xplore [F]ile" })

-- Execute lua keymaps
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute current lua file" })
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Execute current lua line" })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Execute selected lua" })

-- Create missing directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(ctx)
		local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = true },
	virtual_text = {
		spacing = 2,
		format = function(diagnostic)
			return diagnostic.message
		end,
	},
})

-------------------------------- PLUGINS --------------------------------
-- plugin: colorscheme
vim.pack.add({
	"https://github.com/Shatur/neovim-ayu",
})
local colors = require("ayu.colors")
colors.generate(true) -- Pass `true` to enable mirage
require("ayu").setup({
	overrides = {
		LineNr = { fg = colors.comment },
	},
})
vim.cmd.colorscheme("ayu-mirage")

-- plugin: blink
vim.pack.add({ {
	src = "https://github.com/saghen/blink.cmp",
	version = vim.version.range("1.*"),
} })
require("blink.cmp").setup()

-- plugin: conform
vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "[F]ormat buffer" })

require("conform").setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local disable_filetypes = { c = true, cpp = true }
		if disable_filetypes[vim.bo[bufnr].filetype] then
			return nil
		else
			return {
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		end
	end,
	formatters_by_ft = {
		bash = { "shfmt" },
		lua = { "stylua" },
		-- python = function(bufnr)
		-- 	if require("conform").get_formatter_info("ruff_format", bufnr).available then
		-- 		return { "ruff_fix", "ruff_format" }
		-- 	else
		-- 		return { "isort", "black" }
		-- 	end
		-- end,

		go = { "goimports", "gofmt", stop_after_first = true },
		gotmpl = { "prettier_gotmpl" },
		nix = { "nixfmt" },
		css = { "prettierd", "prettier", stop_after_first = true },
		graphql = { "prettierd", "prettier", stop_after_first = true },
		handlebars = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		json5 = { "prettierd", "prettier", stop_after_first = true },
		jsonc = { "prettierd", "prettier", stop_after_first = true },
		less = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },
		mdx = { "prettierd", "prettier", stop_after_first = true },
		scss = { "prettierd", "prettier", stop_after_first = true },
		svelte = { "prettierd", "prettier", stop_after_first = true },
		terraform = { "tofu_fmt" },
		tex = { "tex-fmt" },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		vue = { "prettierd", "prettier", stop_after_first = true },
		yaml = { "prettierd", "prettier", stop_after_first = true },
	},
	formatters = {
		["tex-fmt"] = {
			args = { "--nowrap", "--stdin" },
		},
		prettier_gotmpl = {
			command = "prettier",
			args = {
				"--stdin-filepath",
				"$FILENAME",
				"--plugin",
				"prettier-plugin-go-template",
				"--parser",
				"go-template",
			},
			stdin = true,
		},
	},
})

-- plugin: gitsigns
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

local gitsigns = require("gitsigns")
gitsigns.setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})

vim.keymap.set({ "n" }, "[h", "<CMD>Gitsigns prev_hunk<CR>", { desc = "Next [H]unk" })
vim.keymap.set({ "n" }, "]h", "<CMD>Gitsigns next_hunk<CR>", { desc = "Prev [H]unk" })
vim.keymap.set({ "n" }, "<leader>hp", gitsigns.preview_hunk, { desc = "[H]unk [P]review", silent = true })

-- plugin: harpoon
vim.pack.add({
	{
		src = "https://github.com/ThePrimeagen/harpoon",
		version = "harpoon2",
	},
	"https://github.com/nvim-lua/plenary.nvim", --depencency
})
local harpoon = require("harpoon")
harpoon.setup()

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end, { desc = "Add file to Harpoon" })
vim.keymap.set("n", "<M-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Toggle Harpoon quick menu" })

local harpoon_keys = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 }
for i, key in ipairs(harpoon_keys) do
	vim.keymap.set("n", "<M-" .. key .. ">", function()
		harpoon:list():select(i)
	end, { desc = "Select Harpoon file " .. i })
end

-- plugin: nvim-lint
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })
require("lint").linters_by_ft = {
	go = { "golangcilint" },
}
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

--- plugin: oil.nvim
vim.pack.add({ "https://github.com/stevearc/oil.nvim" })
require("oil").setup({
	default_file_explorer = false,
})

-- plugin: undotree
vim.pack.add({ "https://github.com/mbbill/undotree" })
vim.keymap.set("n", "<leader>u", "<CMD>UndotreeToggle<CR>", { desc = "Toggle [U]ndo Tree" })

-- plugin: vim-sleuth
vim.pack.add({ "https://github.com/tpope/vim-sleuth" })

-- plugin: vim-slime
vim.pack.add({ "https://github.com/jpalardy/vim-slime" })
vim.g.slime_target = "tmux"
vim.g.slime_bracketed_paste = 1

-- plugin: nvim-treesitter
vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Handle nvim-treesitter updates",
	group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
	callback = function(event)
		if event.data.kind == "update" and event.data.spec.name == "nvim-treesitter" then
			vim.notify("nvim-treesitter updated, running TSUpdate...", vim.log.levels.INFO)
			---@diagnostic disable-next-line: param-type-mismatch
			local ok = pcall(vim.cmd, "TSUpdate")
			if ok then
				vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
			else
				vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
			end
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
})

require("nvim-treesitter.configs").setup({
	auto_install = true,
	highlight = {
		enable = true,
		disable = { "latex", "bibtex" },
	},
	indent = { enable = true },
})

-- plugin: live-preview.nvim
vim.pack.add({ "https://github.com/brianhuster/live-preview.nvim" })

-- plugin: mini
vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim",
})
require("mini.icons").setup()
local pick = require("mini.pick")
pick.setup({})
local miniExtra = require("mini.extra")

vim.keymap.set("n", "<leader>sh", pick.builtin.help, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", miniExtra.pickers.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", pick.builtin.files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sg", pick.builtin.grep_live, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", miniExtra.pickers.diagnostic, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", pick.builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>sb", pick.builtin.buffers, { desc = "[S]earch [B]uffers" })
vim.keymap.set("n", "<leader>/", function()
	miniExtra.pickers.buf_lines({ scope = "current" })
end, { desc = "[S]earch in current buffer" })
vim.keymap.set("n", "<leader>s/", miniExtra.pickers.buf_lines, { desc = "[S]earch in all buffers" })

-- plugin: LSP
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	-- Automatically install LSPs and related tools to stdpath for Neovim
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim", --translate between mason and lspconfig
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	-- Useful status updates for LSP.
	"https://github.com/j-hui/fidget.nvim",
	-- Allows extra capabilities provided by blink.cmp
	"https://github.com/saghen/blink.cmp",
	"https://github.com/nvim-mini/mini.nvim", -- for picker
})
require("fidget").setup()

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		-- In this case, we create a function that lets us more easily define mappings specific
		-- for LSP related items. It sets the mode, buffer and description for us each time.
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end
		local extra = require("mini.extra")

		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		map("grd", function()
			extra.pickers.lsp({ scope = "definition" })
		end, "[G]oto [D]efinition")

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header.
		map("grD", function()
			extra.pickers.lsp({ scope = "declaration" })
		end, "[G]oto [D]eclaration")

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		map("gO", function()
			extra.pickers.lsp({ scope = "document_symbol" })
		end, "Open Document Symbols")

		-- Fuzzy find all the symbols in your current workspace.
		--  Similar to document symbols, except searches over your entire project.
		map("gW", function()
			extra.pickers.lsp({ scope = "workspace_symbol" })
		end, "Open Workspace Symbols")

		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end
	end,
})

-- Listen to a godot host file
-- This makes the nvim jump to correct line and file when file chosen in godot editor
local projectfile = vim.fn.getcwd() .. "/project.godot"
if vim.fn.filereadable(projectfile) == 1 then
	vim.fn.serverstart("./godothost")
end

-- See `:help lspconfig-all` for a list of all the pre-configured LSPs
--
-- Some languages (like typescript) have entire language plugins that can be useful:
--    https://github.com/pmizio/typescript-tools.nvim
--
local servers = {
	arduino_language_server = {},
	bashls = {},
	cmake = {},
	gopls = {},
	html = {},
	-- htmx = {},
	jsonls = {},
	lua_ls = {
		settings = {
			Lua = {
				hint = { enable = true, setType = true },
			},
		},
	},
	-- ltex_plus = {},
	basedpyright = {},
	ruff = {},
	tofu_ls = {},
	ts_ls = {},
	texlab = {
		-- settings to use with tectonic (modern latexpdf alternative)
		settings = {
			texlab = {
				build = {
					executable = "tectonic",
					args = { "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
					-- args = { "-X", "compile", "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
					onSave = true,
				},
			},
		},
	},
	yamlls = {},
}

-- Ensure the servers and tools above are installed
require("mason").setup()

-- Make mason-tool-installer install tools
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
	"shfmt",
}) -- add additional tools like formatters
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

-- Define LSPs that don't need automatic installation
servers.clangd = {
	cmd = { "clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy" },
	capabilities = { offsetEncoding = "utf-8" },
	root_dir = function()
		return vim.fn.getcwd()
	end,
}
servers.gdscript = {}

-- configure and enable the LSPs
for server_name, server_config in pairs(servers) do
	vim.lsp.config(server_name, server_config)
	vim.lsp.enable(server_name)
end
