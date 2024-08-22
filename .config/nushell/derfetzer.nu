def is-linux [] {
    let os_version = sys host | get "name" | str downcase
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

def git-log [--limit: int = 50] {
    git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD -n ($limit)
        | lines
        | split column "»¦«" commit subject name email date
        | upsert date {|d| $d.date | into datetime}
        | sort-by date | reverse
}

def process-et-log [file: path] {
    let log_lines = open $file | lines
    mut log_records = []
    mut current_record: any = null

    for $line in $log_lines {
        let line = ($line | str trim)
        let date = try {
            $line | split row " " | first | into datetime
        }
        if $date != null {
            if current_record != null {
                $log_records = ($log_records | append $current_record)
            }
            let log_info = $line | parse "{date} {time} {thread_id} {location} {level}:"
            let log_time = $"($log_info.0.date) ($log_info.0.time)" | into datetime
            let log_info = (
                $log_info
                    | insert timestamp {|row| ($"($row.date) ($row.time)" | into datetime)}
                    | move timestamp --before date
            )
            $current_record = ($log_info | insert log "")
        } else if $current_record != null {
            $current_record = (
                $current_record
                    | update log {
                        |r| $r.log
                            | append $line
                            | str join "\n"
                            | str trim
                    }
            )
        }
    }
    $log_records
}

# https://github.com/nushell/nushell/issues/247#issuecomment-2209629106
def disown [...command: string] {
        sh -c '"$@" </dev/null >/dev/null 2>/dev/null & disown' $command.0 ...$command
}

do { pueue clean | complete } # Workaround for https://github.com/Nukesor/pueue/issues/541
let pueue_status = do { pueue status } | complete
if $pueue_status.exit_code != 0 {
    do { pueued -d }
}

source atuin_init.nu

# Zellij
if (is-linux) and not ((is-in-nvim) or (is-in-zellij) or (is-in-wezterm)) {
    exec zellij
}

source zoxide.nu
