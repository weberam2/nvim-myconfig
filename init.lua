-- LUA:
-- some level of familiarity with lua/programming languages are also expected.
-- if you're new to lua, consider going through the official reference: https://www.lua.org/manual
-- or a more friendly tutorial like: https://learnxinyminutes.com/docs/lua/
-- you can also check out `:h lua-guide` inside neovim for a neovim-specific lua guide.

-- DEPENDENCIES:
-- this configuration assumes you have the following tools installed on your system:
--    `git` - for vim builtin package manager. (see `:h vim.pack`)
--    `ripgrep` - for fuzzy finding
--    clipboard tool: xclip/xsel/win32yank - for clipboard sharing between OS and neovim (see `h: clipboard-tool`)
--    a nerdfont (ensure the terminal running neovim is using it)
-- run `:checkhealth` inside neovim to see if your system is missing anything.

-- INFO: options
-- these change the default neovim behaviours using the 'vim.opt' API.
-- see `:h vim.opt` for more details.
-- run `:h '{option_name}'` to see what they do and what values they can take.
-- for example, `:h 'number'` for `vim.opt.number`.

-- Good resource for options: https://tduyng.com/blog/neovim-basic-setup/

-- ~/.config/nvim/
-- ├── init.lua                   # Entry point - loads everything
-- ├── lua/
-- │   └── config/                # Core configuration modules
-- │       ├── init.lua           # Orchestrates loading order
-- │       ├── options.lua        # Neovim behavior settings
-- │       ├── keymaps.lua        # All keyboard shortcuts
-- │       ├── diagnostics.lua    # Error/warning appearance
-- │       └── autocmds.lua       # Automatic behaviors

require("config")

-- uncomment to enable automatic plugin updates
-- vim.pack.update()
