-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- mouse: ctrl+click to jump to LSP definition, mouse back-button to jump back
-- (X1Mouse is the standard back-button event nvim reports for SGR-capable
-- terminals like ghostty; falls back to no-op if the terminal doesn't send it)
keymap.set("n", "<C-LeftMouse>", function()
  vim.lsp.buf.definition()
end, { desc = "Go to LSP definition (ctrl+click)" })

keymap.set("n", "<X1Mouse>", "<C-o>", { desc = "Jump back (mouse back button)" })

-- move by visual line on wrapped lines, not over the whole logical line
keymap.set({ "n", "v" }, "j", "gj", { desc = "Move down (visual line)" })
keymap.set({ "n", "v" }, "k", "gk", { desc = "Move up (visual line)" })
