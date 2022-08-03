local context
if vim.fn.has("win32") == 1 then
    context = false
else
    context = true
end

require("indent_blankline").setup {
    -- for example, context is off by default, use this to turn it on
    -- Crashes on Windows
    show_current_context = context,
    show_current_context_start = context,
}
