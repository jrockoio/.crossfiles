# Cross-platform configuration

Shared tools and settings for the work Mac and personal Linux laptop. Only
configuration wanted on both machines belongs here. Personal applications,
Linux desktop settings, extra sources/backends, and private update scripts
belong in a separate private dotfiles repository.

GNU Stow links shared application settings into `$HOME`. Mise manages CLI
versions; zgenom manages interactive Zsh plugins. Desktop applications such as
Alacritty and Ghostty remain installed separately with platform-appropriate
packages. Existing installations are not uninstalled by this repository.

## Set up a machine

Prerequisites: Git, Python 3, GNU Stow, and Zsh. Install these with your normal
OS package manager (APT on Pop!_OS, Homebrew on macOS).

Clone this repository to `~/.crossfiles`, then run:

```sh
~/.crossfiles/install
```

The installer downloads mise v2026.10.10 if mise is absent and verifies its
GitHub asset SHA-256 digest. It clones zgenom at the revision recorded in
`bootstrap/setup.py` if zgenom is absent; existing installations are preserved.
It previews Stow operations, links an explicit package list, installs locked
CLI versions, and appends shared shell hooks only when absent. Conflicting
existing files are left for you to resolve. No system packages are changed.

You can select only some Stow packages:

```sh
~/.crossfiles/install crossbin tmux zsh mise
```

Open a new terminal afterwards. Keep the `.cross.zshrc` source line after
machine-specific PATH setup (including Homebrew). The shared hook
activates mise and initializes plugins. NVM loads lazily on the first `node`,
`npm`, `npx`, or `nvm` call; do not also source `nvm.sh` in the machine entry
point. Set `NVM_DIR` before the shared hook if needed. `.cross.zprofile` only
adds shared paths.
Do not source secrets or machine-specific desktop configuration from this repo.

Linux x86_64 and Apple Silicon macOS have complete locked binary coverage.
Most tools also have Intel macOS lock entries, but tmux-fingers 2.7.1 has no
Intel macOS release binary. It needs a separate installation arrangement there.
Do not expect the full installer to succeed on Intel macOS.
macOS binaries are resolved in the lockfile but have not been executed on Linux.

## Mise ownership and updates

`mise/.config/mise/config.toml` declares the portable shared tools: bat, fd,
fzf, tmux-fingers, lf, Go, just, Neovim, richgo, ripgrep, Starship, and tmux.
Neovim uses an official release binary through the aqua backend.
`mise.lock` records release URLs and checksums for the supported platforms.
Mise's installations and cache stay outside this repository.

Stow links individual mise files with `--no-folding`; `~/.config/mise` stays
a real directory. The installer also unfolds an older whole-directory link.
A personal machine can add files from its private dotfiles repository:

```text
~/.config/mise/
  config.toml          -> crossfiles shared configuration
  mise.lock            -> crossfiles shared lockfile
  config.local.toml    -> optional private dotfiles configuration
  mise.local.lock      -> optional private dotfiles lockfile
```

Mise loads the local file automatically. It can add tools, tasks, and backend
aliases or override shared choices; project configs still take precedence.
The work laptop needs only the shared files. Each config's tools use its own
lockfile, keeping personal tools and source URLs out of the shared lockfile.
Avoid personal `conf.d/*.toml` fragments: they share the public `mise.lock`.
Do not set `MISE_GLOBAL_CONFIG_FILE`, which disables this layered loading.

New tools added with `mise use --global` normally go into the shared config.
For a personal addition, explicitly select the private file instead:

```sh
mise use --path ~/.config/mise/config.local.toml TOOL@VERSION
```

Review shared updates with:

```sh
mise outdated --global
mise upgrade --global --bump --dry-run
mise upgrade --global --bump --no-prune
mise lock --global --platform linux-x64,macos-arm64,macos-x64
```

These global commands also see any private overlay. On personal machines use
the private repository's updater for tools that require source builds, and
review each repository's diff separately. For shared lock generation without
personal overrides, use a shared-only machine or an isolated `MISE_CONFIG_DIR`
containing just the shared config and lockfile.

Test before committing updated configs and lockfiles. On another machine,
pull the repository and run `mise install --locked` from your home directory.
Source-build overrides may have additional prerequisites documented privately.
Mise itself is updated separately; update the bootstrap version when adopting
a new baseline. Shared and private config links can coexist without loading
the private repository on the work laptop.

Bat, fd, just, Starship, Go, and richgo were migrated at their existing versions.
Their previous Cargo, Go-bin, and `/usr/local/go` installations remain available
as fallbacks. Mise selects the Go toolchain; `GOPATH` remains `~/go`, and the
interactive `go` alias runs richgo, which invokes the selected Go binary.
The `cat`, `go`, and `vim` aliases are initialized after mise activation.

The initial tmux pin is 3.7c, the release selected by mise's tmux-builds backend
at setup time. Existing tmux servers keep their original version. The new client
was verified with an existing 3.4 server. No running sessions are stopped.
A separate new server can be started with `tmux -L fresh new-session`; normal
servers use the new executable after their existing sessions naturally finish.

## Zsh plugins

The plugin list is in `zsh/.cross.zshrc`:

- jeffreytse/zsh-vi-mode
- Aloxaf/fzf-tab
- zsh-users/zsh-syntax-highlighting

Zgenom installs them on first interactive startup and caches generated files in
`${XDG_CACHE_HOME:-$HOME/.cache}/crossfiles/zgenom`. Plugins use their upstream
default branches, not the mise lockfile. Updates are explicit:

```zsh
zgenom update
zgenom reset
```

Open a new shell after updating. Changes to `.cross.zshrc` automatically
invalidate the generated plugin cache. The old `~/.zsh-plugins` and old zgenom
cache are retained but no longer loaded by this configuration. Fzf integration
comes from the selected `fzf --zsh`, not the old `~/.fzf.zsh` checkout script.
NVM and pyenv remain available; they have not been migrated to mise.

## Tmux hints

- Ctrl+A, f: label supported patterns; letters copy, Ctrl+letter opens,
  Shift+letter pastes.
- Ctrl+A, u: label URLs; letters open the selected URL.
- Escape: cancel hints.

`crossbin/.config/crossbin/cross-fingers` resolves the globally selected mise
executable. No separate tmux plugin manager or cloned tmux-fingers repository
is needed. The earlier standalone install may remain as an unused fallback.

The lf opener selects `open` on macOS and `xdg-open` on Linux. Its previewer
requires `bat`, installed separately. Other optional shell integrations such as
Starship and zoxide remain conditional on the programs being installed.

## Undo

Restore the earlier config revision and open a new shell to restore shell
behavior. To stop using mise without changing other shared settings, remove its
activation block from `.cross.zshrc`. The original APT, Cargo, Go, fzf-checkout,
and NVM installations were retained. Use `/usr/bin/tmux` explicitly for the APT
client. Reload the desired tmux config without killing the server.
