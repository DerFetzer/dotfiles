if (is-terminal --stdin) and (is-terminal --stdout) {
    let tmux_current = ($env.TMUX? | default "")
    let tmux_previous = ($env.ATUIN_HEX_TMUX? | default "")

    if ($env.ATUIN_HEX_ACTIVE? | default "" | is-empty) or ($tmux_current != $tmux_previous) {
        $env.ATUIN_HEX_ACTIVE = "1"
        $env.ATUIN_HEX_TMUX = $tmux_current
        exec atuin hex
    }
}
