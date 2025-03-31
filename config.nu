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

