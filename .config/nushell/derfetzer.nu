def is-linux [] {
    let $os_version = sys host | get "name" | str downcase
    "linux" in $os_version
}

def is-in-nvim [] {
    "NVIM" in $env
}

def is-in-zellij [] {
    "ZELLIJ" in $env
}

# https://github.com/nushell/nushell/issues/247#issuecomment-2209629106
def disown [...command: string] {
        sh -c '"$@" </dev/null >/dev/null 2>/dev/null & disown' $command.0 ...$command
}

do { pueue clean | ignore } # Workaround for https://github.com/Nukesor/pueue/issues/541
let pueue_status = do { pueue status } | complete
if $pueue_status.exit_code != 0 {
    do { pueued -d }
}

source atuin_init.nu

# Zellij
if (is-linux) and not (is-in-nvim) and not (is-in-zellij) {
    exec zellij
}
