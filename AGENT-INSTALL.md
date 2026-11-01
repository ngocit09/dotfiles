# Agent install guide: set up this machine from these dotfiles

You are setting up a shell environment on the current machine using this repo.
Read this whole file before changing anything. Ask the user before any step
marked **ASK**.

## 0. Target environment (verify first)

Run these checks and confirm the result matches. If it does not match, stop and ask.

```bash
cat /etc/os-release | head -2      # expected: Debian GNU/Linux 13 (trixie) or another Debian/Ubuntu
uname -s                           # expected: Linux (macOS steps below are skipped)
echo $HOME                         # expected: /home/ngochoang
command -v apt-get sudo git        # expected: all present
sudo -n true && echo SUDO_OK       # expected: SUDO_OK (passwordless sudo)
```

Known local facts:

- `~/Downloads` is a symlink to `/mnt/shared/MyFiles/Downloads`.
- `~/Projects` is a real directory (the user's projects folder). It is **not** `~/projects`.
- `~/Project` is a symlink to `/mnt/shared/MyFiles/Project`.
- `~/MyDrive` is a symlink to the Google Drive mount.
- `gh` is installed and logged in as `ngocit09` over SSH.
- Git global identity is `Hoang Canh Ngoc <ngocit09@gmail.com>`. Do not change it.
- `~/dotfiles` is a clone of `git@github.com:ngocit09/dotfiles.git`.

## 1. Back up existing shell files (required before linking)

Home already has `.bashrc`, `.profile`, and `.bash_profile`. Do not overwrite them without a backup.

```bash
BK=~/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)
mkdir -p "$BK"
for f in .bashrc .bash_profile .profile .aliases .functions .zshrc; do
  [ -e ~/$f ] && cp -a ~/$f "$BK/"
done
ls -la "$BK"
```

Show the user the diff between `~/.bashrc` and `~/dotfiles/.bashrc`. **ASK** before
replacing it, since the user may have local changes that should be kept.

## 2. Install packages (Debian/Ubuntu)

These are the commands and utilities the dotfiles reference. Install them with apt.

```bash
sudo apt-get update
sudo apt-get install -y \
  git stow tree less fzf pigz zopfli dnsutils bc file xdg-utils openssl curl
```

- `zopfli` and `pigz` are used by `targz()` in `.functions`.
- `dnsutils` provides `dig`, used by `digga()`.
- `xdg-utils` provides `xdg-open`, which `open` and `o` use on Linux.
- `stow` is optional. Section 3 links files directly and does not need it.

`gh` is already installed. Do not reinstall it.

## 3. Link the dotfiles into $HOME

Link only the files the shell needs. Do **not** link these:

| File | Reason to skip |
|------|----------------|
| `.extra` | Sets git identity to `Ngoc Hoang` / `ngoc.hoang`, which overrides the global config. Create a local `~/.extra` instead if the user wants machine-specific settings. |
| `.gitmodules` | Git metadata, not a shell file. |
| `.stow-local-ignore`, `install/` | Setup metadata. `install/` contains macOS-only scripts. |

```bash
cd ~/dotfiles
for f in .aliases .functions .bashrc .bash_profile .profile .zshrc; do
  ln -sfn "$HOME/dotfiles/$f" "$HOME/$f"
done
ls -la ~ | grep -E '\.(aliases|functions|bashrc|bash_profile|profile|zshrc) '
```

Then create `~/.extra` **only if the user asks**, and keep it out of git (it is
not in the repo, so it stays local).

## 4. Language and tool managers: uv and mise (replaces asdf)

asdf is no longer used. The tracked `.bashrc` and `.bash_profile` still source
`~/.asdf/asdf.sh` and `~/.asdf/completions/asdf.bash`; those lines must be
replaced, not left in place.

Install both with their official installers. Both put binaries in `~/.local/bin`.

```bash
# uv: Python packages and project environments
curl -LsSf https://astral.sh/uv/install.sh | sh

# mise: runtime version manager (Node, Python, Go, etc.), replaces asdf
curl https://mise.run | sh

export PATH="$HOME/.local/bin:$PATH"
uv --version
mise --version
```

Shell setup. These lines go into the tracked `.bashrc` and `.bash_profile` in
place of the asdf lines. **ASK** before editing those files.

```bash
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash)"
eval "$(uv generate-shell-completion bash)"
```

Do not install `asdf` tool versions or copy `.tool-versions` files. If the user
has a `.tool-versions` file, convert it to `mise.toml` with `mise use` in that project.

## 5. Adapt aliases and functions for Linux

These are Linux-specific edits to `~/dotfiles/.aliases`. **ASK** before editing the
tracked files, and do not commit unless the user asks.

- **Set `colorflag` on Linux** so `ls` and `grep` colors work. Add
  `colorflag="--color=auto"` for GNU ls. The current file leaves `colorflag` empty.
- **Fix `p`:** change `alias p="cd ~/projects"` to `alias p="cd ~/Projects"`.
- **Skip macOS-only aliases on Linux:** `update` (uses `softwareupdate` and `brew`),
  `localip` (`ipconfig`), `c` (`pbcopy`), `cleanup` (`.DS_Store` only), and
  `emptytrash` (`/Volumes`, `com.apple.LaunchServices`). Keep them inside a
  `if [ "$(uname -s)" = Darwin ]; then ... fi` block, or remove them on Linux.
- **Skip macOS-only functions:** `cdf` (uses `osascript`) and `phpserver` (`ipconfig`).
  `server()` uses Python 2's `SimpleHTTPServer`, which doesn't exist on Debian; flag it to the user.
- `open` is already handled for Linux in `.functions` (`xdg-open`). No change needed.

## 6. Verify

Run each check and report the result. Do not claim success unless the output confirms it.

```bash
# syntax
for f in ~/dotfiles/.aliases ~/dotfiles/.functions ~/dotfiles/.bashrc ~/dotfiles/.bash_profile ~/dotfiles/.profile; do
  bash -n "$f" && echo "OK $f" || echo "FAIL $f"
done

# new login shell loads cleanly (no errors on stderr)
bash -lic 'echo SHELL_OK' 2>&1 | tail -5

# aliases and functions are defined
bash -ic 'alias dl p g l la; type mkd targz diff o >/dev/null && echo FUNCS_OK' 2>&1

# tools referenced by the dotfiles
for t in git gh stow fzf pigz zopfli dig bc file xdg-open tree less; do
  command -v "$t" >/dev/null && echo "have $t" || echo "MISSING $t"
done

# GitHub SSH still works
ssh -T git@github.com 2>&1 | head -1
gh auth status 2>&1 | head -2
```

Expected: no syntax errors, `SHELL_OK`, `FUNCS_OK`, all tools present, and
`Hi ngocit09!` from SSH.

If `bash -lic` shows errors about asdf, the `~/.asdf` lines in `.bashrc` or
`.bash_profile` were not replaced. Go back to step 4.

```bash
command -v uv mise && mise --version && uv --version
```

## 7. Report to the user

Summarize, in this order:

1. Which files were backed up, and where.
2. Which symlinks were created.
3. Which packages were installed.
4. Which steps were skipped (`.extra`, macOS-only items, uv/mise if not installed).
5. Each verification result, as shown by its output.
6. Open questions: the `.extra` identity conflict, the `server()` Python 2 issue,
   and whether the tracked-file edits from step 5 should be committed.

Do not commit or push to `~/dotfiles` unless the user asks.
