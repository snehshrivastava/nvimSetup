return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio", -- required by dap-ui
		"theHamsta/nvim-dap-virtual-text", -- inline variable values
		"jay-babu/mason-nvim-dap.nvim", -- auto-install adapters via mason
	},
	-- lazy-loaded on first debug keypress (or require("dap"), e.g. from
	-- nvim-jdtls's setup_dap) instead of at startup: dap + dap-ui + nio +
	-- mason-nvim-dap were a large share of startup time for a debugger that
	-- most sessions never open
	keys = {
		{ "<leader>bb", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
		{
			"<leader>bB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: conditional breakpoint",
		},
		-- starting a new debug run while one's already active spawns a
		-- second debuggee process and orphans the first (leaked JVM/process
		-- kept running in background); terminate before continuing
		{
			"<leader>bc",
			function()
				local dap = require("dap")
				if dap.session() then
					dap.terminate(nil, nil, function()
						dap.continue()
					end)
				else
					dap.continue()
				end
			end,
			desc = "Debug: continue / start",
		},
		{ "<leader>bi", function() require("dap").step_into() end, desc = "Debug: step into" },
		{ "<leader>bo", function() require("dap").step_over() end, desc = "Debug: step over" },
		{ "<leader>bO", function() require("dap").step_out() end, desc = "Debug: step out" },
		{ "<leader>br", function() require("dap").repl.open() end, desc = "Debug: open REPL" },
		{ "<leader>bl", function() require("dap").run_last() end, desc = "Debug: run last" },
		{ "<leader>bu", function() require("dapui").toggle() end, desc = "Debug: toggle UI" },
		{ "<leader>bt", function() require("dap").terminate() end, desc = "Debug: terminate" },
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- auto-install debug adapters
		require("mason-nvim-dap").setup({
			ensure_installed = {
				"codelldb", -- rust / c / c++
				"delve", -- go
				"python", -- python (debugpy)
				"js", -- js / ts (js-debug-adapter)
			},
			automatic_installation = true,
			handlers = {}, -- use default adapter configs
		})

		-- .vscode/launch.json is read automatically on-demand now, no manual load needed

		dapui.setup()
		require("nvim-dap-virtual-text").setup()

		-- default terminal_win_cmd (string "belowright new") has no
		-- modified-flag reset after the split; some autocmd firing on the
		-- new window/buffer leaves it modified, and jobstart(term=true)
		-- on nvim 0.11+ refuses to termopen into a modified buffer
		dap.defaults.fallback.terminal_win_cmd = function(config)
			vim.cmd("belowright new")
			local buf = vim.api.nvim_get_current_buf()
			local win = vim.api.nvim_get_current_win()
			vim.bo[buf].modified = false
			return buf, win
		end

		-- open/close dap-ui automatically
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- breakpoint sign
		vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "Visual", numhl = "" })

		-- quitting nvim mid-debug otherwise leaves the debuggee process running
		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = function()
				if dap.session() then
					dap.terminate()
				end
			end,
		})
	end,
}
