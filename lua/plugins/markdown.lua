return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    render_modes = { "n", "c", "t" },
    anti_conceal = { enabled = true },
    latex = { enabled = false },
    heading = {
      sign = false,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      width = "block",
      left_pad = 1,
      right_pad = 2,
    },
    code = {
      sign = false,
      width = "block",
      left_pad = 1,
      right_pad = 2,
      border = "thin",
    },
    bullet = { icons = { "●", "○", "◆", "◇" } },
    checkbox = {
      unchecked = { icon = "󰄱 " },
      checked = { icon = "󰱒 " },
    },
    pipe_table = { style = "full", cell = "padded" },
  },
}
