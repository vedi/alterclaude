#!/usr/bin/env bash
# Install alterclaude onto PATH. Profile data stays in ~/.claude-profiles.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PREFIX="${PREFIX:-$HOME/.local}"
DEV=0

usage() {
  cat <<'USAGE'
install.sh — put alterclaude on $PREFIX/bin (default ~/.local/bin)

  ./install.sh
  ./install.sh --dev              symlink to this checkout
  PREFIX=/usr/local ./install.sh
  ./install.sh --prefix=/usr/local

Profile data is not copied.
On a new machine: alterclaude init <name>
USAGE
}

for a in "$@"; do
  case "$a" in
    --dev) DEV=1 ;;
    --prefix=*) PREFIX="${a#--prefix=}" ;;
    -h|--help) usage; exit 0 ;;
    *) echo "неизвестный флаг: $a" >&2; usage; exit 1 ;;
  esac
done

BIN="$PREFIX/bin"
DATA="${CLAUDE_PROFILES_DIR:-$HOME/.claude-profiles}"
SRC="$ROOT/alterclaude"
DEST="$BIN/alterclaude"

[ -f "$SRC" ] || { echo "missing $SRC" >&2; exit 1; }

mkdir -p "$BIN" "$DATA"

if [ "$DEV" = 1 ]; then
  ln -sfn "$SRC" "$DEST"
  echo "dev symlink $DEST -> $SRC"
else
  install -m 755 "$SRC" "$DEST"
  echo "installed $DEST"
fi
rm -f "$BIN/claude-swap" "$DATA/claude-swap"

if ! command -v alterclaude >/dev/null 2>&1; then
  echo
  echo "alterclaude is not on PATH. Add to your shell:"
  echo "  export PATH=\"$BIN:\$PATH\""
fi

echo
echo "next: alterclaude doctor"
echo "new machine: alterclaude init <current-account-name>"
