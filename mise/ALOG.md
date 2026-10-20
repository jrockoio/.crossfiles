# alog

`conf.d/alog.toml` declares the Linux-only `github:jrockoio/alog` tool.
The installed commands are `al` and `alog`; Python 3.10+ must be available
at `/usr/bin/python3`. The global lockfile records the release artifact
and SHA-256 checksum for Linux x64.

Source, release workflow, usage, and security documentation:
<https://github.com/jrockoio/alog>.

After restoring this Stow package on Linux:

```sh
mise install github:jrockoio/alog
mise exec -- al --version
```

The release is pinned. To review and update it explicitly:

```sh
mise outdated --global --bump github:jrockoio/alog
mise upgrade --global --bump github:jrockoio/alog
```

Commit the changed fragment and relevant lock entry after testing the new
release. This utility does not update itself or collect keyboard input.
Logs remain outside source control under the user's state directory.
