return {
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- VS Code Dark+ palette, adopted as a matched set (bg/cursorline/visual
      -- together) rather than one color in isolation - VS Code's own
      -- selection color (#264F78) only reads as visible against its own
      -- lighter #1e1e1e bg; grafting it onto the old near-black bg here left
      -- Visual selection indistinguishable from CursorLine
      local bg = "#1E1E1E"
      local bg_dark = "#181818"
      local bg_highlight = "#2A2D2E"
      local bg_search = "#613214"
      local bg_visual = "#264F78"
      local fg = "#D4D4D4"
      local fg_dark = "#969696"
      local fg_gutter = "#858585"
      local border = "#454545"

      require("tokyonight").setup({
        style = "night",
        on_colors = function(colors)
          colors.bg = bg
          colors.bg_dark = bg_dark
          colors.bg_float = bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = bg_dark
          colors.bg_statusline = bg_dark
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark
        end,
        on_highlights = function(hl, colors)
          -- VS Code Dark+ syntax/diagnostic colors
          hl.Comment = { fg = "#6A9955", italic = true }
          hl.String = { fg = "#CE9178" }
          hl.Keyword = { fg = "#569CD6" }
          hl.Function = { fg = "#DCDCAA" }
          hl.Type = { fg = "#4EC9B0" }

          -- diagnostics: keep fg vivid regardless of cursorline, and give
          -- underline/virtual text their own solid bg instead of a blended
          -- tint (the blend collapsed toward this bg and became invisible)
          hl.DiagnosticError = { fg = "#F14C4C" }
          hl.DiagnosticWarn = { fg = "#CCA700" }
          hl.DiagnosticInfo = { fg = "#3794FF" }
          hl.DiagnosticHint = { fg = "#B0B0B0" }

          hl.DiagnosticUnderlineError = { sp = "#F14C4C", undercurl = true }
          hl.DiagnosticUnderlineWarn = { sp = "#CCA700", undercurl = true }
          hl.DiagnosticUnderlineInfo = { sp = "#3794FF", undercurl = true }
          hl.DiagnosticUnderlineHint = { sp = "#B0B0B0", undercurl = true }

          hl.DiagnosticVirtualTextError = { fg = "#F14C4C", bg = bg_dark }
          hl.DiagnosticVirtualTextWarn = { fg = "#CCA700", bg = bg_dark }
          hl.DiagnosticVirtualTextInfo = { fg = "#3794FF", bg = bg_dark }
          hl.DiagnosticVirtualTextHint = { fg = "#B0B0B0", bg = bg_dark }

          -- cursorline must only tint bg, never touch fg (else error/warn
          -- text on the current line inherits cursorline's fg and vanishes)
          hl.CursorLine = { bg = bg_highlight }
          hl.CursorLineNr = { fg = fg, bold = true }

          -- Visual bg picked as a matched pair with bg/CursorLine above (see
          -- palette comment) - explicit here so it can't silently drift if
          -- tokyonight's own Visual definition changes upstream
          hl.Visual = { bg = bg_visual }
          hl.VisualNOS = { bg = bg_visual }
        end,
      })
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
