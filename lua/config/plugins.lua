-- INFO: plugins
-- we install plugins with neovim's builtin package manager: vim.pack
-- and then enable/configure them by calling their setup functions.

-- (see `:h vim.pack` for more details on how it works)
-- you can press `gx` on any of the plugin urls below to open them in your
-- browser and check out their documentation and functionality.
-- alternatively, you can run `:h {plugin-name}` to read their documentation.

-- plugins are then loaded and configured with a call to `setup` functions
-- provided by each plugin. this is not a rule of neovim but rather a convention
-- followed by the community.
-- these setup calls take a table as an agument and their expected contents can
-- vary wildly. refer to each plugin's documentation for details.

-- INFO: colorscheme
vim.cmd.colorscheme("catppuccin")

-- INFO: formatting and syntax highlighting
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" }, { confirm = false })

-- equivalent to :TSUpdate
require("nvim-treesitter.install").update("all")
require("nvim-treesitter").setup({
	sync_install = true,
	modules = {},
	ignore_install = {},
	ensure_installed = {
		"bibtex",
		"html",
		"latex",
		"lua",
		"markdown",
		"ninja",
		"r",
		"rnoweb",
		"rst",
		"vim",
		"vimdoc",
	},
	auto_install = true, -- autoinstall languages that are not installed yet
	highlight = {
		enable = true,
	},
})

-- INFO: completion engine

vim.pack.add({ "https://github.com/L3MON4D3/LuaSnip" }, { confirm = false })
require("LuaSnip").setup({
	version = "2.*",
	build = (function()
		-- Build Step is needed for regex support in snippets.
		-- This step is not supported in many windows environments.
		-- Remove the below condition to re-enable on windows.
		if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
			return
		end
		return "make install_jsregexp"
	end)(),
	-- dependencies
	"https://github.com/rafamadriz/friendly-snippets",
	opts = {},
})

vim.pack.add({ "https://github.com/rafamadriz/friendly-snippets" }, { confirm = false })
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({
	paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
})

vim.pack.add({ "https://github.com/benfowler/telescope-luasnip.nvim" }, { confirm = false })
vim.keymap.set("n", "<leader>ss", "<cmd>Telescope luasnip<cr>", { desc = "[S]earch [S]nippets" })

vim.pack.add({ "https://github.com/chrisgrieser/nvim-scissors" }, { confirm = false })
require("scissors").setup({
	snippetDir = "../snippets",
})
vim.keymap.set("n", "<leader>ze", function()
	require("scissors").editSnippet()
end, { desc = "Snippet: Edit" })
vim.keymap.set(
	{ "n", "x" }, -- when used in visual mode, prefills the selection as snippet body
	"<leader>za",
	function()
		require("scissors").addNewSnippet()
	end,
	{ desc = "Snippet: Add" }
)

vim.pack.add({ "https://github.com/saghen/blink.cmp" }, { confirm = false })
require("blink.cmp").setup({
	completion = {
		documentation = {
			auto_show = true,
		},
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	snippets = { preset = "luasnip" },
	keymap = {
		-- these are the default blink keymaps
		["<C-n>"] = { "select_next", "fallback_to_mappings" },
		["<C-p>"] = { "select_prev", "fallback_to_mappings" },
		["<C-y>"] = { "select_and_accept", "fallback" },
		["<C-e>"] = { "cancel", "fallback" },
		["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
		["<CR>"] = { "select_and_accept", "fallback" },
		-- ["<Esc>"] = { "cancel", "hide", "hide_documentation", "fallback" },
		["<Esc>"] = { "fallback" },
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
		["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
	},
	fuzzy = {
		implementation = "lua",
	},
})

-- INFO: lsp server installation and configuration
-- lsp servers we want to use and their configuration
-- see `:h lspconfig-all` for available servers and their settings
local lsp_servers = {
	lua_ls = {
		-- https://luals.github.io/wiki/settings/ | `:h nvim_get_runtime_file`
		Lua = { workspace = { library = vim.api.nvim_get_runtime_file("lua", true) } },
	},
	pyright = {}, -- python type checking
	prettier = {},
	jupytext = {},
	ruff = {}, -- python linter formatter
	r_language_server = {}, -- r language server
	air = {}, -- r formatter
}

vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig", -- default configs for lsps
	-- NOTE: if you'd rather install the lsps through your OS package manager you
	-- can delete the next three mason-related lines and their setup calls below.
	-- see `:h lsp-quickstart` for more details.
	"https://github.com/mason-org/mason.nvim", -- package manager
	"https://github.com/mason-org/mason-lspconfig.nvim", -- lspconfig bridge
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", -- auto installer
}, { confirm = false })

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = vim.tbl_keys(lsp_servers),
})

-- configure each lsp server on the table
-- to check what clients are attached to the current buffer, use
-- `:checkhealth vim.lsp`. to view default lsp keybindings, use `:h lsp-defaults`.

-- gra → code actions
-- gri → implementations
-- grn → rename
-- grr → references
-- grt → type definition
-- grx → run codelens
-- gO → document symbols
-- Ctrl-S in Insert mode → signature help

for server, config in pairs(lsp_servers) do
	vim.lsp.config(server, {
		settings = config,
		-- only create the keymaps if the server attaches successfully
		on_attach = function(_, bufnr)
			vim.keymap.set("n", "grd", vim.lsp.buf.definition, { buffer = bufnr, desc = "vim.lsp.buf.definition()" })
			vim.keymap.set("n", "grf", vim.lsp.buf.format, { buffer = bufnr, desc = "vim.lsp.buf.format()" })
			-- -- Find references for the word under your cursor.
			-- vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
			--
			-- -- Jump to the implementation of the word under your cursor.
			-- -- Useful when your language has ways of declaring types without an actual implementation.
			-- vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
			--
			-- -- Jump to the definition of the word under your cursor.
			-- -- This is where a variable was first declared, or where a function is defined, etc.
			-- -- To jump back, press <C-t>.
			-- vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
			--
			-- -- Fuzzy find all the symbols in your current document.
			-- -- Symbols are things like variables, functions, types, etc.
			-- vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
			--
			-- -- Fuzzy find all the symbols in your current workspace.
			-- -- Similar to document symbols, except searches over your entire project.
			-- vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
			--
			-- -- Jump to the type of the word under your cursor.
			-- -- Useful when you're not sure what type a variable is and you want to see
			-- -- the definition of its *type*, not where it was *defined*.
			-- vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
		end,
	})
end

-- INFO: fuzzy finder
vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim", -- library dependency
	"https://github.com/nvim-tree/nvim-web-devicons", -- icons (nerd font)
	"https://github.com/nvim-telescope/telescope.nvim", -- the fuzzy finder
}, { confirm = false })

require("telescope").setup({})
local pickers = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", pickers.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", pickers.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", pickers.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sp", pickers.builtin, { desc = "[S]earch Builtin [P]ickers" })
vim.keymap.set("n", "<leader>sb", pickers.buffers, { desc = "[S]earch [B]uffers" })
vim.keymap.set({ "n", "v" }, "<leader>sw", pickers.grep_string, { desc = "[S]earch Current [W]ord" })
vim.keymap.set("n", "<leader>sg", pickers.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", pickers.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", pickers.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>sm", pickers.man_pages, { desc = "[S]earch [M]anuals" })
vim.keymap.set("n", "<leader>s.", pickers.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader>sc", pickers.commands, { desc = "[S]earch [C]ommands" })
vim.keymap.set("n", "<leader><leader>", pickers.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to Telescope to change the theme, layout, etc.
	pickers.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set("n", "<leader>s/", function()
	pickers.live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end, { desc = "[S]earch [/] in Open Files" })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
	pickers.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

-- INFO: better statusline
vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" }, { confirm = false })
require("lualine").setup({
	options = {
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
	},
})

-- INFO: keybinding helper
vim.pack.add({ "https://github.com/folke/which-key.nvim" }, { confirm = false })
require("which-key").setup({
	spec = {
		{ "<leader>s", group = "[S]earch", icon = { icon = "", color = "green" } },
		{ "<leader>b", group = "[B]uffer" },
		{ "<leader>t", group = "[T]oggle" },
		{ "<leader>x", group = "Diagnostics" },
		{ "<leader>z", group = "[Z]nippets" },
		{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } }, -- Enable gitsigns recommended keymaps first
		{ "gr", group = "LSP Actions", mode = { "n" } },
	},
})

-- NOTE: there are many more quality-of-life plugins available and others that
-- achieve what these do. these are just our recommendations to start.

-- INFO: utility plugins
vim.pack.add({
	"https://github.com/windwp/nvim-autopairs", -- auto pairs
	"https://github.com/folke/todo-comments.nvim", -- highlight TODO/INFO/WARN comments
}, { confirm = false })
require("nvim-autopairs").setup()
require("todo-comments").setup({
	highlight = {
		pattern = [[.*<(KEYWORDS)\s*:]], -- Pattern to match keywords anywhere
		comments_only = false, -- Set this to false for .rmd files
	},
})

vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" }, { confirm = false })
require("gitsigns").setup({
	signs = {
		add = { text = "+" }, ---@diagnostic disable-line: missing-fields
		change = { text = "~" }, ---@diagnostic disable-line: missing-fields
		delete = { text = "_" }, ---@diagnostic disable-line: missing-fields
		topdelete = { text = "‾" }, ---@diagnostic disable-line: missing-fields
		changedelete = { text = "~" }, ---@diagnostic disable-line: missing-fields
	},
})

-- Auto format
vim.pack.add({ "https://github.com/stevearc/conform.nvim.git" }, { confirm = false })
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- INFO: Mini
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })
require("mini.ai").setup({ n_lines = 500 })
-- Add/delete/replace surroundings (brackets, quotes, etc.)
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require("mini.surround").setup({
	mappings = {
		add = "gsa", -- Add surrounding in Normal and Visual modes
		delete = "gsd", -- Delete surrounding
		find = "gsf", -- Find surrounding (to the right)
		find_left = "gsF", -- Find surrounding (to the left)
		highlight = "gsh", -- Highlight surrounding
		replace = "gsr", -- Replace surrounding
		suffix_last = "l", -- Suffix to search with "prev" method
		suffix_next = "n", -- Suffix to search with "next" method
	},
	require("mini.files").setup({}),
})
vim.keymap.set("n", "<leader>E", "<Cmd>lua MiniFiles.open()<CR>", { desc = "Open/Close MiniFil[E]s" })

-- ... and there is more!
--  Check out: https://github.com/nvim-mini/mini.nvim

-- INFO: Neotree
vim.pack.add({
	{
		src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
		version = vim.version.range("3"),
	},
	-- dependencies
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	-- optional, but recommended
	"https://github.com/nvim-tree/nvim-web-devicons",
})
require("neo-tree").setup({})
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Open/Close Neotre[e]" })

-- INFO: R stats
vim.pack.add({ "https://github.com/R-nvim/R.nvim" })
require("R").setup({
	-- Create a table with the options to be passed to setup()
	hook = {
		on_filetype = function()
			vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
			vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})

			-- This function will be called at the FileType event
			-- of files supported by R.nvim. This is an
			-- opportunity to create mappings local to buffers.
			-- vim.keymap.set("n", "<Enter>", "<Plug>RDSendLine", { buffer = true })
			-- vim.keymap.set("x", "<Enter>", "<Plug>RSendSelection", { buffer = true })

			local wk = require("which-key")
			wk.add({
				buffer = true,
				mode = { "n", "x" },
				{ "<localleader>a", group = "all" },
				{ "<localleader>b", group = "between marks" },
				{ "<localleader>c", group = "chunks" },
				{ "<localleader>f", group = "functions" },
				{ "<localleader>g", group = "goto" },
				{ "<localleader>i", group = "install" },
				{ "<localleader>k", group = "knit" },
				{ "<localleader>p", group = "paragraph" },
				{ "<localleader>q", group = "quarto" },
				{ "<localleader>r", group = "r general" },
				{ "<localleader>s", group = "split or send" },
				{ "<localleader>t", group = "terminal" },
				{ "<localleader>u", group = "debug" },
				{ "<localleader>v", group = "view" },
			})
		end,
	},
	R_args = { "--quiet", "--no-save" },
	-- min_editor_width = 72,
	-- rconsole_width = 78,
	objbr_mappings = { -- Object browser keymap
		c = "class", -- Call R functions
		["<localleader>gg"] = "head({object}, n = 15)", -- Use {object} notation to write arbitrary R code.
		v = function()
			-- Run lua functions
			require("r.browser").toggle_view()
		end,
	},
	disable_cmds = {
		"RClearConsole",
		"RCustomStart",
		"RSPlot",
		"RSaveClose",
	},
})

-- INFO: Latex
vim.pack.add({ "https://github.com/lervag/vimtex" })
-- Configure vimtex via globals (no require/setup needed)
vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
vim.g.vimtex_view_method = "zathura"
vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		local wk = require("which-key")
		wk.add({
			{ "<localLeader>l", group = "+vimtex", buffer = true },
		})
	end,
})

-- INFO: Markdown
-- Markdown preview
vim.pack.add({
	"https://github.com/iamcco/markdown-preview.nvim",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
}, { confirm = false })

-- NOTE:
-- cd ~/.local/share/nvim-myconfig/site/pack/core/opt/markdown-preview.nvim
-- Please make sure that you have installed node.js and yarn
-- npx --yes yarn install
vim.g.mkdp_auto_start = 0
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		local wk = require("which-key")
		wk.add({
			{ "<localLeader>m", group = "[M]arkdown" },
			{
				"<localLeader>mp",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
				buffer = true,
			},
			{
				"<localLeader>mt",
				"<cmd>RenderMarkdown buf_toggle<cr>",
				desc = "Render Markdown",
				buffer = true,
			},
		})
	end,
})
require("render-markdown").setup({})

-- INFO: paste images
vim.pack.add({ "https://github.com/HakonHarnes/img-clip.nvim" }, { confirm = false })
require("img-clip").setup({
	default = {
		dir_path = "img", ---@type string | fun(): string
	},
})
vim.keymap.set("n", "<leader>P", "<cmd>PasteImage<cr>", { desc = "Paste image from system clipboard" })

-- INFO: Float term
vim.pack.add({ "https://github.com/voldikss/vim-floaterm" }, { confirm = false })
vim.g.floaterm_autoclose = 1
-- Prevent floaterm from triggering dashboard
vim.api.nvim_create_autocmd("FileType", {
	pattern = "floaterm",
	callback = function()
		vim.opt_local.buflisted = false
	end,
})
vim.keymap.set("n", "<leader>T", "<cmd>FloatermToggle<CR>", { desc = "Toggle floaterm" })

-- INFO: CSV
-- how to use: https://lorefnon.me/2024/01/17/Effectively-working-with-csv-files-in-vim/
vim.pack.add({ "https://github.com/mechatroner/rainbow_csv" }, { confirm = false })

-- INFO: Buffer line
vim.pack.add({ "https://github.com/akinsho/bufferline.nvim" }, { confirm = false })
require("bufferline").setup({})

-- INFO: Python
-- Testing
vim.pack.add({ "https://github.com/nvim-neotest/neotest" }, { confirm = false })
vim.pack.add({ "https://github.com/nvim-neotest/neotest-python" }, { confirm = false })
vim.pack.add({ "https://github.com/nvim-neotest/nvim-nio" }, { confirm = false }) -- Required dependency for neotest
-- Neotest
require("neotest").setup({
	adapters = {
		require("neotest-python")({
			runner = "pytest",
			-- You can leave this empty to let it find the python in your path/venv
			-- python = ".venv/bin/python",
		}),
	},
})

-- Keymaps for testing
-- vim.keymap.set("n", "<leader>tn", function() require("neotest").run.run() end, { desc = "Test Nearest" })
-- vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Test Summary" })

-- -- Virtual Environments
vim.pack.add({ "https://github.com/linux-cultist/venv-selector.nvim" }, { confirm = false })
require("venv-selector").setup({
	name = { "venv", ".venv", "env", ".env" }, -- folders to look for
	auto_refresh = true,
})
-- Keymap to select venv
vim.keymap.set("n", "<leader>cv", "<cmd>VenvSelect<cr>", { desc = "Select VirtualEnv" })

-- Debugging (DAP)
vim.pack.add({ "https://github.com/mfussenegger/nvim-dap" }, { confirm = false })
vim.pack.add({ "https://github.com/mfussenegger/nvim-dap-python" }, { confirm = false })
vim.pack.add({ "https://github.com/jay-babu/mason-nvim-dap.nvim" }, { confirm = false })

require("mason-nvim-dap").setup({
	ensure_installed = { "python" },
	handlers = {
		-- This 'empty' function prevents mason-nvim-dap from overriding
		-- the configurations provided by nvim-dap-python below
		python = function() end,
	},
})

-- Point this to where Mason installed debugpy
-- Usually: ~/.local/share/nvim/mason/packages/debugpy/venv/bin/python
require("dap-python").setup("python")

-- -- Keymaps for Debugging
-- -- vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>", { desc = "Toggle Breakpoint" })
-- -- vim.keymap.set("n", "<leader>dPt", function() require('dap-python').test_method() end, { desc = "Debug Method" })

-- DAP UI and Extras
vim.pack.add({ "https://github.com/rcarriga/nvim-dap-ui" }, { confirm = false })
vim.pack.add({ "https://github.com/theHamsta/nvim-dap-virtual-text" }, { confirm = false })
vim.pack.add({ "https://github.com/nvim-neotest/nvim-nio" }, { confirm = false })

local function get_args(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
	local args_str = type(args) == "table" and table.concat(args, " ") or args

	config = vim.deepcopy(config)
	config.args = function()
		local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str))
		return require("dap.utils").splitstr(new_args)
	end
	return config
end

local dap = require("dap")
local dapui = require("dapui")

-- Initial Setup
dapui.setup({})
require("nvim-dap-virtual-text").setup({})

-- UI Auto-open/close listeners
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- Keymaps
vim.keymap.set("n", "<leader>du", function()
	dapui.toggle()
end, { desc = "Toggle DAP UI" })
vim.keymap.set({ "n", "v" }, "<leader>de", function()
	dapui.eval()
end, { desc = "Eval Expression" })

-- Breakpoints and Stepping
vim.keymap.set("n", "<leader>db", function()
	dap.toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", function()
	dap.continue()
end, { desc = "Continue" })
vim.keymap.set("n", "<leader>da", function()
	dap.continue({ before = get_args })
end, { desc = "Run with Args" })
vim.keymap.set("n", "<leader>di", function()
	dap.step_into()
end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>dO", function()
	dap.step_over()
end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dt", function()
	dap.terminate()
end, { desc = "Terminate" })
