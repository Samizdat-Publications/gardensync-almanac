#!/usr/bin/env bash
# A Quiet Almanac - stage a clean copy of the site and publish it to Cloudflare Pages.
#
# The repo carries things the site does not need: the dev proxy, the docs
# landing page, screenshots. This assembles only what the app itself needs,
# then deploys it.
#
#   ./deploy.sh          # stage into dist/ and deploy
#   ./deploy.sh --stage  # stage only, don't deploy
set -euo pipefail

cd "$(dirname "$0")"
PROJECT="gardensync-almanac"
OUT="dist"

rm -rf "$OUT"
mkdir -p "$OUT"

# The app is four files and nothing else.
cp index.html style.css app.js plants.js "$OUT"/

# The og:image for link previews. It lives in docs/ so the app folder stays
# free of a 780KB screenshot; it is copied in here because the meta tag
# points at an absolute production URL.
cp docs/screenshots/almanac-hero.png "$OUT"/preview.png

cat > "$OUT"/_headers <<'HEADERS'
/*
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  X-Frame-Options: SAMEORIGIN
  Permissions-Policy: geolocation=(), microphone=(), camera=()
HEADERS

echo "Staged $(find "$OUT" -type f | wc -l) files into $OUT/ ($(du -sh "$OUT" | cut -f1))"

if [ "${1:-}" = "--stage" ]; then
  exit 0
fi

npx wrangler pages deploy "$OUT" --project-name="$PROJECT" --branch=main --commit-dirty=true
