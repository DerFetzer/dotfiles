-- Use the traversal keys to repeat the previous motion without
-- explicitly invoking Leap:
require('leap.user').set_repeat_keys('<enter>', '<backspace>')

-- Automatic paste after remote yank operations:
vim.api.nvim_create_autocmd('User', {
    pattern = 'RemoteOperationDone',
    group = vim.api.nvim_create_augroup('LeapRemote', {}),
    callback = function(event)
        if (vim.v.operator == 'y' or vim.v.operator == 'd') and event.data.register == '"' then
            vim.cmd('normal! p')
        end
    end,
})
