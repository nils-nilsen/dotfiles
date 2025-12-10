# Dotfiles shortcuts
alias dfe="$DOTFILES_DIR/execute.sh"
alias dfr="cd $DOTFILES_DIR"

# System utilities  
alias p='ps -Ao user,pid,%cpu,%mem,vsz,rss,tt,stat,start,time,command'
alias lg='lazygit'
alias air='~/.air'
alias ls='LC_COLLATE=C ls'

# Editor
alias v='nvim'
alias vv='fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs nvim'

# Git shortcuts
alias pull="git fetch --tags --force && git pull"

# Development
function idea() {
    open -a "GoLand" "$1" 
}

function killPort() {
	set -xe
	local port=$1
	process=$(lsof -nP -iTCP:$port | grep LISTEN | head -n1 | cut -d" " -f2)
	kill -9 $process
	set +xe
}

function brewUp() {
	brew update
	brew upgrade
	brew cleanup
	brew doctor
	brew autoremove
	brew cleanup --prune=all
}

function cleanupBranches() {
	git branch --merged | grep -v "main" >/tmp/merged-branches && vi /tmp/merged-branches && xargs git branch -d </tmp/merged-branches
}

function removeNonRemoteBranches() {
	git fetch -p
	git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d
}

function cleanupDocker() {
	docker network prune -f
	docker container prune
    docker image prune -fa
    docker volume prune -fa
    docker system prune -fa
}

# Install all global npm packages from dotfiles list
function install-npm-globals() {
  if [[ -f "$DOTFILES_DIR/packages/npm-global.txt" ]]; then
    echo "Installing global npm packages..."
    while read pkg; do
      [[ -n "$pkg" ]] && npm install -g "$pkg"
    done < "$DOTFILES_DIR/packages/npm-global.txt"
  else
    echo "No npm-global.txt found."
  fi
}