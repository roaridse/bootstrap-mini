#!/usr/bin/env bash
set -e

# Ensure curl + git
sudo apt update -y
sudo apt install -y git curl

# Install GitHub CLI if missing
if ! command -v gh >/dev/null 2>&1; then
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg |
    sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
https://cli.github.com/packages stable main" |
    sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt update -y
  sudo apt install -y gh
fi

echo "🔐 Logger inn i GitHub (nettleser åpnes)"
gh auth login --web --scopes "repo"

echo "⬇️ Henter bootstrap.sh fra privat repo..."
gh api \
  repos/roaridse/dotfiles/contents/bootstrap.sh \
  --jq '.content' | base64 -d > /tmp/bootstrap.sh

chmod +x /tmp/bootstrap.sh

echo "🚀 Kjører bootstrap.sh"
bash /tmp/bootstrap.sh

