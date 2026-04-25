local map = vim.keymap.set

-- INFO: Keymaps
-- clear search highlights with <Esc>
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- C-s for save
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<cr>")
-- Soft wrap
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
-- keep selection after indent/dedent
map("v", ">", ">gv")
map("v", "<", "<gv")
-- center after search and jumps
map("n", "n", "nzz")
map("n", "<c-d>", "<c-d>zz")
map("n", "<c-u>", "<c-u>zz")
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
-- map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
-- Navigate windows from terminal mode
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: Go to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: Go to down window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: Go to up window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: Go to right window" })
-- fix last spelling mistake
map("i", "<c-f>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { desc = "Fix last spelling mistake" })
-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
-- treat _ as word separator
vim.opt.iskeyword:remove("_")
-- INFO: Windows
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- map("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- map("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- map("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- map("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })
map({ "n", "t" }, "<leader>w", "<C-w>", { desc = "Window" })
map({ "n", "t" }, "<leader>|", "<C-w>v", { desc = "Split vertical" })
map({ "n", "t" }, "<leader>_", "<C-w>s", { desc = "Split horizontal" })

-- INFO: Visual mode
-- Better paste
-- In visual mode, when you paste over selected text, it doesn't overwrite your clipboard with the text you just deleted.
map("v", "p", '"_dP')

-- INFO: Buffers
map({ "n", "t" }, "<leader>bd", "<cmd>bdelete<CR>", { desc = "[D]elete buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- INFO: Folds
-- Toggle current fold
vim.keymap.set("n", "<Tab>", "za", { desc = "Toggle fold" })

-- Toggle all folds
vim.keymap.set("n", "<S-Tab>", function()
	local closed = vim.opt.foldlevel:get() > 0
	if closed then
		vim.cmd("normal! zM") -- close all folds
	else
		vim.cmd("normal! zR") -- open all folds
	end
end, { desc = "Toggle all folds" })

-- INFO: Quickfix
-- Quickfix and location lists
map("n", "<leader>xl", function()
	local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Location List" })

map("n", "<leader>xq", function()
	local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Quickfix List" })

-- INFO: Undotree
map("n", "<leader>U", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end, { desc = "Toggle Undotree" })

-- INFO: Difftool
map("n", "<leader>D", function()
	vim.cmd.packadd("nvim.difftool")
end, { desc = "Load Difftool" })
