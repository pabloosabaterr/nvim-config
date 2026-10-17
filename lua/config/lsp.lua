-- Mapeos nativos desde 0.11: K, grn (rename), gra (code action),
-- grr (references), gri (implementation), gO (símbolos), <C-s> (firma en insert)

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  filetypes = { "c", "cpp" },
  root_markers = { "compile_commands.json", "compile_flags.txt", "Makefile", ".git" },
})

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
})

vim.lsp.config("denols", {
  cmd = { "deno", "lsp" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "deno.json", "deno.jsonc", "deno.lock", ".git" },
  init_options = { enable = true, lint = true },
})

vim.lsp.config("gopls", {
  cmd = { vim.fn.exepath("gopls") ~= "" and "gopls" or vim.fn.expand("~/go/bin/gopls") },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      analyses = { unusedparams = true, unusedwrite = true },
      staticcheck = true,
      completeUnimported = true,
      usePlaceholders = true,
      directoryFilters = { "-vendor", "-node_modules" },
      hints = {
        parameterNames = true,
        assignVariableTypes = true,
        compositeLiteralFields = true,
      },
    },
  },
})

vim.lsp.config("asm_lsp", {
  cmd = { vim.fn.exepath("asm-lsp") ~= "" and "asm-lsp" or vim.fn.expand("~/.cargo/bin/asm-lsp") },
  filetypes = { "arm64asm" },
  root_markers = { ".git" },
})

vim.lsp.config("marksman", {
  cmd = { "marksman", "server" },
  filetypes = { "markdown" },
  root_markers = { ".marksman.toml", ".git" },
})

local servers = { "clangd", "rust_analyzer", "denols", "gopls", "asm_lsp" }
if vim.fn.executable("marksman") == 1 then
  table.insert(servers, "marksman")
end
vim.lsp.enable(servers)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    map("gd", vim.lsp.buf.definition, "Ir a definición")
    map("gD", vim.lsp.buf.declaration, "Ir a declaración")

    map("<leader>oi", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" }, diagnostics = {} },
        apply = true,
      })
    end, "Organizar imports")

    if client and client:supports_method("textDocument/inlayHint") then
      map("<leader>ih", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }),
          { bufnr = ev.buf })
      end, "Alternar inlay hints")
    end
  end,
})

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = { current_line = true },
  signs = true,
  underline = true,
  severity_sort = true,
  update_in_insert = false,
})
