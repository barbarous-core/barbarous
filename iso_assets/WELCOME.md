# 🛸 Welcome to Barbarous

You have successfully booted into the **Barbarous Live Environment**. This is a high-performance, container-native distribution built on the bedrock of **Fedora CoreOS**.

## 🛠 Minimal & Powerful
This environment is minimal by design. It uses a read-only root filesystem with a curated set of modern CLI tools injected for immediate use. 

### Key Characteristics:
- **Immutable Root:** The system core is read-only for stability and security.
- **Fast Path:** Common tools are injected as binaries to avoid slow layering during boot.
- **Zsh Optimized:** Your shell is pre-configured with Starship and Zoxide.

## 📦 System Contents

### Injected Binaries
We provide a suite of high-performance static binaries available immediately.
- **Check list:** Run `barbarous-bins`

### Layered Applications
System-level packages (like `zsh`, `stow`, etc.) are layered via `rpm-ostree`.
- **Check list:** Run `barbarous-apps`

## 🚀 Installation
To install Barbarous to your permanent storage (SSD/HDD/NVMe):

1. **Identify Target:** Use `lsblk` to find your target disk name (e.g., `/dev/nvme0n1`).
2. **Run Installer:**
   ```bash
   sudo barbarous-install
   ```
   *Follow the prompts to finalize the installation.*

---
*Barbarous: The Unbound Core.*

