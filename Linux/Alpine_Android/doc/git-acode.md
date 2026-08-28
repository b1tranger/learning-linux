
Acode APK (F-Droid): [https://github.com/Acode-Foundation/Acode/releases/tag/v1.13.1](https://www.google.com/search?q=https://github.com/Acode-Foundation/Acode/releases/tag/v1.13.1)

# Complete Guide: Setting Up Git & GitHub in Acode Mobile (Android)

This guide covers setting up Git inside Acode using its integrated Alpine Linux environment and the Git SCM UI plugin, working around Android filesystem limitations, and configuring GitHub authentication.

---

### Prerequisites & Core Architecture

Acode operates using a native Alpine Linux proot environment.

* **Native CLI Git:** Installed via Alpine's package manager (`apk`).
* **Git SCM Plugin:** Provides a VS Code–style visual interface (source control panel, diff viewer, commit/push buttons) connected to the CLI via Acode's Executor API.
* **Android Storage Limitation:** Android’s public shared storage (`/sdcard/`) uses an emulated FAT32/FUSE filesystem that restricts POSIX file locks, indexing, and packfile renaming. To prevent Git fatal errors (`unable to write .pack file`), Git’s metadata (`.git`) must live in internal Linux container storage, linked to working files on the SD card via a `.git` pointer file.

---

### Step 1: Install Git and Nano in the Terminal

1. Open Acode and open the integrated **Terminal** panel.
2. Install the necessary packages:

```sh
apk update
apk add git nano

```

3. Verify the installation:

```sh
git --version

```

---

### Step 2: Configure Global Git Identity

Set your author name and email so commits are attributed properly:

```sh
git config --global user.name "Your GitHub Username"
git config --global user.email "your-email@example.com"

```

---

### Step 3: Configure `~/.bashrc` for Android Storage Compatibility

To automate cloning repositories directly to custom paths on `/sdcard/` without encountering filesystem write/rename errors:

1. Open your bash configuration file:

```sh
nano ~/.bashrc

```

2. Paste the `clone-sd` helper function at the bottom:

```sh
clone-sd() { if [ -z "$1" ]; then echo "Usage: clone-sd <git-repo-url> [optional-folder-name]"; return 1; fi; local repo="$1"; local dir="${2:-$(basename "$repo" .git)}"; local target_worktree="$(pwd)/$dir"; local target_gitdir="$HOME/.git-repos/$dir.git"; mkdir -p "$HOME/.git-repos" "$target_worktree"; rm -rf "$target_gitdir"; git clone --bare --depth 1 "$repo" "$target_gitdir" || return 1; echo "gitdir: $target_gitdir" > "$target_worktree/.git"; git --git-dir="$target_gitdir" config core.worktree "$target_worktree"; git --git-dir="$target_gitdir" config core.bare false; git --git-dir="$target_gitdir" config core.filemode false; cd "$target_worktree" || return 1; git checkout -f main || git checkout -f master; }

```

3. Save and exit Nano:

* Press **`Ctrl + O`**, then **`Enter`** to save.
* Press **`Ctrl + X`** to exit.

4. Reload the configuration:

```sh
source ~/.bashrc

```

---

### Step 4: Clone a Repository to Shared Storage

1. Navigate to your desired custom storage directory:

```sh
cd /sdcard/AppDataCustom/ACODE/GitHub

```

2. Run the helper function:

```sh
clone-sd https://github.com/<username>/<repo-name>.git

```

---

### Step 5: Install & Connect the Git SCM Plugin

1. Tap the **Menu icon** (top-left) > **Settings** > **Plugins**.
2. Switch to the **Explore** tab, search for `Git SCM`, and tap **Install**.
3. Restart the Acode app.
4. Open the left drawer, tap **Open Folder**, and select the cloned directory (e.g., `Internal Storage > AppDataCustom > ACODE > GitHub > <repo-name>`).
5. Open the **Source Control (branch/fork icon)** in the left sidebar. The plugin will automatically detect the repository via the `.git` pointer.

---

### Opening the Command Palette & Git SCM Reference

**How to Open the Command Palette:**

* **Using Physical/Virtual Keyboard:** Press `Ctrl + Shift + P` or `F1`.
* **Using Acode's Quick-Access Menu:** Tap the **three-dot overflow menu (`⋮`)** in the top-right header and tap **Commands** (or **Command Palette**).
* **Adding a Visible Toolbar Shortcut / Key Binding:**
1. Go to **Settings** > **Keyboard Shortcuts** (or **Key Bindings**).
2. Search for `Command Palette` or `Show Commands`.
3. Map it to an easily reachable key sequence, or enable the on-screen **Extra Keys / Virtual Keyboard Row** in Acode's editor settings (which provides persistent touch buttons for `Ctrl`, `Shift`, and `P`).



**Git SCM UI & Palette Command Reference:**

* **`Git: Initialize Repository`** — Initializes the currently active folder into a Git repository.
* **`Git: Clone`** — Clones a remote repository by pasting its URL directly into the input prompt.
* **`Git: Add Remote`** — Prompts for the remote name (e.g., `origin`) and repository target URL.
* **`Git: Set User Config`** — Opens GUI prompts to set `user.name` and `user.email`.
* **`Git: Stage All Changes`** / **`Git: Unstage All`** — Stages or unstages modified files across the workspace.
* **`Git: Commit`** — Prompts for a commit message and commits staged changes.
* **`Git: Push`** / **`Git: Pull`** — Pushes local commits to GitHub or fetches and merges incoming remote changes.

---

### Step 6: Configure Global GitHub Authentication (Personal Access Token)

GitHub requires token-based authentication rather than account passwords over HTTPS. Instead of manually embedding tokens into individual repository URLs, configure Git's credential store globally inside the Linux environment:

1. **Generate a Token on GitHub:**
* Go to **Settings** > **Developer Settings** > **Personal access tokens** > **Tokens (classic)**.
* Tap **Generate new token (classic)**, check the **`repo`** scope (Full control of private repositories), and copy the generated token string (`ghp_...`).


2. **Enable Global Credential Storage in Terminal:**
```sh
git config --global credential.helper store

```


3. **Save Your Credentials File:**
```sh
echo "https://<YOUR_USERNAME>:<YOUR_TOKEN>@github.com" >> ~/.git-credentials

```


*(Replace `<YOUR_USERNAME>` and `<YOUR_TOKEN>` with your GitHub username and the copied PAT).*

All push, pull, and clone operations across all repositories will now authenticate automatically without prompting.

---

### Step 7: Daily Git Operations

**Via Visual UI (Git SCM Plugin):**

* **Diffs:** Tap modified files in the sidebar to open side-by-side or inline diffs.
* **Stage:** Tap the **`+`** icon next to individual files or on the **Changes** header to stage all.
* **Commit:** Enter a message in the input box and tap the **Checkmark** button.
* **Sync / Push:** Tap the three-dot menu in the Git panel and select **Push** or **Pull**.

**Via Terminal (Native CLI):**

```sh
git status
git add .
git commit -m "your commit message"
git push origin main
git pull origin main

```

---

### Common Issues & Solutions Reference

* **Error: `unable to write file ... .pack: No such file or directory` / `fetch-pack: invalid index-pack output**`
* *Cause:* Android FAT32/FUSE storage blocks low-level packfile index manipulation.
* *Fix:* Use the `clone-sd` function to isolate the `.git` directory inside container storage (`~/.git-repos/`) while pointing the working tree to `/sdcard/`.


* **Error: `Failed to authenticate to git remote` / `publish branch` failure**
* *Cause:* HTTPS authentication without a Personal Access Token or credential helper.
* *Fix:* Ensure the credential helper is enabled and credentials are correctly written to `~/.git-credentials`.


* **Cloned repository does not show in Acode UI:**
* *Fix:* Use Acode's **Open Folder** menu to manually open the directory from device storage; then tap the refresh icon in the Source Control panel.



---

## Alternative Storage Setups & Workflow Tips

This section covers secondary storage strategies and internal container setups for different development workflows.

---

### Alternative Storage: Solution 1 (Fast Clone to Internal POSIX Storage)

If you do not require your project files to be visible in external Android file managers, cloning directly into the internal Linux container filesystem avoids all FUSE/SD-card permission and packfile errors without requiring separate `.git` directory configurations:

1. Add the helper function to `~/.bashrc`:

```sh
clone-local() { local repo="$1"; local dir="${2:-$(basename "$repo" .git)}"; mkdir -p ~/projects && cd ~/projects; git clone --depth 1 "$repo" "$dir" && cd "$dir"; }

```

2. Reload shell configuration:

```sh
source ~/.bashrc

```

3. Clone directly into native Linux storage:

```sh
clone-local https://github.com/<username>/<repo-name>.git

```

4. Open the project folder in Acode using the internal container path (`~/projects/<repo-name>`).