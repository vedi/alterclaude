# alterclaude

Switch Claude Desktop accounts on macOS and Linux.

Swaps only the identity files (cookies, oauth cache, Chromium storage).
MCP config, VM bundles, caches, and `~/.claude/projects` stay shared.

```
code       this repo
command    alterclaude
data       ~/.claude-profiles   (tokens — never commit, never copy)
Desktop    macOS: ~/Library/Application Support/Claude
           Linux: ~/.config/Claude
```

## Install

```bash
git clone https://github.com/vedi/alterclaude.git
cd alterclaude
./install.sh
```

`~/.local/bin` must be on `PATH`. Dev checkout: `./install.sh --dev`.

## New machine

1. Install the script. Do **not** copy `~/.claude-profiles`.
2. Sign in to account A in Claude Desktop.
3. `alterclaude doctor`
4. `alterclaude init A`
5. `alterclaude B` — sign in as B.
6. `alterclaude A` — A returns without another login.

## Commands

```
alterclaude list
alterclaude doctor
alterclaude init <name>
alterclaude <name>
alterclaude <name> --dry-run
alterclaude <name> --no-share-code
```

Run from a normal terminal, not from the Desktop Code tab.

## Environment

| | |
|---|---|
| `CLAUDE_DIR` | Desktop data directory |
| `CLAUDE_BIN` | Linux binary if not `claude-desktop` |
| `CLAUDE_PROFILES_DIR` | profile store, default `~/.claude-profiles` |
| `CLAUDE_SWAP_SHARE_CODE` | `0` to keep Code-tab session lists separate |

## What is shipped

Shipped: `alterclaude`, `install.sh`, README, Makefile, LICENSE.

Not shipped and must not travel between machines: `work/`, `personal/`,
`.active`, `backups/`, `code-sessions-canonical`, Cookies, `config.json`.

## Code-tab sessions

The Code tab lists `claude-code-sessions/<account-uuid>/`.
By default alterclaude symlinks those UUIDs onto one store.
Regular Claude chats stay server-side and per-account.
