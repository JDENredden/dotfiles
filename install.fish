#!/usr/bin/env fish
# Dotfiles installer — creates symlinks from repo into expected locations.
# Run with: fish install.fish
# Safe to re-run; existing symlinks are skipped.

set DOTFILES (realpath (dirname (status filename)))

# Ensure Homebrew is on PATH for this session — needed on a fresh machine
# where brew is installed but shellenv hasn't been added to config yet
if test -x /opt/homebrew/bin/brew && not type -q brew
    echo "=== homebrew ==="
    eval (/opt/homebrew/bin/brew shellenv)
    echo "  brew shellenv loaded"
    echo ""
end

function link
    set src $argv[1]
    set dst $argv[2]
    set dir (dirname $dst)

    # Create parent directory if needed
    if not test -d $dir
        mkdir -p $dir
        echo "  created $dir"
    end

    if test -L $dst
        echo "  skip (already linked): $dst"
    else if test -e $dst
        echo "  skip (file exists, not a symlink): $dst"
        echo "    → back it up manually if you want to replace it"
    else
        ln -s $src $dst
        echo "  linked: $dst -> $src"
    end
end

echo "=== fish ==="
link $DOTFILES/fish/config.fish ~/.config/fish/config.fish
link $DOTFILES/fish/fish_plugins ~/.config/fish/fish_plugins

echo ""
echo "=== claude ==="
link $DOTFILES/claude/settings.json ~/.claude/settings.json
link $DOTFILES/claude/CLAUDE.md ~/CLAUDE.md  # global Claude instructions live in home dir
link $DOTFILES/claude/hooks/claude-island-state.py ~/.claude/hooks/claude-island-state.py

# statusline-command.sh is optional — only link if it exists in the repo
if test -f $DOTFILES/claude/statusline-command.sh
    link $DOTFILES/claude/statusline-command.sh ~/.claude/statusline-command.sh
end

echo ""
echo "=== ghostty ==="
link $DOTFILES/ghostty/config ~/.config/ghostty/config

echo ""
echo "=== tide ==="
# tide config is stored as universal variables — source the script to apply them
source $DOTFILES/fish/tide.fish
echo "  tide variables set"

echo ""
echo "=== fisher ==="
if type -q fisher
    echo "  fisher already installed, running update..."
    fisher update
else
    echo "  installing fisher..."
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    echo "  installing plugins from fish_plugins..."
    fisher update
end

echo ""
echo "Done. Restart fish or run 'source ~/.config/fish/config.fish' to apply."
