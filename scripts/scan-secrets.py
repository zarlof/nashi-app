#!/usr/bin/env python3
"""Pinned official gitleaks; redact all findings. No token or external service."""
import hashlib,io,platform,subprocess,tarfile,urllib.request,zipfile
from pathlib import Path
root=Path(__file__).resolve().parents[1]
if platform.system()=='Darwin' and platform.machine()=='arm64':
 name='gitleaks_8.30.1_darwin_arm64.tar.gz';expected='b40ab0ae55c505963e365f271a8d3846efbc170aa17f2607f13df610a9aeb6a5'
elif platform.system()=='Linux' and platform.machine() in ['x86_64','AMD64']:
 name='gitleaks_8.30.1_linux_x64.tar.gz';expected='551f6fc83ea457d62a0d98237cbad105af8d557003051f41f3e7ca7b3f2470eb'
elif platform.system()=='Windows' and platform.machine() in ['x86_64','AMD64']:
 name='gitleaks_8.30.1_windows_x64.zip';expected='d29144deff3a68aa93ced33dddf84b7fdc26070add4aa0f4513094c8332afc4e'
else:raise SystemExit('Use gitleaks 8.30.1 from its official release for this architecture')
url='https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/'+name
with urllib.request.urlopen(url,timeout=90) as r:data=r.read()
assert hashlib.sha256(data).hexdigest()==expected,'Scanner checksum mismatch'
work=root/'build/security';work.mkdir(parents=True,exist_ok=True)
executable=work/('gitleaks.exe' if platform.system()=='Windows' else 'gitleaks')
if name.endswith('.zip'):
 with zipfile.ZipFile(io.BytesIO(data)) as archive:executable.write_bytes(archive.read('gitleaks.exe'))
else:
 with tarfile.open(fileobj=io.BytesIO(data),mode='r:gz') as t:executable.write_bytes(t.extractfile('gitleaks').read())
executable.chmod(0o755)
subprocess.run([str(executable),'git','--redact=100','--no-banner','--log-opts=--all',str(root)],check=True)
