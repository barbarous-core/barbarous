# Barbarous Core: Binary Issues & Missing Tools

This document tracks all tools from `Barbarous_Core_CLI.md` that either had
download/extraction problems during the `download_static_bins.sh` run, or
cannot be provided as standalone static binaries at all.

---

## 1. Tools with Download/Extraction Problems (Fixed)

These tools had wrong URLs or archive structure mismatches in the initial script.
They are now successfully downloaded — this section documents what the bugs were
so future maintainers don't repeat the same mistakes.

| Tool | GitHub | Issue | Fix Applied |
|------|--------|-------|-------------|
| **superfile** | https://github.com/yorukot/superfile | Asset filename includes the version tag: `superfile-linux-v1.5.0-amd64.tar.gz` (not `superfile-linux-amd64.tar.gz`). Also, the binary inside the archive is named **`spf`**, not `superfile`. | Use `superfile-linux-${V}-amd64.tar.gz` and extract pattern `*/spf`. Saved as `spf`. |
| **btop** | https://github.com/aristocratos/btop | Archive format is **bzip2 `.tbz`** (not gzip `.tar.gz`). Our generic extractor uses `tar xzf` (gzip) which failed with "not a bzip2 file". The binary is at `./btop/bin/btop` inside the archive. | Use `tar xjf` for bzip2, extract `*/bin/btop`. |
| **bluetui** | https://github.com/pythops/bluetui | The release page lists `bluetui-x86_64-unknown-linux-gnu.tar.gz` in the HTML but **that file does not exist** on the CDN (returns 9 bytes / HTTP redirect). The actual asset is a **direct static musl binary**: `bluetui-x86_64-linux-musl`. | Download direct binary URL, no extraction needed. |
| **asciinema** | https://github.com/asciinema/asciinema | No `.tar.gz` release archive for Linux x86_64. Ships as a **direct static musl binary**: `asciinema-x86_64-unknown-linux-musl`. | Download direct binary URL, no extraction needed. |
| **navi** | https://github.com/denisidoro/navi | Asset filename includes the version prefix: `navi-v2.24.0-x86_64-unknown-linux-musl.tar.gz`. The generic pattern `x86_64-unknown-linux-musl.tar.gz` matched nothing (GitHub API returned empty string). | Use `navi-${V}-x86_64-unknown-linux-musl.tar.gz` explicitly. |
| **atuin** | https://github.com/atuinsh/atuin | The release page has both `atuin-x86_64-*` and `atuin-server-x86_64-*`. The generic pattern `x86_64-unknown-linux-gnu.tar.gz` matched the **server** variant first. | Changed pattern to `atuin-x86_64-unknown-linux-gnu.tar.gz` (prefix match). |
| **bottom** (`btm`) | https://github.com/ClementTsang/bottom | Binary inside the archive is named `btm` (the project's short name), not `bottom`. Wildcard `*/btm` was initially written as `*/btm ` (trailing space), causing "not found in archive". | Trim whitespace from pattern; extract `btm` at root level of archive. |
| **axel** | https://github.com/axel-download-accelerator/axel | No prebuilt Linux x86\_64 binary in GitHub Releases. The release page only has source tarballs. Our hardcoded URL `axel-2.17.14-linux-x86_64.tar.gz` returned a 404 (9 bytes). | **Skipped** — must be installed via `rpm-ostree` (see Section 2). |

---

## 2. Tools Without Static Binaries (Must Be Layered via rpm-ostree)

These tools **cannot** be injected as standalone static binaries because they
depend on shared system libraries (`ncurses`, `alsa`, `libcaca`) or language
runtimes (Python, Ruby) that must be present in the OS.

**Proposed fix:** Add these to the CoreOS `rpm-ostree` overlay or a Butane
`systemd` first-boot unit that runs `rpm-ostree install`.

### 2a. Ncurses / Display Dependent

| Tool | GitHub | Why it can't be static |
|------|--------|------------------------|
| **sl** | https://github.com/mtoyoda/sl | Dynamically linked against `libncurses`. No release binaries — source only. |
| **cmatrix** | https://github.com/abishekvashok/cmatrix | Requires `libncurses`. No static release binaries. |
| **figlet** | https://github.com/cmatsuoka/figlet | Requires `libncurses`. No prebuilt releases on GitHub. |
| **toilet** | https://github.com/cacalabs/toilet | Requires `libncurses` and `libcaca`. No prebuilt releases. |
| **cbonsai** | https://gitlab.com/jallbrit/cbonsai | Requires `libncurses`. No prebuilt binaries — compile from source only. |

### 2b. Audio Dependent

| Tool | GitHub | Why it can't be static |
|------|--------|------------------------|
| **cava** | https://github.com/nicowillis/cava | Requires `libasound` (ALSA), `libpulse`, and `libncurses`. Inherently dynamic. |

### 2c. libcaca Dependent

| Tool | GitHub | Why it can't be static |
|------|--------|------------------------|
| **cacafire** | https://github.com/cacalabs/libcaca | Part of `libcaca` (`caca-utils`). Requires `libcaca.so` at runtime. No static build. |

### 2d. Python / Ruby Runtime Required

| Tool | GitHub | Why it can't be static |
|------|--------|------------------------|
| **lolcat** | https://github.com/busyloop/lolcat | Ruby gem — requires a Ruby interpreter. No compiled binary exists. |
| **jrnl** | https://github.com/jrnl-org/jrnl | Python package (`pip install jrnl`). No compiled static binary. |
| **smassh** | https://github.com/kraanzu/smassh | Python + Textual TUI. Requires Python 3.10+. No compiled binary. |

### 2e. Unknown / No Public Releases

These tools are referenced in `Barbarous_Core_CLI.md` but appear to have **no
public GitHub releases** or are placeholder names. Investigation required
before deciding on an integration path.

| Tool | GitHub | Status |
|------|--------|--------|
| **wiremix** | *(unknown — no repo URL in doc)* | Could not find a "wiremix" CLI tool with Linux x86_64 releases. May be a PipeWire audio mixer TUI. |
| **branchlet** | *(unknown — no repo URL in doc)* | No public GitHub releases found. May be a private/internal tool. |
| **taproom** | *(unknown — no repo URL in doc)* | No public GitHub releases found. |
| **hygg** | *(unknown — no repo URL in doc)* | No public GitHub releases found. |
| **stormy** | https://github.com/v-zhb/stormy | Repository exists but has **no GitHub Releases** — only source code. Must be compiled from source. |

---

## 3. Summary

| Category | Count | Tools |
|----------|-------|-------|
| ✅ Successfully downloaded | 34 | `asciinema`, `atuin`, `bat`, `bluetui`, `broot`, `btm`, `btop`, `chezmoi`, `croc`, `dust`, `eza`, `fastfetch`, `fd`, `fzf`, `gh`, `grex`, `lazygit`, `lsd`, `navi`, `neofetch`, `nvim`, `pastel`, `pipes.sh`, `rg`, `sd`, `spf`, `starship`, `tealdeer`, `ttyd`, `tv`, `yazi`, `yq`, `zellij`, `zoxide` |
| ⚠️ Needs rpm-ostree layering | 10 | `sl`, `cmatrix`, `figlet`, `toilet`, `cbonsai`, `cava`, `cacafire`, `lolcat`, `jrnl`, `smassh` |
| ❓ Unknown / investigate | 5 | `wiremix`, `branchlet`, `taproom`, `hygg`, `stormy` |
| 🔧 Fixed download bugs | 8 | `superfile`, `btop`, `bluetui`, `asciinema`, `navi`, `atuin`, `bottom`, `axel` |

---

*Last updated: 2026-04-09 — generated during `download_static_bins.sh` run.*
