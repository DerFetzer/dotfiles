local py
if vim.fn.has("win32") == 1 then
    py = "c:\\Python39\\scripts\\python.exe"
else
    py = "/usr/bin/python"
end

require('dap-python').setup(py)
