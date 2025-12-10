# Dotfiles with Stow

Dotfiles management using [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Setup

```bash
# Clone the repository
git clone git@github.com:nils-hh/dotfiles.git
cd dotfiles

# Setup personal configuration
./setup-personal.sh  # Creates personal.conf from template

# Edit personal.conf with your information
vim personal.conf    # or use your preferred editor

# Apply personal configuration
./setup-personal.sh  # Applies your settings to dotfiles

# Install everything
make bootstrap       # Installs dependencies + symlinks dotfiles
```

## Personalization

This repository uses a `personal.conf` file to store your personal information. This file is **not tracked by git**.

**First time setup:**
1. Run `./setup-personal.sh` - creates `personal.conf` from template
2. Edit `personal.conf` with your details:
   ```bash
   GIT_USER_NAME="Your Name"
   GIT_USER_EMAIL="your.email@example.com"
   WORK_DIRECTORY="${HOME}/projects"  # Optional
   EDITOR_BINARY="/opt/homebrew/bin/code"  # Optional
   ```
3. Run `./setup-personal.sh` again - applies your settings
4. Run `make bootstrap` - installs everything

**Note:** The `work/` directory is excluded from git. Create it locally for company-specific configs if needed.

## Package Structure

Each directory is a "stow package" that mirrors your home directory structure:

```
dotfiles/
├── zsh/                    # Zsh configuration
│   ├── .zshenv             # → ~/.zshenv
│   └── .config/zsh/        # → ~/.config/zsh/
├── git/                    # Git configuration
│   ├── .gitconfig          # → ~/.gitconfig
│   └── .gitignore_global   # → ~/.gitignore_global
├── vim/                    # Vim configuration
│   └── .vimrc              # → ~/.vimrc
├── starship/               # Starship prompt
│   └── .starship.toml      # → ~/.starship.toml
├── lazygit/                # Lazygit TUI
│   └── .config/lazygit/config.yml
├── p10k/                   # Powerlevel10k theme (optional)
│   └── .p10k.zsh           # → ~/.p10k.zsh
└── work/                   # Work-specific configs (not stowed)
```

## Managing Packages

```bash
# Install specific package
stow zsh

# Update package (re-stow)
stow --restow git

# Remove package
stow --delete vim

# Install all packages
make stow

# Dry run (see what would happen)
make simulate
```

## Dependencies

Dependencies are managed via `Brewfile` and `install-deps.sh`:

```bash
# Install all dependencies
make deps
# or: ./install-deps.sh

# Key tools installed:
# - oh-my-zsh (zsh framework)
# - zoxide (smart cd)
# - fzf (fuzzy finder)
# - starship (prompt)
# - eza (better ls)
# - bat (better cat)
# - lazygit (git TUI)
# - atuin (shell history)
# - nvm (node version manager)
# - delta (git diff viewer)
```

## Makefile Commands

```bash
make              # Install deps + stow all packages
make bootstrap    # Full setup (same as above)
make deps         # Install dependencies only
make stow         # Stow all packages
make simulate     # Dry run - show what would happen
make uninstall    # Remove all symlinks
make list         # List available packages
make help         # Show all commands
```

## Useful Stow Commands

```bash
# Show what stow would do (dry run)
stow --no --verbose zsh

# Remove and reinstall
stow --delete zsh && stow zsh

# Verbose output
stow --verbose --target=$HOME --restow */
```
