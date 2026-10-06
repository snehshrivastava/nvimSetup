return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  -- <leader>ft runs :TodoTelescope, which otherwise does not exist until a
  -- file has been read (e.g. from the alpha dashboard)
  cmd = { "TodoTelescope", "TodoTrouble", "TodoQuickFix", "TodoLocList" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local todo_comments = require("todo-comments")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "]t", function()
      todo_comments.jump_next()
    end, { desc = "Next todo comment" })

    keymap.set("n", "[t", function()
      todo_comments.jump_prev()
    end, { desc = "Previous todo comment" })

    todo_comments.setup()
  end,
}
