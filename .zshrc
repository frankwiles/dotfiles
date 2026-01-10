# ~/.zshrc

autoload -U zmv

# Vim mode
bindkey -v

fpath=(~/.zsh_completions $fpath)
eval "$(starship init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/frank/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/frank/bin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/frank/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/frank/bin/google-cloud-sdk/completion.zsh.inc'; fi

export EDITOR=nvim

export DIRENV_WARN_TIMEOUT=60m

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

#########################
# Kubectl
#########################
# This is commmented out to help improve performance of zsh startup
# source <(kubectl completion zsh)
source ~/.zsh_completions/_kubectl
alias k=kubectl
alias kk="k9s --namespace $1"
compdef __start_kubectl k

# History
export HISTFILESIZE=10000000
export HISTSIZE=10000000
export HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt appendhistory
setopt incappendhistory
setopt share_history
# following should be turned off, if sharing history via setopt SHARE_HISTORY
#setopt INC_APPEND_HISTORY

# Compliation
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"

# Docker
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_SCAN_SUGGEST=false


# Cargo
. "$HOME/.cargo/env"

alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
alias grep=ggrep

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh" --no-use

# Git customization
alias r='cd $(git root)'
function rd() {
    fd "$1" $(git root)
}

export PYTHONDONTWRITEBYTECODE=true
export PIP_REQUIRE_VIRTUALENV=1

# Global pip install
function gpip() {
    PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

# Custom aider command line options
alias 'myaider'='aider --no-auto-commits --no-attribute-commit-message-committer --vim'

# thefuck
eval $(thefuck --alias)

# Ability to toggle on/off the pip venv requirement
toggle_pip_venv() {
  if [[ "${PIP_REQUIRE_VIRTUALENV}" == "1" ]]; then
    unset PIP_REQUIRE_VIRTUALENV
    echo "PIP_REQUIRE_VIRTUALENV is now OFF"
  else
    export PIP_REQUIRE_VIRTUALENV=1
    echo "PIP_REQUIRE_VIRTUALENV is now ON"
  fi
}

# Create custom Frank .envrc layout
setup_uv_project() {
    set -euo pipefail

    if [ ! -f ".local_env" ]; then
        echo "Creating .local_env"
        touch .local_env
    fi

    if [ ! -f ".envrc" ]; then
        echo "Creating .envrc"
        touch .envrc
        echo "layout_uv" >> .envrc
        echo "dotenv .local_env" >> .envrc
        echo "PATH_add ./bin/" >> .envrc
    fi
}

ackopen() {
  nvim $(ack -l "$@")
}

fullack() {
  ack --noenv $@
}

pulllog() {
  git log @{1}..
}

pulldiff() {
  git diff @{1}..
}

appleallow() {
  xattr -d com.apple.quarantine $@
}

# Remove any random Docker volumes that do not have real names from compose
remove_random_docker_volumes() {
  # List all volumes that don't contain hyphens or underscores
  volumes_to_remove=$(docker volume ls -q | grep -v '[-_]')

  # Check if any volumes were found
  if [[ -z "$volumes_to_remove" ]]; then
    echo "No volumes without hyphens or underscores found."
    exit 0
  fi

  # Show volumes that will be removed
  echo "The following volumes will be removed:"
  echo "$volumes_to_remove"

  # Ask for confirmation
  read -q "REPLY?Are you sure you want to remove these volumes? (y/n) "
  echo ""

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Remove each volume
    echo "$volumes_to_remove" | while read -r volume; do
      echo "Removing volume: $volume"
      docker volume rm "$volume"
    done
    echo "Done!"
  else
    echo "Operation cancelled."
  fi
}

new_justfile () {
  touch Justfile
  echo "@default:\n    just --list\n\n" >> Justfile 
}

eval "$(atuin init zsh)"

eval "$(zoxide init zsh)"

# Setup direnv
eval "$(direnv hook zsh)"

source ~/src/dotfiles/zshrc_secrets

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Zellij layout capture helper 
# Dump current zellij layout to a named file in ~/.config/zellij/layouts
zellij-save-layout() {
    local layout_name="$1"
    local layout_dir="$HOME/.config/zellij/layouts"

    if [[ -z "$layout_name" ]]; then
        echo "Usage: zellij-save-layout <layout-name>"
        return 1
    fi

    mkdir -p "$layout_dir" || {
        echo "Failed to create layout directory: $layout_dir"
        return 1
    }

    local target_file="$layout_dir/${layout_name}.kdl"

    # Dump the layout while safely redirecting to the file
    if zellij action dump-layout > "$target_file"; then
        echo "Layout saved to: $target_file"
    else
        echo "Failed to dump layout"
        return 1
    fi
}

# Claude Code Model Switcher Aliases
alias cc='claude'
alias ccg='claude-glm'
alias ccg46='claude-glm-4.6'
alias ccg45='claude-glm-4.5'
alias ccf='claude-glm-fast'
