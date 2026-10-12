return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true,
      on_attach = function(buf)
        local gs = require("gitsigns")
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end

        map("n", "]h", function()
          if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
        end, "Siguiente hunk")
        map("n", "[h", function()
          if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
        end, "Hunk anterior")

        map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage selección")
        map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset selección")
        map("n", "<leader>gS", gs.stage_buffer, "Stage fichero")
        map("n", "<leader>gp", gs.preview_hunk_inline, "Ver hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame de la línea")

        map({ "o", "x" }, "ih", gs.select_hunk, "Hunk")
      end,
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diff del repo" },
      { "<leader>gD", "<cmd>DiffviewOpen origin/HEAD...HEAD<CR>", desc = "Diff de la rama (tipo PR)" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Historial del fichero" },
      { "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "Cerrar diffview" },
    },
  },
}
