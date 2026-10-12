return {
  "saghen/blink.cmp",
  version = "1.*", -- descarga el binario precompilado del fuzzy matcher
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    keymap = {
      preset = "none",
      ["<C-n>"] = { "show", "select_next", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-e>"] = { "cancel", "fallback" },
      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    },
    completion = {
      list = { selection = { preselect = true, auto_insert = false } },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    signature = { enabled = true },
    sources = { default = { "lsp", "path", "snippets" } },
    cmdline = { enabled = true },
  },
}
