# Tools

## Common (every environment)
- gh (GitHub CLI)
- uv (Python packages and environments)
- mise (runtime version manager, replaces asdf)
- git
- stow
- tree
- less
- fzf
- pigz
- zopfli
- dig (DNS lookup)
- bc
- file
- openssl
- curl

## Mac
Install with Homebrew (`brew install ...`).
- git
- stow
- tree
- less
- fzf
- pigz
- zopfli
- bind (provides `dig`)
- bc
- openssl@3
- gh
- uv
- mise

Notes:
- `file` and `curl` ship with macOS. Skip them unless a newer version is needed.
- `open` is built in on macOS. Do not install `xdg-utils`.

## ChromeOS VM (Debian)
Install with apt (`sudo apt-get install -y ...`).
- git
- stow
- tree
- less
- fzf
- pigz
- zopfli
- dnsutils (provides `dig`)
- bc
- file
- xdg-utils (provides `xdg-open`)
- openssl
- curl
- gh (already installed)
- uv (install script: `curl -LsSf https://astral.sh/uv/install.sh | sh`)
- mise (install script: `curl https://mise.run | sh`)

## Other
Install with your OS package manager, using the names in the Common list.
Package names may differ, for example `bind-utils` on Fedora or `bind` on Arch.
If `uv` or `mise` is not packaged, use the install scripts above.

## Keymap

Source: `.aliases` and `.functions`. Platform column: **all** works everywhere;
**mac** needs macOS; **linux** needs Linux.

### Essentials
Everyday navigation and commands. All platforms.

| Shortcut | Does |
|----------|------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |
| `.....` | `cd ../../../..` |
| `~` | `cd ~` |
| `-` | `cd -` (previous directory) |
| `dl` | `cd ~/Downloads` |
| `dt` | `cd ~/Desktop` |
| `p` | `cd ~/projects` (on this VM, change to `~/Projects`) |
| `g` | `git` |
| `ls` | `ls` with color |
| `l` | `ls -lF` (long, colored) |
| `la` | `ls -lAF` (long, includes hidden) |
| `lsd` | long listing, directories only |
| `grep` / `fgrep` / `egrep` | same command with `--color=auto` |
| `sudo` | lets other aliases be used with `sudo` |
| `mkd <dir>` | create a directory (with parents) and enter it |
| `o [target]` | `open .` with no args, otherwise `open <target>` |
| `open <target>` | open a file or URL (`xdg-open` on Linux) |
| `tre [path]` | `tree` with hidden files, colored, paged |
| `fs [path]` | size of a file or directory |
| `diff a b` | colored word diff via `git diff --no-index` |

### Power
Utilities, platform-specific helpers, and network and archive tools.

| Shortcut | Does | Platform |
|----------|------|----------|
| `week` | current week number (`date +%V`) | all |
| `ips` | list IP addresses | all |
| `targz <path>` | create a `.tar.gz` (uses zopfli, pigz, or gzip) | all |
| `gz <file>` | compare original and gzipped sizes | all |
| `dataurl <file>` | print a base64 data URL for a file | all |
| `digga <domain>` | show DNS records (`dig`) | all |
| `getcertnames <domain>` | list the SSL certificate's CN and SANs | all |
| `server [port]` | Python HTTP server on port 8000 (uses Python 2 `SimpleHTTPServer`; broken on Python 3) | all |
| `phpserver [port]` | PHP dev server (uses `ipconfig`) | mac |
| `localip` | local IP via `ipconfig getifaddr en0` | mac |
| `cdf` | cd to the top Finder window (uses `osascript`) | mac |
| `update` | macOS software update, brew, npm, gem | mac |
| `c` | trim newlines and copy to clipboard (`pbcopy`) | mac |
| `cleanup` | delete `.DS_Store` files recursively | mac |
| `emptytrash` | empty Trash and clear system logs | mac |

Note: `server` and `phpserver` open a browser with `open`, which works on Linux
through `xdg-open` but needs a desktop session.
