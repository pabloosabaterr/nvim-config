local map = vim.keymap.set

-- Búsqueda
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Quitar resaltado" })

-- Quickfix y compilación
map("n", "<leader>q", "<cmd>cclose<CR>", { desc = "Cerrar quickfix" })
map("n", "<leader>m", "<cmd>make<CR>", { desc = "make" })

-- Navegación
map("n", "gb", "<C-o>", { desc = "Volver atrás" })

-- Salir de insert/terminal
map("i", "jj", "<Esc>")
map("t", "jj", [[<C-\><C-n>]])

-- Diagnósticos ([d y ]d ya vienen de serie)
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnóstico de la línea" })
