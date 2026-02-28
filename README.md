# dotfiles

Fish shell + Claude Code config.

## Setup on a new machine

```fish
git clone <your-repo-url> ~/dotfiles
fish ~/dotfiles/install.fish
```

Then reinstall fish plugins:

```fish
fisher update
```

## What's included

### fish/
| File | Purpose |
|------|---------|
| `config.fish` | PATH, env vars, abbreviations |
| `fish_plugins` | Fisher plugin list |

### claude/
| File | Purpose |
|------|---------|
| `settings.json` | Permissions, hooks, status line config |
| `CLAUDE.md` | Global instructions for Claude |
| `hooks/claude-island-state.py` | Notification/status hook script |
| `statusline-command.sh` | Status line display script |

## What's NOT included

- `fish_variables` — machine-specific universal variables (set manually)
- `~/.ssh/` — keys and sensitive config
- `~/.claude/projects/` — local session memory
- `~/.claude/plugins/cache/` — downloaded plugin data
