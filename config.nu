$env.PATH = ($env.PATH | prepend "$HOME")
$env.PATH = ($env.PATH | prepend '/opt/homebrew/bin')
$env.PATH = ($env.PATH | prepend "/Users/jasonjurotich/.surrealdb")
$env.PATH = ($env.PATH | prepend '/Users/jasonjurotich/.cargo/bin')
$env.PATH = ($env.PATH | prepend "$HOME/.local/bin")

# You can remove the redundant $env.PATH prepend here for /opt/homebrew/bin
$env.EDITOR = "/opt/homebrew/bin/hx"
$env.VISUAL = "/opt/homebrew/bin/hx"

$env.config.buffer_editor = "hx"
$env.config.edit_mode = 'vi'
$env.config.show_banner = false

# alias dh = git add -A; git commit -m "updated"; git push
# alias dg = git reset --hard HEAD; git clean -f -d; git pull

def dh [] {
  git add -A
  git commit -m "updated"
  git push
}

def dg [] {
  git reset --hard HEAD
  git clean -f -d
  git pull
}

alias py = python3
alias pq = psql postgres
alias pf = psql -U jj -d rustpr -a -f
alias ex = exit
alias cl = clear
alias t = tmux new -s s1
alias x = hx
alias j = zellij --layout /Users/jasonjurotich/.config/zellij/layouts/default.kdl options --default-shell nu
alias rr = cd /Users/jasonjurotich/Documents/RUSTDEV/rustglobal2/src
alias iedu = mosh jason_jurotich@35.232.94.202
alias jjorg = mosh jj@34.133.154.205


def cr [] {
  cargo run
}

def ccp [] {
  cargo clippy --fix
}

def tars [] {
  cargo clean
  TARGET_CC=x86_64-linux-musl-gcc cargo build --release --target x86_64-unknown-linux-musl
}

def tmuv2 [] {
  cd /Users/jj/Documents/adminbotbinaryv2
  rm admv2
  dh
  cd /Users/jasonjurotich/Documents/rustglobal/target/x86_64-unknown-linux-musl/release
  cp rustglobal /Users/jasonjurotich/Documents/adminbotbinaryv2/admv2
  cd /Users/jj/Documents/adminbotbinaryv2
  dh
  cd /Users/jasonjuurotich/Documents/rustglobal2
}

def deldeb [] {
    try {
        rm -r /Users/jasonjurotich/Documents/RUSTDEV/**/debug
    } catch {
        echo "No debug directories found, skipping..."
    }
}

def bigf [] {
du | sort-by physical --reverse | first 10
}

def bigfp [folder: string = "."] {
    du $folder | sort-by size --reverse | first 10
}

# mkdir ($nu.data-dir | path join "vendor/autoload")
# starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu"$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ": "
$env.PROMPT_INDICATOR_VI_NORMAL = "〉"
$env.PROMPT_MULTILINE_INDICATOR = "::: "

zoxide init nushell | save -f ~/.zoxide.nu
source ~/.zoxide.nu

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
source ~/.cache/carapace/init.nu

// put this in a nushell script to run it through helix. 
// Put it into the root directory /Users/jasonjurotich and then run chmod +x gits.nu to make it executable

# gits.nu

# Git commands
git add -A &>/dev/null 
git commit -m "updated" &>/dev/null
git push &>/dev/null


cpu_usage.nu
#!/usr/bin/env nu

# Extract the CPU usage line
let cpu_line = (
  run-external "top" "-l" "1" "-n" "0" 
  | complete
  | get stdout
  | lines
  | where {|line| $line | str contains "CPU usage"}
  | first
)

# Parse the idle percentage directly using regex
let idle = (
  $cpu_line
  | parse --regex ".*?(\\d+\\.\\d+)% idle.*"
  | get capture0.0
  | into float
)

# Calculate CPU usage percentage and round to nearest integer
let usage = (100.0 - $idle | math round | into int)

# Output the result
$usage





#!/usr/bin/env nu

# Get memory info from vm_stat
let vm_stats = (run-external "vm_stat" | complete | get stdout | lines)

# Extract page size (usually 4096 bytes or 4KB on macOS)
let page_size = (
  $vm_stats 
  | where {|line| $line | str contains "page size of"} 
  | first
  | parse --regex "page size of (\\d+) bytes"
  | get capture0.0
  | into int
)

# Extract free and total memory pages
let pages_free = (
  $vm_stats 
  | where {|line| $line | str contains "Pages free:"} 
  | first
  | parse --regex "Pages free:\\s+(\\d+)\\."
  | get capture0.0
  | into int
)

let pages_inactive = (
  $vm_stats 
  | where {|line| $line | str contains "Pages inactive:"} 
  | first
  | parse --regex "Pages inactive:\\s+(\\d+)\\."
  | get capture0.0
  | into int
)

# Get total physical memory
let total_memory = (
  run-external "sysctl" "-n" "hw.memsize" 
  | complete
  | get stdout
  | str trim
  | into int
)

# Calculate free memory in bytes
let free_memory = ($page_size * ($pages_free + $pages_inactive))

# Calculate usage percentage (rounded to integer)
let ram_usage = (
  (($total_memory - $free_memory) / $total_memory * 100) 
  | math round 
  | into int
)

# Output the result
$ram_usage


#!/usr/bin/env nu

# Get disk usage for the root filesystem (/)
let disk_info = (
  run-external "df" "-h" "/" 
  | complete
  | get stdout
  | lines
  | skip 1  # Skip the header line
  | first
)

# Parse the disk usage percentage
let disk_usage = (
  $disk_info
  | split row " "
  | where {|part| $part != ""}  # Remove empty strings
  | get 4  # The percentage field (may need adjustment)
  | str replace "%" ""  # Remove the % symbol
  | into int
)

# Output the result
$disk_usage



#!/usr/bin/env nu

# Note: This script requires sudo privileges to run powermetrics.
# Ensure you have recently authenticated with sudo (e.g., run 'sudo -v' in your terminal first)

# Configuration
let sample_interval_ms = 500
let samples_to_take = 1
let target_metric_name = "GPU HW active residency"
let target_regex = 'GPU HW active residency:\s*(?<value>[\d\.]+)%'
let power_regex = '.*?:\s*(?<value>[\d\.]+)\s*mW.*'

# --- Run powermetrics ---
let gpu_data = (
    do -i {
        run-external "sudo" "powermetrics" "--samplers" "gpu_power" "-n" $samples_to_take "-i" $sample_interval_ms
        | complete
        | get stdout
    }
)

if ($gpu_data | is-empty) {
    print "Error: powermetrics command failed or produced no output. Ensure sudo was used."
    exit 1
}

# --- Data Extraction ---
let gpu_line = (
    $gpu_data
    | lines
    | where {|line| $line | str contains $target_metric_name }
    | get 0
)

if ($gpu_line | is-not-empty) {
    print $"Debug: Found target metric line: ($gpu_line)"

    let gpu_percentage_result = (
        $gpu_line
        | parse --regex $target_regex
        | get value? | get 0
    )

    print $"Debug: Parsed result: ($gpu_percentage_result | to nuon)"

    if ($gpu_percentage_result | is-not-empty) {
        print $"Debug: Extracted GPU percentage result before conversion: ($gpu_percentage_result)"
        print $"Debug: Type of extracted value: ({$gpu_percentage_result | describe})"

        try {
            let cleaned_value = (
                $gpu_percentage_result
                | into string
                | str trim
            )
            print $"Debug: Cleaned value before conversion: ($cleaned_value)"
            print $"Debug: Type of cleaned value: ({$cleaned_value | describe})"

            let float_value = ($cleaned_value | into float)
            print $"Debug: Successfully converted to float: ($float_value)"

            $float_value
                | math round --precision 0
                | into int
        } catch {
            print $"Warning: Could not convert extracted value '($gpu_percentage_result)' to float. Using default 0."
            0
        }
    } else {
        print $"Warning: Regex failed to extract percentage value from line: ($gpu_line). Outputting 0."
        0
    }
} else {
    print "Debug: Target metric line not found. Using GPU Power fallback."

    let gpu_power_result_str = (
        $gpu_data
        | lines
        | where {|line| $line | str contains "GPU Power:"}
        | get 0
        | if ($in | is-not-empty) {
              $in | parse --regex $power_regex | get value?
          } else {
              null
          }
    )

    print $"Debug: Extracted GPU Power result: ($gpu_power_result_str | to nuon)"

    if ($gpu_power_result_str | is-not-empty) {
        print $"Debug: Found GPU Power: ($gpu_power_result_str) mW"
        try {
            let gpu_power_watts = ($gpu_power_result_str | into float | $in / 1000.0)
            let max_gpu_power_watts = 20.0
            let calculated_percentage = ($gpu_power_watts / $max_gpu_power_watts * 100.0)

            print $"Debug: Calculated GPU percentage from power: ($calculated_percentage)"

            $calculated_percentage
                | round --digits 0
                | into int
                | if $in < 0 { 0 } else { if $in > 100 { 100 } else { $in } }
        } catch {
            print $"Warning: Could not convert extracted power value '($gpu_power_result_str | to nuon)' to float. Outputting 0."
            0
        }
    } else {
        print "Error: Could not determine GPU usage. Target line and Power metric both failed."
        0
    }
}
