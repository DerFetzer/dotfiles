local py
if vim.fn.has("win32") == 1 then
    py = "c:\\Python39\\python.exe"
else
    py = "/usr/bin/python"
end

require('dap-python').setup(py)
require('dapui').setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
