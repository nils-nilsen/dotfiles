# Initialize Homebrew first (required for all Homebrew-installed tools)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

export XDG_CONFIG_HOME="$HOME/.config"

# Dynamically determine dotfiles directory from this file's location
export DOTFILES_DIR="${${(%):-%x}:A:h:h:h:h}"

export ZSH="${HOME}/.oh-my-zsh"
export TERM="xterm-256color"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=23'
#ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  docker
  docker-compose
  common-aliases
  command-not-found
  colored-man-pages
  autojump
)
source $ZSH/oh-my-zsh.sh

# Source Homebrew-installed zsh plugins
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

setopt NO_NOMATCH

# Source work-specific configuration if it exists
# Create work/ directory with your company-specific configs (not tracked by git)
if [[ -d "${DOTFILES_DIR}/work" ]]; then
  for work_config in ${DOTFILES_DIR}/work/**/*(N); do
    [[ -f "$work_config" ]] && source "$work_config"
  done
fi

if [ -z "$SSH_AUTH_SOCK" ]; then
  eval $(ssh-agent -s) >/dev/null
  ssh-add 2>/dev/null
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
export VISUAL=vim
export EDITOR="$VISUAL"

# SOURCING
export PATH="${PATH}:${HOME}/bin"
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:/usr/local/sbin"
export PATH="${PATH}:${HOME}/.poetry/bin"
export PATH="${PATH}:${HOME}/.cargo/bin"
export PATH="${PATH}:${HOME}/go/bin"
export PATH="${PATH}:/opt/homebrew/opt/python@3.13/libexec/bin"
export PATH="${PATH}:/opt/homebrew/opt/ruby@3.1/bin"
export PATH="${PATH}:/opt/homebrew/opt/libpq/bin"
export PATH="${PATH}:/Applications/IntelliJ IDEA.app/Contents/MacOS"

# Work-specific paths (customize these for your needs)
export DIRECTORY_PATH="/Users/nils/github/work"
export BINARY_TO_EXECUTE=/opt/homebrew/bin/code

export CDPATH=:~

# Source aliases from dotfiles
source $DOTFILES_DIR/zsh/.config/zsh/aliases.zsh

[[ -f ~/.github_token ]] && export GH_ACCESS_TOKEN=$(cat ~/.github_token)

# Atuin shell history (installed via Homebrew)
eval "$(atuin init zsh)"


eval "$(starship init zsh)"

export STARSHIP_CONFIG="$HOME/.starship.toml"