return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  -- lazy-loaded: :Telescope (alpha dashboard buttons), the keys below, or any
  -- require("telescope...") (LspAttach's gd/gR/gi/gt, :TodoTelescope)
  cmd = "Telescope",
  keys = {
    { "<leader>fp", "<cmd>Telescope find_files hidden=true<cr>", desc = "Fuzzy find files in cwd (incl. hidden)" },
    { "<leader>ff", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in current buffer" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Fuzzy find recent files" },
    { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Find string in cwd" },
    { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor in cwd" },
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find todos" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    telescope.load_extension("fzf")
  end,
}
