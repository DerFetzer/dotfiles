-- Use the traversal keys to repeat the previous motion without
-- explicitly invoking Leap:
require('leap.user').set_repeat_keys('<enter>', '<backspace>')

-- Highly recommended: define a preview filter to reduce visual noise
-- and the blinking effect after the first keypress.
-- For example, define word boundaries as the common case, that is, skip
-- preview for matches starting with whitespace or an alphabetic
-- mid-word character: foobar[baaz] = quux
--                     ^    ^^^  ^^ ^ ^  ^
require('leap').opts.preview = function(ch0, ch1, ch2)
    return not (
        ch1:match('%s')
        or (ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
    )
end

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
