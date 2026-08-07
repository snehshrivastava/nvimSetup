return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require("notify")

    notify.setup({
      stages = "fade",
      timeout = 3000,
      top_down = true,
      render = "default",
    })

    vim.notify = notify
  end,
}
