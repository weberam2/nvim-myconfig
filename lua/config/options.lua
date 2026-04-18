local opt = vim.opt

-- INFO: ui2
-- with ui2, there is not more annoying “press enter” prompt after you run a command. to enable it:
require("vim._core.ui2").enable({
	enable = true,
	msg = { -- options related to the message module.
		---@type 'cmd'|'msg' default message target, either in the
		---cmdline or in a separate ephemeral message window.
		---@type string|table<string, 'cmd'|'msg'|'pager'> default message target
		---or table mapping |ui-messages| kinds and triggers to a target.
		targets = "cmd",
		cmd = { -- options related to messages in the cmdline window.
			height = 0.5, -- maximum height while expanded for messages beyond 'cmdheight'.
		},
		dialog = { -- options related to dialog window.
			height = 0.5, -- maximum height.
		},
		msg = { -- options related to msg window.
			height = 0.5, -- maximum height.
			timeout = 4000, -- time a message is visible in the message window.
		},
		pager = { -- options related to message window.
			height = 0.5, -- maximum height.
		},
	},
})

-- INFO: builtin undotree
-- packadd nvim.undotree

-- INFO: Leader key
-- must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- INFO: line numbers
-- make line numbers default
opt.number = true
opt.relativenumber = true
-- show which line your cursor is on
opt.cursorline = true
-- enable line wrapping
opt.wrap = true
-- minimal number of screen lines to keep above and below the cursor.
-- vim.o.scrolloff = 10
opt.scrolloff = 10

-- INFO: Indentation
opt.tabstop = 2 -- Tab width
opt.shiftwidth = 2 -- Indent width
opt.softtabstop = 2 -- Soft tab stop
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Smart auto-indenting
opt.shiftround = true -- Round indent
opt.autoindent = true -- Copy indent from current line

-- INFO: Search settings
-- case-insensitive searching unless \c or one or more capital letters in the search term
opt.ignorecase = true -- Case insensitive search
opt.smartcase = true -- Case sensitive if uppercase in search
opt.hlsearch = true -- Highlight search results; but clear on pressing <esc> in normal mode
opt.incsearch = true -- Show matches as you type

-- Visual settings
opt.termguicolors = true -- Enable 24-bit colors
opt.signcolumn = "yes" -- Always show sign column
opt.showmatch = true -- Highlight matching brackets
opt.matchtime = 2 -- How long to show matching bracket
opt.cmdheight = 1 -- Command line height
opt.showmode = false -- Don't show mode in command line, since it's already in the status line
-- opt.pumheight = 10 -- Popup menu height
-- opt.pumblend = 10 -- Popup menu transparency
-- opt.winblend = 0 -- Floating window transparency
-- opt.completeopt = "menu,menuone,noselect"
-- opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- see `:help 'confirm'`
opt.confirm = true -- Confirm to save changes before exiting modified buffer
-- opt.concealcursor = "" -- Don't hide cursor line markup
-- opt.synmaxcol = 300 -- Syntax highlighting limit
-- opt.ruler = false -- Disable the default ruler
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
-- opt.winminwidth = 5 -- Minimum window width

-- File handling
opt.backup = false -- Don't create backup files
opt.writebackup = false -- Don't create backup before writing
opt.swapfile = false -- Don't create swap files
opt.autoread = true -- auto reload files changed outside vim
opt.autowrite = true -- auto save

opt.undofile = true -- Persistent undo
opt.undolevels = 10000
opt.undodir = vim.fn.expand("~/.vim/undodir") -- Undo directory
-- create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

opt.updatetime = 250 -- Faster completion
-- opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.timeoutlen = 300 -- displays which-key popup sooner
opt.ttimeoutlen = 0 -- Key code timeout

-- Behavior settings
-- opt.hidden = true -- Allow hidden buffers
-- opt.errorbells = false -- No error bells
opt.backspace = "indent,eol,start" -- Better backspace behavior
opt.autochdir = false -- Don't auto change directory
opt.iskeyword:append("-") -- Treat dash as part of word
opt.iskeyword:append("_") -- Treat dash as part of word
opt.path:append("**") -- include subdirectories in search
-- opt.selection = "exclusive" -- Selection behavior
opt.mouse = "a" -- Enable mouse support
--  see `:help 'clipboard'`
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.modifiable = true -- Allow buffer modifications
opt.encoding = "UTF-8" -- Set encoding

-- Folding settings
opt.smoothscroll = true
vim.wo.foldmethod = "expr"
opt.foldlevel = 99 -- Start with all folds open
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Split behavior
opt.splitbelow = true -- Horizontal splits go below
opt.splitright = true -- Vertical splits go right
opt.splitkeep = "screen"

-- Command-line completion
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Better diff options
opt.diffopt:append("linematch:60")

-- Performance improvements
opt.redrawtime = 10000
opt.maxmempattern = 20000

-- opt.fillchars = {
--   foldopen = "",
--   foldclose = "",
--   fold = " ",
--   foldsep = " ",
--   diff = "╱",
--   eob = " ",
-- }

opt.linebreak = true -- Wrap lines at convenient points
-- enable break indent
opt.breakindent = true
-- sets how neovim will display certain whitespace characters in the editor.
--  see `:help 'list'`
--  and `:help 'listchars'`
opt.list = true -- Show some invisible characters (tabs...
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

opt.textwidth = 80

-- preview substitutions live, as you type!
opt.inccommand = "split"
