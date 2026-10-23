local map = vim.keymap.set
local append = vim.fn.append
local line = vim.fn.line

-- Search
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Quickfix & compilation
map("n", "<leader>q", "<cmd>cclose<CR>", { desc = "Close quickfix" })
map("n", "<leader>m", "<cmd>make<CR>", { desc = "Make" })

-- Navigation
map("n", "gb", "<C-o>", { desc = "Go back" })

-- Exit insert/terminal mode
map("i", "jj", "<Esc>")
map("i", "JJ", "<Esc>")
map("t", "jj", [[<C-\><C-n>]])

-- Diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- Insertions
map("n", "<CR>", function()
    append(line("."), "")
end)

map("n", "<S-CR>", function()
    append(line(".") - 1, "")
end)
