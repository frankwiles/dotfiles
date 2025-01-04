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

# Global pip install
function gpip() {
    PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

export PYTHONDONTWRITEBYTECODE=true
export PIP_REQUIRE_VIRTUALENV=true

eval "$(atuin init zsh)"

source ~/src/dotfiles/zshrc_secrets

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
