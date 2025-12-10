#!/bin/bash
# Setup script to configure personal information

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PERSONAL_CONF="${DOTFILES_DIR}/personal.conf"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Setting up personal configuration...${NC}\n"

# Check if personal.conf exists
if [[ ! -f "$PERSONAL_CONF" ]]; then
    echo -e "${YELLOW}personal.conf not found!${NC}"
    echo "Creating from template..."
    cp "${DOTFILES_DIR}/personal.conf.example" "$PERSONAL_CONF"
    echo -e "${RED}Please edit personal.conf with your information and run this script again.${NC}"
    exit 1
fi

# Source the personal configuration
source "$PERSONAL_CONF"

# Update git config
echo -e "${GREEN}Updating git configuration...${NC}"
if [[ -n "$GIT_USER_NAME" && -n "$GIT_USER_EMAIL" ]]; then
    if [[ -f "${DOTFILES_DIR}/git/.gitconfig" ]]; then
        sed -i.bak "s/name = .*/name = $GIT_USER_NAME/" "${DOTFILES_DIR}/git/.gitconfig"
        sed -i.bak "s/email = .*/email = $GIT_USER_EMAIL/" "${DOTFILES_DIR}/git/.gitconfig"
        rm "${DOTFILES_DIR}/git/.gitconfig.bak"
        echo "  ✓ Git user: $GIT_USER_NAME <$GIT_USER_EMAIL>"
    else
        echo -e "${YELLOW}  ⚠ git/.gitconfig not found${NC}"
    fi
else
    echo -e "${YELLOW}  ⚠ Git user info not set in personal.conf${NC}"
fi

# Update work directory path
if [[ -n "$WORK_DIRECTORY" ]]; then
    echo -e "${GREEN}Updating work directory paths...${NC}"
    sed -i.bak "s|export DIRECTORY_PATH=.*|export DIRECTORY_PATH=\"$WORK_DIRECTORY\"|" "${DOTFILES_DIR}/zsh/.config/zsh/.zshrc"
    sed -i.bak "s|export DIRECTORY_PATH=.*|export DIRECTORY_PATH=\"$WORK_DIRECTORY\"|" "${DOTFILES_DIR}/zsh/.config/zsh/paths.zsh"
    rm "${DOTFILES_DIR}/zsh/.config/zsh/.zshrc.bak" "${DOTFILES_DIR}/zsh/.config/zsh/paths.zsh.bak"
    echo "  ✓ Work directory: $WORK_DIRECTORY"
fi

# Update editor binary
if [[ -n "$EDITOR_BINARY" ]]; then
    sed -i.bak "s|export BINARY_TO_EXECUTE=.*|export BINARY_TO_EXECUTE=$EDITOR_BINARY|" "${DOTFILES_DIR}/zsh/.config/zsh/.zshrc"
    sed -i.bak "s|export BINARY_TO_EXECUTE=.*|export BINARY_TO_EXECUTE=$EDITOR_BINARY|" "${DOTFILES_DIR}/zsh/.config/zsh/paths.zsh"
    rm "${DOTFILES_DIR}/zsh/.config/zsh/.zshrc.bak" "${DOTFILES_DIR}/zsh/.config/zsh/paths.zsh.bak"
    echo "  ✓ Editor: $EDITOR_BINARY"
fi

echo -e "\n${GREEN}✓ Personal configuration applied!${NC}"
echo "You can now run: make bootstrap"
