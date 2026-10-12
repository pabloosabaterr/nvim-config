local parsers = {
  "go", "gomod", "gosum", "gowork", "gotmpl",
  "c", "cpp", "rust", "make",
  "javascript", "typescript", "tsx",
  "lua", "vim", "vimdoc", "query", "regex",
  "markdown", "markdown_inline",
  "json", "yaml", "toml", "bash",
  "diff", "gitcommit", "git_rebase",
}

local filetypes = {
  "go", "gomod", "gosum", "gowork", "gotmpl",
  "c", "cpp", "rust", "make",
  "javascript", "javascriptreact", "typescript", "typescriptreact",
  "lua", "vim", "help", "query", "markdown",
  "json", "yaml", "toml", "sh",
  "diff", "gitcommit", "git_rebase",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })
      ts.install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_ts", { clear = true }),
        pattern = filetypes,
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = { max_lines = 3 },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      for lhs, query in pairs({
        af = "@function.outer", ["if"] = "@function.inner",
        ac = "@class.outer", ic = "@class.inner",
        aa = "@parameter.outer", ia = "@parameter.inner",
        al = "@loop.outer", il = "@loop.inner",
      }) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(query, "textobjects")
        end)
      end

      local move = require("nvim-treesitter-textobjects.move")
      local nxo = { "n", "x", "o" }
      vim.keymap.set(nxo, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Siguiente función" })
      vim.keymap.set(nxo, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Función anterior" })
      vim.keymap.set(nxo, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end, { desc = "Siguiente parámetro" })
      vim.keymap.set(nxo, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end, { desc = "Parámetro anterior" })
    end,
  },
}
