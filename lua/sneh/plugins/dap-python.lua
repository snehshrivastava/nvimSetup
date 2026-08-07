return {
  "mfussenegger/nvim-dap-python",
  ft = "python",
  config = function()
    local mason_registry = require("mason-registry")
    local debugpy_path = mason_registry.get_package("debugpy"):get_install_path()
    require("dap-python").setup(debugpy_path .. "/venv/bin/python")
  end,
}
