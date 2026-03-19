#!/bin/bash

# Script to install git hooks
ROOT_DIR=$(git rev-parse --show-toplevel)
HOOKS_DIR="$ROOT_DIR/scripts/git-hooks"
GIT_HOOKS_DIR="$ROOT_DIR/.git/hooks"

echo "🔧 Instalando git hooks..."

# Ensure the git hooks directory exists
mkdir -p "$GIT_HOOKS_DIR"

# Link hooks from scripts/git-hooks to .git/hooks
for hook in "$HOOKS_DIR"/*; do
  hook_name=$(basename "$hook")
  echo "🔗 Vinculando $hook_name..."
  cp "$hook" "$GIT_HOOKS_DIR/$hook_name"
  chmod +x "$GIT_HOOKS_DIR/$hook_name"
done

echo "✅ Git hooks instalados com sucesso!"
