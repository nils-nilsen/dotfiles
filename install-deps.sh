#!/bin/bash
# Dependencies installer for dotfiles

set -eu
set -o pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

install_homebrew() {
    if ! command -v brew &> /dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        log_info "Homebrew already installed"
    fi
}

install_packages() {
    log_info "Installing packages..."
    
    if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
        log_info "Using Brewfile for installation..."
        cd "$DOTFILES_DIR"
        brew bundle install
    else
        log_warn "No Brewfile found, installing essential packages manually..."
        brew install \
            gnu-stow \
            zoxide \
            fzf \
            starship \
            zsh-syntax-highlighting \
            zsh-history-substring-search \
            zsh-autosuggestions \
            lazygit \
            eza \
            bat \
            ripgrep \
            fd \
            delta \
            atuin
    fi
}

setup_fzf() {
    log_info "Setting up fzf key bindings..."
    if command -v fzf &> /dev/null; then
        $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
    fi
}

setup_atuin() {
    log_info "Setting up atuin (magical shell history)..."
    if command -v atuin &> /dev/null; then
        log_info "Atuin installed successfully!"
        log_warn "First time setup: Run 'atuin register' or 'atuin login' after installation"
        log_warn "Or use offline: 'atuin init' is already configured in zshrc"
    fi
}

setup_ohmyzsh() {
    log_info "Setting up oh-my-zsh..."
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        log_info "oh-my-zsh already installed"
    fi
}

main() {
    log_info "Installing dotfiles dependencies..."

    install_homebrew
    install_packages
    setup_ohmyzsh
    setup_fzf
    setup_atuin

    log_info "Dependencies installation complete!"
    log_info "Run './install-stow.sh' to install dotfiles"
}

main "$@"