return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    -- gd/gi/gt/gR jump in the current window (telescope's default
    -- jump_type) - no new tab or split unless one is asked for explicitly
    -- with the picker's own <C-t>/<C-x>/<C-v>. The attach_mappings override
    -- stays because telescope's multi-result <CR> path needs the explicit
    -- cursor placement + zz; jump_type only governs the single-result
    -- auto-jump.
    local function jump_opts()
      return {
        attach_mappings = function(prompt_bufnr, _)
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")
          actions.select_default:replace(function()
            local entry = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if not entry then
              return
            end
            local target = vim.fn.fnamemodify(entry.filename, ":p")
            if target ~= vim.fn.expand("%:p") then
              vim.cmd("edit " .. vim.fn.fnameescape(target))
            end
            if entry.lnum then
              vim.api.nvim_win_set_cursor(0, { entry.lnum, math.max((entry.col or 1) - 1, 0) })
            end
            vim.cmd("normal! zz")
          end)
          return true
        end,
      }
    end

    -- the multi-result path above centers synchronously right after
    -- nvim_win_set_cursor, but telescope's single-result auto-jump (still
    -- covered by jump_opts() above) happens inside its own async LSP
    -- buf_request_all callback - nothing to chain onto from out here, so
    -- arm a one-shot CursorMoved instead. Harmless if it fires early on the
    -- multi-result picker taking focus first: that's a no-op zz on a
    -- floating window, and the real jump above centers again regardless.
    --
    -- When the request finds nothing ("No definitions found") no jump
    -- happens, and the armed autocmd would otherwise recenter on whatever
    -- unrelated cursor move came next - so it disarms itself after a short
    -- window. An LSP answer slower than that just isn't centered.
    local function centered(fn)
      return function()
        local id = vim.api.nvim_create_autocmd("CursorMoved", {
          once = true,
          callback = function()
            pcall(vim.cmd, "normal! zz")
          end,
        })
        vim.defer_fn(function()
          pcall(vim.api.nvim_del_autocmd, id)
        end, 2000)
        fn()
      end
    end

    -- vim.lsp.buf.declaration has no telescope wrapper (telescope.builtin
    -- has no lsp_declarations); on_list fires uniformly for 1 or many
    -- results, unlike telescope's split single/multi handling above
    local function goto_declaration()
      vim.lsp.buf.declaration({
        on_list = function(t)
          if #t.items == 1 then
            local item = t.items[1]
            local target = vim.fn.fnamemodify(item.filename, ":p")
            if target ~= vim.fn.expand("%:p") then
              vim.cmd("edit " .. vim.fn.fnameescape(target))
            end
            vim.api.nvim_win_set_cursor(0, { item.lnum, math.max((item.col or 1) - 1, 0) })
            vim.cmd("normal! zz")
          else
            vim.fn.setqflist({}, " ", t)
            vim.cmd("copen")
          end
        end,
      })
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", centered(function()
          require("telescope.builtin").lsp_references(jump_opts())
        end), opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", goto_declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", centered(function()
          require("telescope.builtin").lsp_definitions(jump_opts())
        end), opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", centered(function()
          require("telescope.builtin").lsp_implementations(jump_opts())
        end), opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", centered(function()
          require("telescope.builtin").lsp_type_definitions(jump_opts())
        end), opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

        -- highlight other uses of symbol under cursor
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method("textDocument/documentHighlight") then
          local hl_group = vim.api.nvim_create_augroup("UserLspDocumentHighlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = hl_group,
            buffer = ev.buf,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            group = hl_group,
            buffer = ev.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#3a3a3a" })
    vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#3a3a3a" })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#4a3a3a" })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    vim.diagnostic.config({
      -- gutter icons: nvim 0.11+ ignores sign_define("DiagnosticSign*", ...),
      -- so they must be set here or the gutter falls back to plain E/W/I/H
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
      underline = true,
      virtual_text = { spacing = 4, source = "if_many" },
      severity_sort = true,
    })

    -- apply capabilities to every server (mason-lspconfig auto-enables installed servers)
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    vim.lsp.config("svelte", {
      on_attach = function(client, bufnr)
        -- one autocmd per client: on_attach runs for every svelte buffer, and
        -- an ungrouped autocmd stacked a duplicate notify on each attach
        vim.api.nvim_create_autocmd("BufWritePost", {
          group = vim.api.nvim_create_augroup("UserSvelteTsNotify" .. client.id, { clear = true }),
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            -- Here use ctx.match instead of ctx.file
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
          end,
        })
      end,
    })

    vim.lsp.config("graphql", {
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    vim.lsp.config("emmet_ls", {
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })
  end,
}
