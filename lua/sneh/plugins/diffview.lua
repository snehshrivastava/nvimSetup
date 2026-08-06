return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff view: working tree changes" },
    { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Diff view: repo history" },
    { "<leader>gc", "<cmd>DiffviewFileHistory %<cr>", desc = "Diff view: current file history" },
    { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diff view: close" },
  },
}
