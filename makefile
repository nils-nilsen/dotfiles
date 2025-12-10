all: deps stow

deps:
	@if [ -f "./install-deps.sh" ]; then \
		./install-deps.sh; \
	else \
		brew bundle install; \
	fi

stow:
	stow --verbose --target=$$HOME --restow */

install:
	brew install stow

uninstall:
	stow --verbose --target=$$HOME --delete */

simulate:
	stow --no --verbose --target=$$HOME --restow */

list:
	@echo "Available packages:"
	@find . -maxdepth 1 -type d -not -path '.' -not -path './.*' -not -path './ansible' -not -path './work' -not -path './templates' -not -path './packages' | sed 's|^\./|  - |'

bootstrap:
	./install-deps.sh && ./install-stow.sh

help:
	@echo "Available commands:"
	@echo "  make           - Install dependencies + packages"
	@echo "  make deps      - Install dependencies only" 
	@echo "  make stow      - Install dotfiles only"
	@echo "  make bootstrap - Full setup (deps + stow)"
	@echo "  make install   - Install GNU Stow"
	@echo "  make uninstall - Remove all symlinks"  
	@echo "  make simulate  - Show what would be done (dry-run)"
	@echo "  make list      - List available packages"
	@echo "  make help      - Show this help"
	@echo ""
	@echo "Individual packages:"
	@echo "  stow <package> - Install specific package"
	@echo "  stow --delete <package> - Remove specific package"

.PHONY: all deps stow bootstrap install uninstall simulate list help