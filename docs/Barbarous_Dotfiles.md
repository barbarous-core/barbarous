# Barbarous Core: Dotfiles & Configuration

This document outlines the standard dotfile structure and configuration philosophy for **Barbarous Core**. Our goal is to provide a "batteries-included" but modular experience that respects the immutable nature of Fedora CoreOS while offering a premium, high-productivity terminal environment.

## 1. Configuration Philosophy

*   **Portability**: Configs should be modular and easy to sync via Git.
*   **Performance**: Minimize shell startup time (target < 100ms).
*   **Aesthetics**: Consistent color schemes (primarily Catppuccin or Gruvbox Material) across all TUI tools.
*   **Immutability**: User configs reside in `/var/home/$USER/`, while system defaults are staged in `/usr/etc/` or injected during the provisioning phase.

## 2. Core Shell & Environment

| Component | Tool | Description | Config Location |
| :--- | :--- | :--- | :--- |
| **Shell** | `zsh` | Primary interactive shell with advanced completion. | `.zshrc` |
| **Framework** | `oh-my-zsh` | Plugin and theme management framework. | `.oh-my-zsh/` |
| **Prompt** | `starship` | Cross-shell customizable prompt. | `.config/starship.toml` |
| **History** | `atuin` | SQLite-backed searchable shell history. | `.config/atuin/config.toml` |
| **Multiplexer** | `zellij` | Modern terminal workspace with layout support. | `.config/zellij/config.kdl` |

## 3. Terminal Utilities

| Tool | Config Path | Key Features Configured |
| :--- | :--- | :--- |
| **Neovim** | `.config/nvim/` | LSP, Treesitter, and Barbarous custom keybindings. |
| **Tmux** | `.tmux.conf` | Vi-mode, mouse support, and status line styling. |
| **Bat** | `.config/bat/` | Custom syntax highlighting themes. |
| **LSD / Eza** | `.config/lsd/` | Icon mapping and color aliases. |
| **Zoxide** | *(N/A)* | Interactive `cd` integration in shell init. |

## 4. Management & Deployment

To manage these dotfiles on a Barbarous system, we recommend one of the following approaches integrated into our `barbarous-install-tui`:

### A. GNU Stow (Symlink Farm)
Standard Unix approach. Configs are kept in a `~/dotfiles` directory and symlinked to `$HOME`.
*   **Pros**: Simple, no binary dependencies, easy to revert.
*   **Usage**: `stow zsh nvim tmux`

### B. Chezmoi (Secure & Template-based)
Advanced manager that supports templates and password manager integration (e.g., `pass`).
*   **Pros**: Handles machine-specific differences, encrypted secrets.
*   **Usage**: `chezmoi apply`

## 5. Deployment Workflow

1.  **Initial Provisioning**: During installation, the `barbarous-install-tui` prompts for a dotfile repository URL.
2.  **Asset Injection**: The installer clones the repo into `/var/home/$USER/.dotfiles`.
3.  **Bootstrap**: A `setup.sh` or `chezmoi` script is triggered on the first boot to apply configurations.
## 6. Curated Inbox Repositories

For inspiration or as a base for your own configuration, we maintain a list of high-quality "inbox" repositories from the community. These can be used as references for specific tool configurations.

| User | Link | Managed Apps |
| :--- | :--- | :--- |
| **Aetf** | [GitHub](https://github.com/Aetf/dotfiles.git) | aconfmgr, autostart, git, gmailctl, hg, htop, iterm2, mise |
| **Aloxaf** | [GitHub](https://github.com/Aloxaf/dotfiles.git) | alacritty, bat, cargo, ccache, conky, emacs, fcitx |
| **bashbunni** | [GitHub](https://github.com/bashbunni/dotfiles.git) | doom, fish, gitconfig, i3, nix, nvim, polybar |
| **BreadOnPenguins** | [GitHub](https://github.com/BreadOnPenguins/dots.git) | dunst, GIMP, picom, qutebrowser, rmpc, shell, wal, zsh |
| **BrodieRobertson** | [GitHub](https://github.com/BrodieRobertson/dotfiles.git) | alacritty, awesome, bashrc, bashtop, blender, bspwm, btop |
| **ChristianLempa** | [GitHub](https://github.com/ChristianLempa/dotfiles.git) | ghostty, helix, iterm2, misc, neofetch, yadm, zshrc |
| **CodeOpsHQ** | [GitHub](https://github.com/CodeOpsHQ/dotfiles.git) | alias, backgrounds, ghostty, kitty, lazygit, nvim, rofi, sway |
| **dispatch-yt** | [GitHub](https://github.com/dispatch-yt/dot-files.git) | tmux, zshrc |
| **linkarzu** | [GitHub](https://github.com/linkarzu/dotfiles-latest.git) | aerospace, alacritty, bashrc, brew, btop, colorscheme |
| **dreamsofautonomy**| [GitHub](https://github.com/dreamsofautonomy/dotfiles.git) | alacritty, zshrc |
| **eieioxyz** | [GitHub](https://github.com/eieioxyz/dotfiles_macos.git) | bat, dotbot, iterm2 |
| **elijahmanor** | [GitHub](https://github.com/elijahmanor/dotfiles.git) | alacritty, bat, btop, dooit, gh, hammerspoon, hushlogin |
| **ericmurphyxyz** | [GitHub](https://github.com/ericmurphyxyz/dotfiles.git) | dunst, foot, hypr, imv, kitty, lf, mpv, newsboat |
| **jpmcb** | [GitHub](https://github.com/jpmcb/dotfiles.git) | ghostty, git-template, nvim, tmux, zsh |
| **omerxx** | [GitHub](https://github.com/omerxx/dotfiles.git) | aerospace, atuin, gh-dash, ghostty, hammerspoon, karabiner, nix |
| **ryanoasis** | [GitHub](https://github.com/ryanoasis/dotfiles.git) | bashrc, gitconfig, tmux, vimrc, zshrc |

---
*Last Updated: 2026-04-27*
