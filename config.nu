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


CPU
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



DISK
#!/usr/bin/env nu

# Get disk usage for the root filesystem (/)
let disk_info = (
  run-external "df" "-h" "/"
  | complete
  | get stdout
  | lines
  | skip 1  # Skip the header line
  | first
  | split row " "  # Split by whitespace
  | where {|x| $x != ""}  # Remove empty entries
)

# Print parsed disk info for debugging
# print $"Parsed disk info: ( $disk_info )"

# Extract the total and available space values
let total = $disk_info | get 1  # The "Size" column (228Gi)
let available = $disk_info | get 3  # The "Avail" column (83Gi)

# Remove unit (Gi) and convert to integers
let total_int = ($total | str replace "Gi" "") | into int
let available_int = ($available | str replace "Gi" "") | into int

# Calculate the disk usage percentage
let disk_usage_percent = (((($total_int - $available_int) / $total_int) * 100))

# Round the result and remove the decimal
let rounded_disk_usage_percent = ($disk_usage_percent | math round)

# Output the result
$rounded_disk_usage_percent



RAM
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

# Extract various memory page counts
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

let pages_active = (
  $vm_stats 
  | where {|line| $line | str contains "Pages active:"} 
  | first 
  | parse --regex "Pages active:\\s+(\\d+)\\." 
  | get capture0.0 
  | into int
)

let pages_wired = (
  $vm_stats 
  | where {|line| $line | str contains "Pages wired down:"} 
  | first 
  | parse --regex "Pages wired down:\\s+(\\d+)\\." 
  | get capture0.0 
  | into int
)

let pages_compressed = (
  $vm_stats 
  | where {|line| $line | str contains "Pages occupied by compressor:"} 
  | first 
  | parse --regex "Pages occupied by compressor:\\s+(\\d+)\\." 
  | get capture0.0 
  | into int
)

let pages_speculative = (
  $vm_stats 
  | where {|line| $line | str contains "Pages speculative:"} 
  | first 
  | parse --regex "Pages speculative:\\s+(\\d+)\\." 
  | get capture0.0 
  | into int
)

let pages_purgeable = (
  $vm_stats 
  | where {|line| $line | str contains "Pages purgeable:"} 
  | first 
  | parse --regex "Pages purgeable:\\s+(\\d+)\\." 
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

# Calculate free memory differently - count more categories as "free"

let free_memory = $page_size * ($pages_free + $pages_speculative + $pages_purgeable + ($pages_inactive * 2 / 3))
# let free_memory = $page_size * ($pages_free + $pages_speculative + $pages_purgeable + ($pages_inactive / 3))

# Calculate RAM usage percentage with the new free memory calculation
let ram_usage = (
  (($total_memory - $free_memory) / $total_memory * 100) 
  | math round 
  | into int
)


# Format memory values in GB with 2 decimal places
let total_gb = (($total_memory / 1024 / 1024 / 1024) | math round -p 2)
let active_gb = (($pages_active * $page_size / 1024 / 1024 / 1024) | math round -p 2)
let wired_gb = (($pages_wired * $page_size / 1024 / 1024 / 1024) | math round -p 2)
let compressed_gb = (($pages_compressed * $page_size / 1024 / 1024 / 1024) | math round -p 2)
let inactive_gb = (($pages_inactive * $page_size / 1024 / 1024 / 1024) | math round -p 2)
let free_gb = (($pages_free * $page_size / 1024 / 1024 / 1024) | math round -p 2)
let speculative_gb = (($pages_speculative * $page_size / 1024 / 1024 / 1024) | math round -p 2)
let purgeable_gb = (($pages_purgeable * $page_size / 1024 / 1024 / 1024) | math round -p 2)

# Print memory breakdown
# print "Memory breakdown (GB):"
# print $"Total: ($total_gb)"
# print $"Active: ($active_gb)"
# print $"Wired: ($wired_gb)"
# print $"Compressed: ($compressed_gb)"
# print $"Inactive: ($inactive_gb)"
# print $"Free: ($free_gb)"
# print $"Speculative: ($speculative_gb)"
# print $"Purgeable: ($purgeable_gb)"
# print $"RAM Usage: ($ram_usage)%"

# Output the RAM usage percentage
$ram_usage
