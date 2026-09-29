require("sneh.core.options")
require("sneh.core.keymaps")
-- core/autocmds.lua was never required here, so none of it had ever run: the
-- UserCheckTime / UserFileChangedNotify pair that mirrors vim/core/autocmds.vim
-- (reload buffers changed on disk so the LSP does not diagnose stale content)
-- was dead, along with the clipboard TextYankPost mirror.
require("sneh.core.autocmds")

