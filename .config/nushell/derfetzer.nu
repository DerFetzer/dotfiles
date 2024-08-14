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

def is-in-wezterm [] {
    "WEZTERM_EXECUTABLE" in $env
}

def git-log [limit: int = 50] {
    git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD -n ($limit) |
        lines |
        split column "»¦«" commit subject name email date |
        upsert date {|d| $d.date | into datetime} |
        sort-by date | reverse
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
if (is-linux) and not ((is-in-nvim) or (is-in-zellij) or (is-in-wezterm)) {
    exec zellij
}
