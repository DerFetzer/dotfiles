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

def flac-to-mp3-recursive [] {
    let flacs = glob **/*.flac
    let mp3s = glob **/*.mp3
    ($flacs 
        | path parse
        | filter {|f| $in | update extension "mp3" | path join | $in not-in $mp3s}
        | sort
        | par-each -t 8 {|in| run-external "ffmpeg" "-i" $"($in | path join)" "-codec:a" "libmp3lame" "-qscale:a" "2" $"($in | update extension "mp3" | path join)"}
        | ignore
    )
}

def create-cold-archives [target: path] {
    let files = ls | get "name"
    let passphrase = ($env.BACKUP_PASSPHRASE? | if $in != null { print "use passphrase from env"; $in } else { print "input passphrase"; (input -s) } )
    mkdir $target
    for $file in $files {
        print "process " $file "..."
        let gpgtar_file = [($target | path join ($file | path basename)), ".gpgtar"] | str join
        run-external "gpgtar" "-c" "--symmetric" "--no-compress" "-o" $gpgtar_file (["--gpg-args=--cipher-algo AES256 --pinentry-mode loopback --passphrase=", $passphrase] | str join) $file
        run-external "par2" "c" "-n1" "-r5" $gpgtar_file
    }
    touch ( $target | path join "backup_dir")
}

def restore-cold-archives [target: path] {
    let gpgtar_files = ls *.gpgtar | get "name"
    let passphrase = ($env.BACKUP_PASSPHRASE? | if $in != null { print "use passphrase from env"; $in } else { print "input passphrase"; (input -s) } )
    mkdir $target
    for $gpgtar_file in $gpgtar_files {
        print "process " $gpgtar_file "..."
        run-external "par2" "r" ([$gpgtar_file, ".par2"] | str join)
        run-external "gpgtar" "-d" "-C" $target (["--gpg-args=--pinentry-mode loopback --passphrase=", $passphrase] | str join) $gpgtar_file
    }
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
# if (is-linux) and not ((is-in-nvim) or (is-in-zellij) or (is-in-wezterm)) {
#     exec zellij
# }

source zoxide.nu
