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

-- Yanks reach the system clipboard, deletes do not. 'clipboard' cannot express
-- that - "unnamedplus" routes *every* register write through the pasteboard,
-- so dd/x/c clobber it too (see core/options.lua). Keying off
-- vim.v.event.operator instead is selective: it is "y" only for a real yank,
-- and "d" for d/dd/x, "c" for c/cc/s. Deletes therefore stay in nvim's own
-- registers and `p` after `dd` still pastes the deleted line.
--
-- regname is checked so an explicit "ayy targets register a alone and leaves
-- the pasteboard untouched.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("UserYankToClipboard", { clear = true }),
  callback = function()
    local ev = vim.v.event
    if ev.operator == "y" and ev.regname == "" then
      vim.fn.setreg("+", ev.regcontents, ev.regtype)
    end
  end,
})
