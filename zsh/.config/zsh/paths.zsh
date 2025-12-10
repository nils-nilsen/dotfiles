# PATH exports
export PATH="${PATH}:${HOME}/bin"
export PATH="${PATH}:${HOME}/.local/bin" 
export PATH="${PATH}:/usr/local/sbin"
export PATH="${PATH}:${HOME}/.poetry/bin"
export PATH="${PATH}:${HOME}/.cargo/bin"
export PATH="${PATH}:${HOME}/go/bin"
export PATH="${PATH}/opt/homebrew/opt/python@3.13/libexec/bin"
export PATH="${PATH}:/opt/homebrew/opt/ruby@3.1/bin"
export PATH="${PATH}:/opt/homebrew/opt/libpq/bin"
export PATH="${PATH}:/Applications/IntelliJ IDEA.app/Contents/MacOS"

# homebrew coreutils (GNU versions)
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH" 2>/dev/null

# Work-specific (customize for your needs)
export DIRECTORY_PATH="/Users/nils/github/work"
export BINARY_TO_EXECUTE=/opt/homebrew/bin/code

export CDPATH=:~