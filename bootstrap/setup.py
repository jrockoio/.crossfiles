#!/usr/bin/env python3
"""Install the pinned bootstrap tools without root or shell-script downloads."""
import hashlib
import io
import json
import os
from pathlib import Path
import platform
import shutil
import subprocess
import tarfile
import urllib.request

MISE_VERSION = 'v2026.10.10'
ZGENOM_COMMIT = 'd99d5dc4b27695612de2b7054bb583dd19a7235d'
home = Path.home()

def run(*args):
    subprocess.run(args, check=True)

for cmd in ('git', 'stow', 'zsh'):
    if not shutil.which(cmd):
        raise SystemExit(f'Install {cmd} with your OS package manager first.')

mise = home / '.local/bin/mise'
if not mise.exists() and not shutil.which('mise'):
    system = {'Linux': 'linux', 'Darwin': 'macos'}.get(platform.system())
    arch = {'x86_64': 'x64', 'arm64': 'arm64', 'aarch64': 'arm64'}.get(platform.machine())
    if not system or not arch:
        raise SystemExit('Unsupported bootstrap platform; install mise manually.')
    url = f'https://api.github.com/repos/jdx/mise/releases/tags/{MISE_VERSION}'
    with urllib.request.urlopen(url, timeout=60) as response:
        release = json.load(response)
    name = f'mise-{MISE_VERSION}-{system}-{arch}.tar.gz'
    asset = next(a for a in release['assets'] if a['name'] == name)
    with urllib.request.urlopen(asset['browser_download_url'], timeout=120) as response:
        data = response.read()
    digest = 'sha256:' + hashlib.sha256(data).hexdigest()
    if asset.get('digest') != digest:
        raise SystemExit('Mise release checksum missing or mismatched.')
    with tarfile.open(fileobj=io.BytesIO(data)) as archive:
        member = next(m for m in archive if m.name.endswith('/bin/mise') and m.isfile())
        mise.parent.mkdir(parents=True, exist_ok=True)
        mise.write_bytes(archive.extractfile(member).read())
    mise.chmod(0o755)
    print(f'Installed mise {MISE_VERSION}')

zgenom = home / '.zgenom'
if not zgenom.exists():
    run('git', 'clone', 'https://github.com/jandamm/zgenom.git', str(zgenom))
    run('git', '-C', str(zgenom), 'checkout', '--detach', ZGENOM_COMMIT)
elif not (zgenom / 'zgenom.zsh').is_file():
    raise SystemExit(f'{zgenom} exists but is not a zgenom installation; left untouched.')
