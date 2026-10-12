return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = { "ConformInfo", "FormatToggle" },
  keys = {
    {
      "<leader>cf",
      function() require("conform").format({ async = true }) end,
      mode = { "n", "v" },
      desc = "Formatear",
    },
  },
  opts = {
    formatters_by_ft = {
      c = { "clang_format" },
      cpp = { "clang_format" },
      go = { "goimports", "gofmt", stop_after_first = true },
      rust = { "rustfmt" },
      javascript = { "deno_fmt" },
      javascriptreact = { "deno_fmt" },
      typescript = { "deno_fmt" },
      typescriptreact = { "deno_fmt" },
      json = { "deno_fmt" },
      lua = { "stylua" },
    },
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = function(buf)
      if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then return end
      return { timeout_ms = 1000 }
    end,
  },
  init = function()
    vim.api.nvim_create_user_command("FormatToggle", function()
      vim.g.disable_autoformat = not vim.g.disable_autoformat
      vim.notify("Formato al guardar: " .. (vim.g.disable_autoformat and "off" or "on"))
    end, { desc = "Alternar formato al guardar" })
  end,
}
