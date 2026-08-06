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

		-- auto-load per-project debug config from .vscode/launch.json, if present
		require("dap.ext.vscode").load_launchjs()

		dapui.setup()
		require("nvim-dap-virtual-text").setup()

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
		keymap.set("n", "<leader>bc", dap.continue, { desc = "Debug: continue / start" })
		keymap.set("n", "<leader>bi", dap.step_into, { desc = "Debug: step into" })
		keymap.set("n", "<leader>bo", dap.step_over, { desc = "Debug: step over" })
		keymap.set("n", "<leader>bO", dap.step_out, { desc = "Debug: step out" })
		keymap.set("n", "<leader>br", dap.repl.open, { desc = "Debug: open REPL" })
		keymap.set("n", "<leader>bl", dap.run_last, { desc = "Debug: run last" })
		keymap.set("n", "<leader>bu", dapui.toggle, { desc = "Debug: toggle UI" })
		keymap.set("n", "<leader>bt", dap.terminate, { desc = "Debug: terminate" })
	end,
}
