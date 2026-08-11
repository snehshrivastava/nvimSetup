return {
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local bg = "#011628"
      local bg_dark = "#011423"
      local bg_highlight = "#143652"
      local bg_search = "#0A64AC"
      local bg_visual = "#275378"
      local fg = "#CBE0F0"
      local fg_dark = "#B4D0E9"
      local fg_gutter = "#627E97"
      local border = "#547998"

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
          -- default Comment/String were tuned for tokyonight's stock (lighter)
          -- bg; against this custom near-black bg they were too dim to read
          hl.Comment = { fg = "#7691B0", italic = true }
          hl.String = { fg = "#8FD1A6" }

          -- diagnostics: keep fg vivid regardless of cursorline, and give
          -- underline/virtual text their own solid bg instead of a blended
          -- tint (the blend collapsed toward this bg and became invisible)
          hl.DiagnosticError = { fg = "#FF5D62" }
          hl.DiagnosticWarn = { fg = "#FFB454" }
          hl.DiagnosticInfo = { fg = "#4FD6E0" }
          hl.DiagnosticHint = { fg = "#8FD1A6" }

          hl.DiagnosticUnderlineError = { sp = "#FF5D62", undercurl = true }
          hl.DiagnosticUnderlineWarn = { sp = "#FFB454", undercurl = true }
          hl.DiagnosticUnderlineInfo = { sp = "#4FD6E0", undercurl = true }
          hl.DiagnosticUnderlineHint = { sp = "#8FD1A6", undercurl = true }

          hl.DiagnosticVirtualTextError = { fg = "#FF5D62", bg = bg_dark }
          hl.DiagnosticVirtualTextWarn = { fg = "#FFB454", bg = bg_dark }
          hl.DiagnosticVirtualTextInfo = { fg = "#4FD6E0", bg = bg_dark }
          hl.DiagnosticVirtualTextHint = { fg = "#8FD1A6", bg = bg_dark }

          -- cursorline must only tint bg, never touch fg (else error/warn
          -- text on the current line inherits cursorline's fg and vanishes)
          hl.CursorLine = { bg = bg_highlight }
          hl.CursorLineNr = { fg = fg, bold = true }
        end,
      })
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
