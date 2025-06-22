# ~/.zshrc

autoload -U zmv

fpath=(~/.zsh_completions $fpath)
eval "$(starship init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/frank/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/frank/bin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/frank/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/frank/bin/google-cloud-sdk/completion.zsh.inc'; fi

export EDITOR=nvim

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

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh" --no-use

# Created by `pipx` on 2022-03-13 21:35:41
export PATH="/Users/frank/.krew/bin:/Users/frank/.nvm/versions/node/v16.13.2/bin:/opt/homebrew/opt/libpq/bin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH:/Users/frank/.local/bin"

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

eval "$(atuin init zsh)"

source ~/src/dotfiles/zshrc_secrets

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
