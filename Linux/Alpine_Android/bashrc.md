To update the file, remove the old content and use: cd [path to repo]
cat ~/.bashrc >> Linux/Alpine_Android/bashrc.md

run() { 
g++ "$1" -o /tmp/app && /tmp/app
}


py() {
python3 "$1"
}


clone-sd() { if [ -z "$1" ]; then echo "Usage: clone-sd <git-repo-url> [optional-folder-name]"; return 1; fi; local repo="$1"; local dir="${2:-$(basename "$repo" .git)}"; local target_worktree="$(pwd)/$dir"; local target_gitdir="$HOME/.git-repos/$dir.git"; mkdir -p "$HOME/.git-repos" "$target_worktree"; rm -rf "$target_gitdir"; git clone --bare --depth 1 "$repo" "$target_gitdir" || return 1; echo "gitdir: $target_gitdir" > "$target_worktree/.git"; git --git-dir="$target_gitdir" config core.worktree "$target_worktree"; git --git-dir="$target_gitdir" config core.bare false; git --git-dir="$target_gitdir" config core.filemode false; cd "$target_worktree" || return 1; git checkout -f main || git checkout -f master; }
