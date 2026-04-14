#!/bin/bash
# Barbarous Core: add ISO binaries to PATH + alias fastfetch (live boot)
BARBAROUS_ASSETS=""
for dir in /run/media/iso/barbarous-assets /run/media/*/barbarous-assets; do
    if [ -d "$dir/bin" ] 2>/dev/null; then
        export PATH="$dir/bin:${PATH:-}"
        BARBAROUS_ASSETS="$dir"
        break
    fi
done


# Alias fastfetch to always use the Barbareus logo and config
if [ -n "$BARBAROUS_ASSETS" ]; then
    export BARBAROUS_ASSETS
    export FF_CONFIG="$BARBAROUS_ASSETS/dotfiles/fastfetch/.config/fastfetch/config.jsonc"
    export FF_LOGO="$BARBAROUS_ASSETS/barbarous_logo.txt"
    
    # Use a function instead of an alias so it works instantly inside this script
    fastfetch() {
        command fastfetch --config "$FF_CONFIG" --logo "$FF_LOGO" --logo-type file-raw --logo-color-1 white --logo-color-2 "#dc7338" "$@"
    }
    export -f fastfetch

fi

# Only source bicon ONE TIME. Sourcing a script with 'exec' will destroy the shell,
# so if the new shell sources it again without this check, it creates an infinite loop!
if command -v bicon &>/dev/null && [ -z "$BICON_DATA_DIR" ] && [[ "$(tty)" =~ ^/dev/tty[0-9]+$ ]]; then
    #sleep 5
    source "$BARBAROUS_ASSETS/bin/bicon"
fi


# Show system info on login
command -v fastfetch &>/dev/null && [ -n "$BARBAROUS_ASSETS" ] && fastfetch

