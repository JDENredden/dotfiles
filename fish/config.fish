# ─────────────────────────────────────────────────────────────
# PATH Configuration
# ─────────────────────────────────────────────────────────────

# Homebrew (hardcoded for faster startup)
set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
set -gx HOMEBREW_REPOSITORY /opt/homebrew
fish_add_path /opt/homebrew/bin /opt/homebrew/sbin

# Homebrew Python (unversioned symlinks: python, pip)
fish_add_path /opt/homebrew/opt/python/libexec/bin

# Bun
set -gx BUN_INSTALL "$HOME/.bun"
test -d $BUN_INSTALL/bin
    and fish_add_path $BUN_INSTALL/bin

# LM Studio CLI
test -d ~/.lmstudio/bin
    and fish_add_path ~/.lmstudio/bin

# ─────────────────────────────────────────────────────────────
# Environment Variables
# ─────────────────────────────────────────────────────────────
set -gx EDITOR cot
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx SSH_AUTH_SOCK ~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

# ─────────────────────────────────────────────────────────────
# Interactive Shell Configuration
# ─────────────────────────────────────────────────────────────
if status is-interactive
    # libmediainfo library path
    set -gx DYLD_FALLBACK_LIBRARY_PATH /opt/homebrew/opt/libmediainfo/lib $DYLD_FALLBACK_LIBRARY_PATH

    # ─────────────────────────────────────────────────────────
    # Abbreviations (expand as you type)
    # ─────────────────────────────────────────────────────────
    # Navigation
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'

    # Git
    abbr -a g git
    abbr -a ga 'git add'
    abbr -a gc 'git commit'
    abbr -a gp 'git push'
    abbr -a gl 'git pull'
    abbr -a gs 'git status'
    abbr -a gd 'git diff'
    abbr -a gco 'git checkout'
    abbr -a gb 'git branch'
    abbr -a glo 'git log --oneline'

    # Tools
    abbr -a ls 'eza --icons --git --group-directories-first'
    abbr -a ll 'eza --icons --git --group-directories-first -l'
    abbr -a la 'eza --icons --git --group-directories-first -la'
    abbr -a tree 'eza --icons --git --tree'
    abbr -a pip 'pip --require-virtualenv'
    abbr -a uvx 'uvx'

    # Utilities
    abbr -a md 'mkdir -p'
    abbr -a cat bat
    abbr -a df 'df -h'
    abbr -a du 'du -h'
    abbr -a find fd
    abbr -a lg lazygit
end

