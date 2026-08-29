#!/usr/bin/env bash
# release.sh — rebuild the DMT Council CLI sdist from dmt-ai-services main and
# republish the Homebrew tap (dist/ + formula sha256). Run from anywhere.
set -euo pipefail
AI="${DMT_AI_SERVICES:-$HOME/Code/evoost/DMT/dmt-repos/dmt-ai-services}"
TAP="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$AI" && git checkout main -q && git pull -q
DIST="$(mktemp -d)"
uv build --sdist --out-dir "$DIST" >/dev/null
SDIST="$DIST/dmt_ai_services-0.5.0.tar.gz"
SHA="$(python3 -c "import hashlib;print(hashlib.sha256(open('$SDIST','rb').read()).hexdigest())")"

cd "$TAP" && git pull -q
cp "$SDIST" dist/
python3 - "$SHA" << 'PY'
import re, sys
f = "Formula/dmt.rb"
s = open(f).read()
s = re.sub(r'sha256 "[0-9a-f]{64}"', f'sha256 "{sys.argv[1]}"', s, count=1)
open(f, "w").write(s)
PY
git add dist/ Formula/dmt.rb
git commit -q -m "dist: rebuild from dmt-ai-services main ($(cd "$AI" && git rev-parse --short HEAD))" || echo "nothing to commit"
git push -q
echo "Tap updated to $SHA — reinstall: brew reinstall dmt"
