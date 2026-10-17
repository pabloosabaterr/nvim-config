local o = vim.opt

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
o.termguicolors = true
o.number = true
o.relativenumber = true
o.scrolloff = 5
o.laststatus = 2
o.colorcolumn = "+1"
o.signcolumn = "yes"
o.winborder = "rounded"
o.mouse = ""
-- macOS: "unnamed" (pbcopy). Linux: "unnamedplus" (wl-clipboard o xclip)
o.clipboard = vim.fn.has("mac") == 1 and "unnamed" or "unnamedplus"

o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

o.splitright = true
o.splitbelow = true

o.undofile = true
o.autoread = true
o.updatetime = 250
o.timeoutlen = 150
o.ttimeoutlen = 5
