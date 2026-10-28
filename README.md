# Cross-platform configuration

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
Other tools also have Intel macOS lock entries, but tmux-fingers 2.7.1 has no
Intel macOS release binary: the full install needs a separate source-build
arrangement there. Do not expect the full installer to succeed on Intel macOS.
macOS binaries are resolved in the lockfile but have not been executed on Linux.

## Tools and updates

`mise/.config/mise/config.toml` declares exact versions of tmux, Codex CLI,
ripgrep, fzf, lf, and tmux-fingers. Codex CLI is enabled only on Linux; mise
skips its installation and activation on macOS via its
[`os` filter](https://mise.jdx.dev/dev-tools/#os-specific-tools).
`mise.lock` records per-platform release URLs
and checksums. Stow links the entire config directory, including the lockfile.
The binary/cache directories are not committed.

```sh
mise outdated
mise upgrade --global --bump --dry-run
mise upgrade --global --bump --no-prune
mise lock --global --platform linux-x64,macos-arm64,macos-x64
```

Test before committing the updated config and lockfile. On another machine,
pull the repository and run `mise install --locked` from your home directory.
Retained old versions can be selected again with `mise use --global --pin
TOOL@VERSION`; regenerate the lockfile after changing a pin. Mise itself is
updated separately; update the bootstrap version when adopting a new baseline.

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

## Neovim

The Neovim configuration requires Neovim 0.12 or later and uses the
`main` branch of nvim-treesitter. Mise provides the Tree-sitter CLI needed to
build parsers; a C compiler must also be available (Xcode Command Line Tools
on macOS, or `build-essential` on Ubuntu/Pop!_OS).

After pulling this migration, run `mise install --locked tree-sitter`, then
`:Lazy restore` and `:TSUpdate` in Neovim. Missing parsers install
asynchronously, and highlighting attaches when the buffer's parser is ready.
Restart Neovim after the initial installation so newly installed languages
are also discovered inside existing Markdown code blocks.

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
