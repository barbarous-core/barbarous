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

# 3. Apply dotfiles using Stow
if [ -d "./dotfiles" ]; then
    echo "  -> Applying dotfiles via Stow..."
    # We loop through each subfolder in dotfiles/ (e.g. zsh, fastfetch)
    # and link them to the current user's $HOME.
    for pkg in ./dotfiles/*/; do
        pkg_name=$(basename "$pkg")
        echo "     Installing $pkg_name..."
        # Remove default skel files that might block Stow (like .bashrc)
        if [ -f "$HOME/.${pkg_name}rc" ]; then
            rm -f "$HOME/.${pkg_name}rc"
        fi
        stow --restow -d ./dotfiles -t "$HOME" "$pkg_name"
    done

    # Also apply to 'barbarous' user if we are currently root (live env case)
    if [ "$USER" == "root" ] && id "barbarous" &>/dev/null; then
        echo "     Installing to /home/barbarous..."
        for pkg in ./dotfiles/*/; do
            pkg_name=$(basename "$pkg")
            # Remove default skel files that might block Stow (like .bashrc)
            if [ -f "/home/barbarous/.${pkg_name}rc" ]; then
                rm -f "/home/barbarous/.${pkg_name}rc"
            fi
            sudo -u barbarous stow --restow -d ./dotfiles -t /home/barbarous "$pkg_name"
        done
    fi
fi

echo "✅ Setup Complete. Type 'zsh' to reload your shell with the new config!"
