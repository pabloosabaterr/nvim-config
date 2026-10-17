-- Requiere el binario fzf (macOS: brew install fzf; Arch: pacman -S fzf) y ripgrep
return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = {
    files = {
      hidden = true,
      cmd = "fd --type f --hidden --exclude .git --exclude node_modules",
    },
    grep = {
      hidden = true,
      rg_opts = "--column --line-number --no-heading --color=always --smart-case"
        .. " --hidden -g '!.git' -g '!node_modules'",
    },
  },
  keys = {
    { "<leader>p", "<cmd>FzfLua files<CR>", desc = "Ficheros" },
    { "<leader>f", "<cmd>FzfLua live_grep<CR>", desc = "Grep" },
    { "<leader>b", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
    { "<leader>r", "<cmd>FzfLua resume<CR>", desc = "Retomar última búsqueda" },
    { "<leader>s", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "Símbolos del fichero" },
    { "<leader>S", "<cmd>FzfLua lsp_live_workspace_symbols<CR>", desc = "Símbolos del proyecto" },
    { "<leader>x", "<cmd>FzfLua diagnostics_workspace<CR>", desc = "Diagnósticos" },
    { "<leader>w", "<cmd>FzfLua grep_cword<CR>", desc = "Grep palabra bajo el cursor" },
  },
}
