# Antigravity & GitHub Desktop Setup Guide (Kali Linux / VMware)

This guide documents the proven, step-by-step procedures for installing and updating **Antigravity IDE** and **GitHub Desktop (by shiftkey)** in a Kali Linux VMware environment. It includes successful setup methods, alternative approaches, troubleshooting steps, and key learnings from common errors.

---

## 1. Antigravity Setup & Update Guide

### System Overview
- **Binary Path:** `/usr/bin/antigravity` (`/usr/share/antigravity/bin/antigravity`)
- **APT Package Name:** `antigravity`
- **APT Repository URL:** `https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev`
- **Distribution Release Label:** `antigravity-debian`

### Successful Update Method

To update Antigravity to the latest available package version via `apt`:

```bash
sudo apt-get update
sudo apt-get --only-upgrade install antigravity
```

### In-App & Extension Updates

1. **GUI Update:** Open Antigravity -> `Help` -> `Check for Updates...` -> `Restart to Update`.
2. **Extensions Update:** Run `antigravity --update-extensions` in the terminal or use the Extensions view inside the editor.

---

## 2. GitHub Desktop Installation Guide

Because GitHub does not publish an official Linux desktop client, the community-maintained fork by `shiftkey` ([shiftkey/desktop](https://github.com/shiftkey/desktop)) is used.

### Successful Method: Direct `.deb` Release Package

This is the most reliable method for Kali Linux, bypassing third-party mirror downtime.

1. **Download the latest `.deb` release package:**
   ```bash
   wget https://github.com/shiftkey/desktop/releases/download/release-3.4.12-linux1/GitHubDesktop-linux-amd64-3.4.12-linux1.deb
   ```

2. **Install using `apt`:**
   ```bash
   sudo apt install ./GitHubDesktop-linux-amd64-3.4.12-linux1.deb
   ```

3. **Launch GitHub Desktop:**
   - From Application Menu: Search for **GitHub Desktop**
   - From Terminal: `github-desktop`

4. **Optional Cleanup:**
   ```bash
   rm ~/GitHubDesktop-linux-amd64-3.4.12-linux1.deb
   ```

---

## 3. Alternative Installation Approaches

### Approach A: Official PackageCloud APT Repository
If you prefer automatic updates via `apt update`, use the official PackageCloud repository feed:

```bash
# Add PackageCloud GPG Key
wget -qO - https://packagecloud.io/shiftkey/desktop/gpgkey | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/shiftkey-desktop.gpg

# Add APT source list entry
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/shiftkey-desktop.gpg] https://packagecloud.io/shiftkey/desktop/any/ any main" > /etc/apt/sources.list.d/packagecloud-shiftkey-desktop.list'

# Update and install
sudo apt update
sudo apt install github-desktop
```

### Approach B: Flatpak / AppImage
- **Flatpak:** Available via `flatpak install flathub io.github.shiftey.Desktop` (requires Flatpak framework).
- **AppImage:** Download standalone `.AppImage` from [GitHub Releases](https://github.com/shiftkey/desktop/releases) and make executable (`chmod +x`).

---

## 4. Bug Fixes & Troubleshooting Learnings

### Bug 1: `E: Unable to locate package antigravity-debian`
- **Symptom:** Running `sudo apt-get --only-upgrade install antigravity-debian` fails with `Unable to locate package`.
- **Root Cause:** `antigravity-debian` is the repository distribution label (`dists/antigravity-debian`), whereas the actual APT package name is `antigravity`.
- **Fix:** Target `antigravity` as the package name:
  ```bash
  sudo apt-get --only-upgrade install antigravity
  ```

### Bug 2: `Err:1 https://mirror.mwt.me/ghd/deb any InRelease 410 Gone`
- **Symptom:** Running `sudo apt update` fails with `410 Gone` and `The repository is not signed`.
- **Root Cause:** The legacy community mirror (`mirror.mwt.me`) was decommissioned and returned HTTP 410.
- **Fix:** Remove the obsolete repository file and switch to direct `.deb` installation or official PackageCloud repository:
  ```bash
  sudo rm -f /etc/apt/sources.list.d/packagecloud-shiftkey-desktop.list
  ```

### Bug 3: `Notice: Download is performed unsandboxed as root as file '/home/kali/...' couldn't be accessed by user '_apt'`
- **Symptom:** `apt` displays an unsandboxed warning during local `.deb` installation.
- **Root Cause:** APT drops root privileges to the unprivileged `_apt` user during package fetches. Since `/home/kali` has restricted permissions, `_apt` cannot read the local file directly, so APT falls back to root execution.
- **Fix / Insight:** This notice is expected and safe when running `sudo apt install ./file.deb`. The installation completes successfully.

---
*Created on: 2026-08-25 | Environment: Kali Linux (VMware)*
