return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio", -- required by dap-ui
		"theHamsta/nvim-dap-virtual-text", -- inline variable values
		"jay-babu/mason-nvim-dap.nvim", -- auto-install adapters via mason
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

		-- keymaps
		local keymap = vim.keymap
		keymap.set("n", "<leader>bb", dap.toggle_breakpoint, { desc = "Debug: toggle breakpoint" })
		keymap.set("n", "<leader>bB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: conditional breakpoint" })
		-- starting a new debug run while one's already active spawns a
		-- second debuggee process and orphans the first (leaked JVM/process
		-- kept running in background); terminate before continuing
		keymap.set("n", "<leader>bc", function()
			if dap.session() then
				dap.terminate(nil, nil, function()
					dap.continue()
				end)
			else
				dap.continue()
			end
		end, { desc = "Debug: continue / start" })
		keymap.set("n", "<leader>bi", dap.step_into, { desc = "Debug: step into" })
		keymap.set("n", "<leader>bo", dap.step_over, { desc = "Debug: step over" })
		keymap.set("n", "<leader>bO", dap.step_out, { desc = "Debug: step out" })
		keymap.set("n", "<leader>br", dap.repl.open, { desc = "Debug: open REPL" })
		keymap.set("n", "<leader>bl", dap.run_last, { desc = "Debug: run last" })
		keymap.set("n", "<leader>bu", dapui.toggle, { desc = "Debug: toggle UI" })
		keymap.set("n", "<leader>bt", dap.terminate, { desc = "Debug: terminate" })

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
