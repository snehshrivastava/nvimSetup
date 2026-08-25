# Keymaps

Leader key: `<Space>`

## Files & search (Telescope)

| Key | Action |
|---|---|
| `<leader>fp` | Find files in cwd |
| `<leader>ff` | Fuzzy find in current buffer |
| `<leader>fr` | Recent files |
| `<leader>fs` | Live grep (search string in cwd) |
| `<leader>fc` | Grep string under cursor in cwd |
| `<leader>ft` | Find todos |

## File explorer (nvim-tree)

| Key | Action |
|---|---|
| `<leader>ee` | Toggle file explorer |
| `<leader>ef` | Toggle explorer on current file |
| `<leader>ec` | Collapse explorer |
| `<leader>er` | Refresh explorer |

Inside the tree buffer (plugin defaults, `on_attach_default`):

| Key | Action |
|---|---|
| `<CR>` / `o` | Open |
| `<C-v>` | Open: vertical split |
| `<C-x>` | Open: horizontal split |
| `<C-t>` | Open: new tab |
| `<Tab>` | Open preview |
| `a` | Create file/directory |
| `d` | Delete |
| `r` | Rename |
| `x` | Cut |
| `c` | Copy |
| `p` | Paste |
| `y` | Copy name |
| `-` | Up a directory |
| `<BS>` | Close directory |
| `R` | Refresh |
| `H` | Toggle dotfiles filter |
| `I` | Toggle git-ignored filter |
| `q` | Close tree |
| `g?` | Help (full mapping list) |

## Windows, splits, tabs

| Key | Action |
|---|---|
| `<leader>sv` | Split vertically |
| `<leader>sh` | Split horizontally |
| `<leader>se` | Make splits equal size |
| `<leader>sx` | Close current split |
| `<leader>sm` | Maximize/minimize current split |
| `<leader>to` | New tab |
| `<leader>tx` | Close tab |
| `<leader>tn` | Next tab |
| `<leader>tp` | Previous tab |
| `<leader>tf` | Open current buffer in new tab |

## LSP (on `LspAttach`)

| Key | Action |
|---|---|
| `K` | Hover docs |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `gR` | Show references |
| `<leader>ca` | Code action (n, v) |
| `<leader>rn` | Rename symbol |
| `<leader>d` | Line diagnostics (float) |
| `<leader>D` | Buffer diagnostics (Telescope) |
| `[d` / `]d` | Prev / next diagnostic |
| `<leader>rs` | Restart LSP |

Cursor resting on a symbol auto-highlights its other uses in the buffer (clears on move).

## Java / jdtls

| Key | Action |
|---|---|
| `<leader>jc` | Full workspace recompile (fixes stale "unresolved" index) |
| `<leader>jw` | Wipe jdtls workspace index and restart |

## Diagnostics list (Trouble)

| Key | Action |
|---|---|
| `<leader>xw` | Workspace diagnostics |
| `<leader>xd` | Document diagnostics |
| `<leader>xq` | Quickfix list |
| `<leader>xl` | Location list |
| `<leader>xt` | Todos |

## Git — hunks (gitsigns)

| Key | Action |
|---|---|
| `]h` / `[h` | Next / prev hunk |
| `<leader>hs` | Stage hunk (n, v) |
| `<leader>hr` | Reset hunk (n, v) |
| `<leader>hS` | Stage buffer |
| `<leader>hR` | Reset buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line (full) |
| `<leader>hB` | Toggle line blame |
| `<leader>hd` | Diff this |
| `<leader>hD` | Diff this against `~` |
| `ih` | Select hunk (text object, o/x) |

## Git — views

| Key | Action |
|---|---|
| `<leader>lg` | Open LazyGit |
| `<leader>gd` | Diffview: working tree changes |
| `<leader>gh` | Diffview: repo history |
| `<leader>gc` | Diffview: current file history |
| `<leader>gq` | Diffview: close |

## Debug (DAP)

| Key | Action |
|---|---|
| `<leader>bb` | Toggle breakpoint |
| `<leader>bB` | Conditional breakpoint |
| `<leader>bc` | Continue / start |
| `<leader>bi` | Step into |
| `<leader>bo` | Step over |
| `<leader>bO` | Step out |
| `<leader>br` | Open REPL |
| `<leader>bl` | Run last |
| `<leader>bu` | Toggle debug UI |
| `<leader>bt` | Terminate |

## Format & lint

| Key | Action |
|---|---|
| `<leader>mp` | Format file/selection (manual — no format-on-save) |
| `<leader>l` | Trigger linting for current file |

## Session (auto-session)

| Key | Action |
|---|---|
| `<leader>wr` | Restore session for cwd |
| `<leader>ws` | Save session for cwd |

## Todo comments

| Key | Action |
|---|---|
| `]t` / `[t` | Next / prev todo comment |

## Comments (Comment.nvim, plugin defaults)

| Key | Action |
|---|---|
| `gcc` | Toggle line comment |
| `gbc` | Toggle block comment |
| `gc{motion}` | Comment a motion/textobject (n), or selection (v) |
| `gb{motion}` | Block-comment a motion/textobject (n), or selection (v) |
| `gco` | Insert comment on line below |
| `gcO` | Insert comment on line above |
| `gcA` | Insert comment at end of line |

## Surround (nvim-surround, plugin defaults)

| Key | Action |
|---|---|
| `ys{motion}{char}` | Add surround around motion |
| `yss{char}` | Add surround around current line |
| `yS{motion}{char}` | Add surround around motion, on new lines |
| `S{char}` (visual) | Add surround around selection |
| `gS{char}` (visual) | Add surround around selection, on new lines |
| `ds{char}` | Delete surround |
| `cs{char1}{char2}` | Change surround |
| `cS{char1}{char2}` | Change surround, replacements on new lines |
| `<C-g>s` / `<C-g>S` (insert) | Add surround around cursor |

## Completion (nvim-cmp, insert mode)

| Key | Action |
|---|---|
| `<C-j>` / `<C-k>` | Next / prev suggestion |
| `<C-Space>` | Show completion suggestions |
| `<C-b>` / `<C-f>` | Scroll docs |
| `<C-e>` | Abort completion |
| `<CR>` | Confirm selection |

## Misc

| Key | Action |
|---|---|
| `<leader>nh` | Clear search highlight |
| `<leader>+` / `<leader>-` | Increment / decrement number under cursor |
