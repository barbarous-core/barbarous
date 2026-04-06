# Barbarous Core: CLI Toolkit

This document catalogs the essential CLI tools selected for **Barbarous Core** (the minimal edition). The tools are categorized, and their planned installation method on our immutable Fedora CoreOS-based distribution is specified (e.g., whether they should be natively layered via `rpm-ostree`, provided as statically injected binaries in `rootfs/usr/local/bin`, or containerized).

## 1. File Management & Navigation

| Application | Description | Integration Method | Fedora (dnf) | Debian (apt) | Arch (pacman) | Repository |
|-------------|-------------|-------------------|--------------|--------------|---------------|------------|
| **eza** | A modern, feature-rich replacement for `ls` written in Rust. | Bin Injected | `dnf install eza` | `apt install eza` | `pacman -S eza` | [eza](https://github.com/eza-community/eza) |
| **lsd** | The next gen `ls` command with lots of colors and icons. | Bin Injected | `dnf install lsd` | `apt install lsd` | `pacman -S lsd` | [lsd](https://github.com/lsd-rs/lsd) |
| **yazi** | Blazing fast terminal file manager based on async I/O. | Bin Injected | *Copr / Bin* | *Bin* | `pacman -S yazi` | [yazi](https://github.com/sxyazi/yazi) |
| **superfile** | A very fancy and modern terminal file manager. | Bin Injected | *Bin* | *Bin* | *Bin* | [superfile](https://github.com/yorukot/superfile) |
| **zoxide** | A smarter `cd` command that tracks your most used directories. | Bin Injected | `dnf install zoxide` | `apt install zoxide` | `pacman -S zoxide` | [zoxide](https://github.com/ajeetdsouza/zoxide) |
| **fd** | A simple, fast and user-friendly alternative to `find`. | Bin Injected | `dnf install fd-find` | `apt install fd-find` | `pacman -S fd` | [fd](https://github.com/sharkdp/fd) |
| **fzf** | A general-purpose command-line fuzzy finder. | Bin Injected | `dnf install fzf` | `apt install fzf` | `pacman -S fzf` | [fzf](https://github.com/junegunn/fzf) |
| **ncdu** | Disk usage analyzer with an ncurses interface. | Layered | `dnf install ncdu` | `apt install ncdu` | `pacman -S ncdu` | [ncdu](https://dev.yorhel.nl/ncdu) |
| **dust** | A more intuitive version of `du`, written in Rust. | Bin Injected | `dnf install dust` | *Bin* | `pacman -S dust` | [dust](https://github.com/bootandy/dust) |
| **broot** *(added)* | A new way to see and navigate directory trees. | Bin Injected | `dnf install broot` | *Bin* | `pacman -S broot` | [broot](https://github.com/Canop/broot) |

## 2. Text & Search Tools

| Application | Description | Integration Method | Fedora (dnf) | Debian (apt) | Arch (pacman) | Repository |
|-------------|-------------|-------------------|--------------|--------------|---------------|------------|
| **bat** | A `cat` clone with syntax highlighting and Git integration. | Bin Injected | `dnf install bat` | `apt install bat` | `pacman -S bat` | [bat](https://github.com/sharkdp/bat) |
| **ripgrep (rg)** | Line-oriented search tool that recursively searches directories. | Bin Injected | `dnf install ripgrep` | `apt install ripgrep`| `pacman -S ripgrep` | [ripgrep](https://github.com/BurntSushi/ripgrep) |
| **jq** | A lightweight and flexible command-line JSON processor. | Layered | `dnf install jq` | `apt install jq` | `pacman -S jq` | [jq](https://github.com/jqlang/jq) |
| **yq** *(added)* | Portable command-line YAML, JSON, and XML processor. | Bin Injected | *Copr / Bin* | *Bin* | `pacman -S yq` | [yq](https://github.com/mikefarah/yq) |
| **grex** | Generates regular expressions from user-provided test cases. | Bin Injected | `dnf install grex` | *Bin* | `pacman -S grex` | [grex](https://github.com/pemistahl/grex) |
| **sd** *(added)* | Intuitive find & replace CLI (a modern replacement for `sed`).| Bin Injected | `dnf install sd` | *Bin* | `pacman -S sd` | [sd](https://github.com/chmln/sd) |

## 3. System Management & Monitoring

| Application | Description | Integration Method | Fedora (dnf) | Debian (apt) | Arch (pacman) | Repository |
|-------------|-------------|-------------------|--------------|--------------|---------------|------------|
| **btop** | Visually appealing and feature-rich system resource monitor. | Bin Injected | `dnf install btop` | `apt install btop` | `pacman -S btop` | [btop](https://github.com/aristocratos/btop) |
| **htop** | Interactive process viewer and system monitor. | Layered | `dnf install htop` | `apt install htop` | `pacman -S htop` | [htop](https://github.com/htop-dev/htop) |
| **powertop** | Tool to find out what programs are using your laptop's power. | Layered | `dnf install powertop`| `apt install powertop`| `pacman -S powertop` | [powertop](https://github.com/fenrus75/powertop) |
| **bottom** *(added)*| Yet another cross-platform graphical process monitor. | Bin Injected | `dnf install bottom` | *Bin* | `pacman -S bottom` | [bottom](https://github.com/ClementTsang/bottom) |
| **pass** | The standard Unix password manager. | Layered | `dnf install pass` | `apt install pass` | `pacman -S pass` | [pass](https://www.passwordstore.org/) |
| **stow** | Symlink farm manager, commonly used for dotfile management. | Layered | `dnf install stow` | `apt install stow` | `pacman -S stow` | [stow](https://www.gnu.org/software/stow/) |
| **chezmoi** | Manage your dotfiles securely across multiple machines. | Bin Injected | `dnf install chezmoi` | *Bin* | `pacman -S chezmoi` | [chezmoi](https://github.com/twpayne/chezmoi) |
| **grub-reboot** | Sets the default boot entry for the next boot only. | Layered | *(part of grub2)* | *(part of grub)* | *(part of grub)* | *(built-in)* |

## 4. Shell, Terminal & Environment

| Application | Description | Integration Method | Fedora (dnf) | Debian (apt) | Arch (pacman) | Repository |
|-------------|-------------|-------------------|--------------|--------------|---------------|------------|
| **zsh** | A powerful, interactive shell with scripting features. | Layered | `dnf install zsh` | `apt install zsh` | `pacman -S zsh` | [zsh](https://zsh.sourceforge.io/) |
| **ohmyzsh** | A delightful community-driven framework for managing zsh config.| Home Dir Setup | *Curl Script* | *Curl Script* | *Curl Script* | [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) |
| **tmux** | Terminal multiplexer to run multiple terminals in one screen. | Layered | `dnf install tmux` | `apt install tmux` | `pacman -S tmux` | [tmux](https://github.com/tmux/tmux) |
| **Zellij** | A modern, highly customizable terminal workspace multiplexer. | Bin Injected | `dnf install zellij` | *Bin* | `pacman -S zellij` | [zellij](https://github.com/zellij-org/zellij) |
| **starship** | The minimal, blazing-fast prompt for any shell. | Bin Injected | `dnf install starship`| *Bin* | `pacman -S starship` | [starship](https://github.com/starship/starship) |
| **atuin** | Replaces your shell history with an encrypted SQLite database. | Bin Injected | `dnf install atuin` | *Bin* | `pacman -S atuin` | [atuin](https://github.com/atuinsh/atuin) |
| **navi** | An interactive cheatsheet tool for the command-line. | Bin Injected | *Bin* | *Bin* | `pacman -S navi` | [navi](https://github.com/denisidoro/navi) |
| **tealdeer** | A very fast implementation of `tldr` in Rust. | Bin Injected | `dnf install tealdeer`| *Bin* | `pacman -S tealdeer` | [tealdeer](https://github.com/tealdeer-rs/tealdeer) |
| **brew** | Homebrew / linuxbrew package manager. | Home Dir Setup | *Curl Script* | *Curl Script* | *Curl Script* | [brew](https://brew.sh/) |
| **ttyd** | Share your terminal over the web. | Bin Injected | `dnf install ttyd` | `apt install ttyd` | `pacman -S ttyd` | [ttyd](https://github.com/tsl0922/ttyd) |

## 5. Networking & Internet

| Application | Description | Integration Method | Fedora (dnf) | Debian (apt) | Arch (pacman) | Repository |
|-------------|-------------|-------------------|--------------|--------------|---------------|------------|
| **bluetui** | A TUI wrapper for `bluetoothctl` managing Bluetooth devices. | Bin Injected | *Bin* | *Bin* | `pacman -S bluetui` | [bluetui](https://github.com/pythops/bluetui) |
| **impala** | TUI for iwd (iNet Wireless Daemon) for Wi-Fi management. | Container | *Bin* | *Bin* | `pacman -S impala` | [impala](https://github.com/pythops/impala) |
| **croc** | Securely and easily send files from one computer to another. | Bin Injected | `dnf install croc` | *Bin* | `pacman -S croc` | [croc](https://github.com/schollz/croc) |
| **speedtest-cli** | Command line interface for testing internet bandwidth. | Container | `dnf install speedtest-cli`| `apt install speedtest-cli`| `pacman -S speedtest-cli`| [speedtest-cli](https://github.com/sivel/speedtest-cli) |
| **axel** | Light command line download accelerator via multiple connections.| Bin Injected | `dnf install axel` | `apt install axel` | `pacman -S axel` | [axel](https://github.com/axel-download-accelerator/axel) |
| **wiremix** | Experimental/Specialized networking tool. | Bin Injected | *N/A* | *N/A* | *N/A* | [wiremix]() |
| **newsboat** | An RSS/Atom feed reader for the text console. | Container | `dnf install newsboat`| `apt install newsboat`| `pacman -S newsboat` | [newsboat](https://github.com/newsboat/newsboat) |
| **lynx** | Classic text-based web browser. | Container | `dnf install lynx` | `apt install lynx` | `pacman -S lynx` | [lynx](https://lynx.browser.org/) |
| **wttr.in** | The right way to check the weather (via `curl wttr.in`). | Built-in | *N/A* | *N/A* | *N/A* | [wttr.in](https://github.com/chubin/wttr.in) |

## 6. Development, Git & Containers

| Application | Description | Integration Method | Fedora (dnf) | Debian (apt) | Arch (pacman) | Repository |
|-------------|-------------|-------------------|--------------|--------------|---------------|------------|
| **neovim** | Highly extensible Vim-based text editor. | Bin Injected | `dnf install neovim` | `apt install neovim` | `pacman -S neovim` | [neovim](https://github.com/neovim/neovim) |
| **gh** | GitHub's official command-line tool. | Bin Injected | `dnf install gh` | `apt install gh` | `pacman -S github-cli` | [gh](https://github.com/cli/cli) |
| **lazygit** | A simple terminal UI for Git. | Bin Injected | `dnf install lazygit` | *Bin* | `pacman -S lazygit` | [lazygit](https://github.com/jesseduffield/lazygit) |
| **branchlet** | Tool to navigate and manage Git branches from the terminal. | Bin Injected | *Bin* | *Bin* | *N/A* | [branchlet](#) |
| **podman** | Daemonless container engine for OCI containers. | Layered  | `dnf install podman` | `apt install podman` | `pacman -S podman` | [podman](https://podman.io/) |
| **flatpak** | Linux application sandboxing and distribution framework. | Layered | `dnf install flatpak` | `apt install flatpak` | `pacman -S flatpak` | [flatpak](https://flatpak.org/) |
| **distrobox** | Use any Linux distribution inside your terminal using containers.| Layered | `dnf install distrobox`| `apt install distrobox`| `pacman -S distrobox` | [distrobox](https://github.com/89luca89/distrobox) |
| **cargo** | The Rust package manager. | Container | `dnf install cargo` | `apt install cargo` | `pacman -S rust` | [cargo](https://github.com/rust-lang/cargo) |
| **cargo-seek** | Specialized tool for the Rust ecosystem. | Container | *cargo install* | *cargo install* | *cargo install* | [cargo-seek](#) |

## 7. Media, Extras & Fun

| Application | Description | Integration Method | Fedora (dnf) | Debian (apt) | Arch (pacman) | Repository |
|-------------|-------------|-------------------|--------------|--------------|---------------|------------|
| **ffmpeg** | A complete, cross-platform solution to record/convert media. | Layered | `dnf install ffmpeg` | `apt install ffmpeg` | `pacman -S ffmpeg` | [ffmpeg](https://ffmpeg.org/) |
| **asciinema** | Record and share terminal sessions easily. | Bin Injected | `dnf install asciinema`| `apt install asciinema`| `pacman -S asciinema` | [asciinema](https://github.com/asciinema/asciinema) |
| **pastel** | Command-line tool to generate, analyze, and convert colors. | Bin Injected | `dnf install pastel` | *Bin* | `pacman -S pastel` | [pastel](https://github.com/sharkdp/pastel) |
| **faker** | Library to generate fake data. | Container/Pip | *pip install faker* | *pip install faker* | *pip install faker* | [faker](https://github.com/joke2k/faker) |
| **cbonsai** | Grow terminal bonsai trees. | Bin Injected | *Bin* | *Bin* | `pacman -S cbonsai` | [cbonsai](https://github.com/pwaller/cbonsai) |
| **lolcat** | Rainbows and unicorns for terminal output! | Bin Injected | `dnf install rubygem-lolcat`| `apt install lolcat` | `pacman -S lolcat` | [lolcat](https://github.com/busyloop/lolcat) |
| **hollywood** | Fills your console with Hollywood melodrama technobabble. | Container | `dnf install hollywood`| `apt install hollywood`| `pacman -S hollywood` | [hollywood](https://github.com/dustinkirkland/hollywood) |
| **discordo** | A lightweight, secure Discord terminal client. | Container | *Bin* | *Bin* | `pacman -S discordo-git`| [discordo](https://github.com/ayn2op/discordo) |
| **jrnl** | A simple CLI journal application. | Bin Injected | `dnf install jrnl` | *pip* | `pacman -S jrnl` | [jrnl](https://github.com/jrnl-org/jrnl) |
| **smassh** | A CLI typing test tool in Python. | Bin Injected | *pip* | *pip* | *AUR* | [smassh](https://github.com/robert-oleynik/smassh) |
| **stormy** | A beautiful TUI weather application. | Bin Injected | *Bin* | *Bin* | *AUR* | [stormy](https://github.com/v-zhb/stormy) |
| **taproom** | Used for environment / tapping workflows. | Bin Injected | *Bin* | *Bin* | *AUR* | [taproom](#) |
| **hygg** | Specialized utility. | Bin Injected | *Bin* | *Bin* | *AUR* | [hygg](#) |
| **fastfetch** *(added)* | Like neofetch, but much faster because written in C. | Bin Injected | `dnf install fastfetch`| *Bin* | `pacman -S fastfetch` | [fastfetch](https://github.com/fastfetch-cli/fastfetch) |
