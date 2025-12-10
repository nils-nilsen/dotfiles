#!/bin/bash

set -eu
set -o pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    log_info "Installing GNU Stow..."
    if command -v brew &> /dev/null; then
        brew install stow
    else
        log_error "Homebrew not found. Please install GNU Stow manually."
        exit 1
    fi
fi

# Backup existing dotfiles
log_info "Backing up existing dotfiles..."
backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

# Files to backup and remove (both regular files and symlinks)
files_to_handle=(
    ".zshrc"
    ".zshenv" 
    ".gitconfig"
    ".gitignore_global"
    ".my_gitignore"
    ".vimrc"
    ".p10k.zsh"
    ".aliases"
    ".starship.toml"
    ".config/lazygit/config.yml"
)

for file in "${files_to_handle[@]}"; do
    if [[ -e "$HOME/$file" ]]; then
        if [[ -L "$HOME/$file" ]]; then
            # It's a symlink - just remove it
            log_warn "Removing existing symlink $file"
            rm -f "$HOME/$file"
        else
            # It's a regular file - backup then remove
            log_warn "Backing up existing $file"
            mkdir -p "$backup_dir/$(dirname "$file")"
            cp "$HOME/$file" "$backup_dir/$file"
            rm -f "$HOME/$file"
        fi
    fi
done

# Change to dotfiles directory
cd "$DOTFILES_DIR"

# Install all stow packages
log_info "Installing dotfiles with GNU Stow..."

# Get all package directories (exclude hidden files and non-directories)
packages=($(find . -maxdepth 1 -type d -not -path '.' -not -path './.*' -not -path './ansible' -not -path './work' -not -path './templates' -not -path './packages' | sed 's|^\./||'))

for package in "${packages[@]}"; do
    log_info "Stowing $package..."
    stow --verbose --target="$HOME" --restow "$package"
done

# Note: lazygit config is handled by stow automatically now

log_info "✅ Stow setup complete!"
log_info "📦 Backup created at: $backup_dir"
log_info ""
log_info "Next steps:"
log_info "1. Restart your terminal or run: exec zsh"
log_info "2. Enjoy your dotfiles!"