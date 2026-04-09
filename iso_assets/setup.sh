#!/usr/bin/env bash
# Barbarous Live Setup Script
# This script applies the injected assets to the running Live environment.

echo "==> Applying Barbarous Live Assets..."

# 1. Install binaries
if [ -d "./bin" ]; then
    echo "  -> Injecting binaries to /usr/local/bin..."
    sudo cp ./bin/* /usr/local/bin/
    sudo chmod +x /usr/local/bin/*
fi

# 2. Install RPMs and dependencies
if [ -d "./rpms" ]; then
    echo "  -> Installing real RPM packages (this may take a minute)..."
    # We use --apply-live to make them available immediately in RAM
    sudo rpm-ostree install --apply-live ./rpms/*.rpm
fi

# 3. Apply dotfiles to the current user
echo "  -> Applying dotfiles..."
cp ./dotfiles/.zshrc ~/

# 3. Create 'barbarous' user if missing (for Live testing)
if ! id "barbarous" &>/dev/null; then
    echo "  -> Creating 'barbarous' user..."
    sudo useradd -m -G wheel barbarous
    sudo cp ./dotfiles/.zshrc /home/barbarous/
fi

echo "✅ Setup Complete. Type 'zsh' to reload your shell with the new config!"
