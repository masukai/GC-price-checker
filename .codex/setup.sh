#!/usr/bin/env bash
set -euo pipefail

# Install only the tools that may be missing from the Codex workspace.
if command -v apt-get >/dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive

  apt_cache_updated=0
  packages=()

  if ! command -v python3 >/dev/null 2>&1; then
    packages+=(python3 python3-pip)
  elif ! python3 -m pip --version >/dev/null 2>&1; then
    packages+=(python3-pip)
  fi

  for pkg in ca-certificates curl gnupg; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
      packages+=("$pkg")
    fi
  done

  if ! command -v lsb_release >/dev/null 2>&1; then
    packages+=(lsb-release)
  fi

  if ((${#packages[@]})); then
    apt-get update
    apt_cache_updated=1
    apt-get install -y --no-install-recommends "${packages[@]}"
  fi

  if ! command -v terraform >/dev/null 2>&1; then
    install -d -m 0755 /etc/apt/keyrings
    if [[ ! -f /etc/apt/keyrings/hashicorp-archive-keyring.gpg ]]; then
      curl -fsSL https://apt.releases.hashicorp.com/gpg \
        | gpg --dearmor -o /etc/apt/keyrings/hashicorp-archive-keyring.gpg
    fi
    echo "deb [signed-by=/etc/apt/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
      | tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
    apt-get update
    apt_cache_updated=1
    apt-get install -y --no-install-recommends terraform
  fi

  if [[ "$apt_cache_updated" == 1 ]]; then
    rm -rf /var/lib/apt/lists/*
  fi
fi

# Install Python dependencies.
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 -m pip install --upgrade pip
python3 -m pip install -r "${PROJECT_ROOT}/requirements.txt"
