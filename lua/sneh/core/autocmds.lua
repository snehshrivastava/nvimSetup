-- Detect files changed on disk by external processes (git, build tools,
-- Claude Code) and reload the buffer, so LSP (jdtls) sees current content
-- instead of diagnosing against a stale in-memory version.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("UserCheckTime", { clear = true }),
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = vim.api.nvim_create_augroup("UserFileChangedNotify", { clear = true }),
  callback = function()
    vim.notify("File changed on disk, buffer reloaded", vim.log.levels.INFO)
  end,
})
