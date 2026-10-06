vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- mouse
opt.mouse = "a" -- enable mouse in all modes (click to focus pane/expand nvim-tree nodes)

-- tabs & indentation
opt.tabstop = 4 -- 4 spaces for tabs
opt.shiftwidth = 4 -- 4 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = true -- wrap long lines

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- let left/right movement wrap to the previous/next line at buffer edges,
-- instead of stopping dead at column 1 / end of line
opt.whichwrap:append("b,s,h,l,<,>,[,]")

-- clipboard: left empty on purpose. The wanted behaviour is "yanks go to the
-- system clipboard, deletes do not", and 'clipboard' cannot express it -
-- "unnamedplus" routes every register write through the pasteboard, so dd/x/c
-- clobber it too. The TextYankPost autocmd in core/autocmds.lua does the yank
-- half selectively instead.
opt.clipboard = "" -- see the TextYankPost autocmd in core/autocmds.lua

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- CursorHold delay: drives LSP document highlight and the checktime reload in
-- core/autocmds.lua (default 4000ms; matches vim/plugin-config/git.vim)
opt.updatetime = 300

-- turn off swapfile
opt.swapfile = false

-- folds: start files fully expanded
opt.foldlevelstart = 99
