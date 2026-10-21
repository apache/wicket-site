#!/bin/bash
# Builds every design listed in _previews/designs.txt and publishes them side by
# side on the gh-pages branch of the dashorst fork, under one chooser page:
#
#   https://dashorst.github.io/wicket-site/          the chooser
#   https://dashorst.github.io/wicket-site/<slug>/   each design
#
# Runs on the host. Jekyll runs in the wicket-site-jekyll container, which
# mounts this repository at /site; worktrees and output live in .previews/
# (gitignored) so the container can reach them. Every design is built with
# season_selector: true, which designs with seasonal photographs read to show
# their review selector.
#
# Usage: _previews/publish.sh [--no-push]

set -euo pipefail
cd "$(dirname "$0")/.."

PUSH=yes
[[ "${1:-}" == "--no-push" ]] && PUSH=no

REPO_URL=${REPO_URL:-https://github.com/dashorst/wicket-site.git}
SITE_URL=https://dashorst.github.io
BASE=/wicket-site
CONTAINER=${CONTAINER:-wicket-site-jekyll}
WORK=.previews
OUT=$WORK/site
DESIGNS=${DESIGNS:-_previews/designs.txt}
CHROME=$(ls -d ~/.cache/ms-playwright/chromium_headless_shell-*/*/chrome-headless-shell 2>/dev/null | tail -1)

trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; printf '%s' "${s%"${s##*[![:space:]]}"}"; }
html() { local s="$1"; s="${s//&/&amp;}"; s="${s//</&lt;}"; printf '%s' "${s//>/&gt;}"; }

git fetch -q dashorst
git fetch -q origin
rm -rf "$OUT"
mkdir -p "$OUT/thumbs"

slugs=() titles=() dates=() descs=()

while IFS='|' read -r slug source gemfile title date desc; do
    slug=$(trim "$slug")
    [[ -z "$slug" || "$slug" == \#* ]] && continue
    source=$(trim "$source"); gemfile=$(trim "$gemfile")
    echo "== $slug ($source)"

    if [[ "$gemfile" == static ]]; then
        # A sketch: a static folder committed at ref:path.
        ref=${source%%:*} path=${source#*:}
        tmp=$(mktemp -d -p "$WORK")   # inside the repository, so the container may read it (SELinux)
        git archive "$ref" "$path" | tar -x -C "$tmp"
        mv "$tmp/$path" "$OUT/$slug"
        chmod -R a+rX "$OUT/$slug"   # mktemp makes 0700 folders
        rm -rf "$tmp" "$OUT/$slug"/*.png
    else
        # A Jekyll site: build the ref in its own worktree with its own baseurl.
        tree=$WORK/$slug
        if [[ -d "$tree" ]]; then
            git -C "$tree" checkout -q --detach "$source"
        else
            git worktree add -q --detach "$tree" "$source"
        fi
        case "$gemfile" in
            site) gf=/site/$tree/Gemfile ;;
            old)  gf=/site/_previews/Gemfile.old ;;
        esac
        podman exec "$CONTAINER" bash -lc "
            set -e
            cd /site/$tree
            ruby -ryaml -e '
                c = YAML.unsafe_load_file(\"_config.yml\")
                ex = (c[\"exclude\"] || []) + %w[content .claude .previews _previews .impeccable PRODUCT.md DESIGN.md
                     Gemfile Gemfile.lock node_modules vendor/bundle/ vendor/cache/ vendor/gems/ vendor/ruby/]
                puts({ \"url\" => \"$SITE_URL\", \"baseurl\" => \"$BASE/$slug\", \"exclude\" => ex.uniq, \"season_selector\" => true }.to_yaml)
            ' > /tmp/preview-$slug.yml
            export BUNDLE_GEMFILE=$gf BUNDLE_PATH=/site/.bundle-cache
            bundle install --quiet
            bundle exec jekyll build --quiet --config _config.yml,/tmp/preview-$slug.yml -d /site/$OUT/$slug
        "
        # Older layouts link assets and pages from the site root; point them at the subfolder.
        find "$OUT/$slug" -name '*.html' -print0 | xargs -0 -r perl -pi -e \
            "s#((?:href|src|action|data-lazy)=[\"'])/(?!/)(?!${BASE#/}/)#\${1}$BASE/$slug/#g"
        find "$OUT/$slug" -name '*.css' -print0 | xargs -0 -r perl -pi -e \
            "s#url\\(([\"']?)/(?!/)(?!${BASE#/}/)#url(\${1}$BASE/$slug/#g"
        [[ -f "$OUT/$slug/tumblr.json" ]] && perl -pi -e \
            "s#(\"photo-url-[0-9]+\":\\s*\")/(?!${BASE#/}/)#\${1}$BASE/$slug/#g" "$OUT/$slug/tumblr.json"
    fi

    slugs+=("$slug"); titles+=("$(trim "$title")"); dates+=("$(trim "$date")"); descs+=("$(trim "$desc")")
done < "$DESIGNS"

# Screenshots of each first viewport for the chooser, served under the real path.
mkdir -p "$WORK/serve"
ln -sfn "$(pwd)/$OUT" "$WORK/serve/${BASE#/}"
port=4199
python3 -m http.server "$port" --bind 127.0.0.1 --directory "$WORK/serve" >/dev/null 2>&1 &
server=$!
trap 'kill $server 2>/dev/null || true' EXIT
sleep 1
for slug in "${slugs[@]}"; do
    "$CHROME" --headless --hide-scrollbars --force-prefers-reduced-motion --virtual-time-budget=5000 \
        --window-size=1440,960 --screenshot="$OUT/thumbs/$slug.png" \
        "http://127.0.0.1:$port$BASE/$slug/" >/dev/null 2>&1 || true
    magick "$OUT/thumbs/$slug.png" -resize 720x "$OUT/thumbs/$slug.png" 2>/dev/null || true
done

# The chooser page.
{
    cat <<'HEAD'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="noindex">
<title>Apache Wicket site designs</title>
<style>
  :root { color-scheme: light; --ink: #1d1d1f; --soft: #5c5c66; --rule: #d9d9de; --link: #0b57d0; }
  * { box-sizing: border-box; }
  body { margin: 0; font: 16px/1.55 system-ui, sans-serif; color: var(--ink); background: #fafafa; }
  main { max-width: 72rem; margin: 0 auto; padding: 3rem 1.25rem 4rem; }
  h1 { font-size: 2rem; line-height: 1.15; margin: 0 0 0.5rem; }
  .intro { color: var(--soft); max-width: 62ch; margin: 0 0 2.5rem; }
  ol { list-style: none; margin: 0; padding: 0; display: grid; gap: 2.5rem 2rem; grid-template-columns: repeat(auto-fill, minmax(20rem, 1fr)); }
  li { border-top: 1px solid var(--rule); padding-top: 1rem; }
  a.shot { display: block; aspect-ratio: 3 / 2; overflow: hidden; border: 1px solid var(--rule); background: #fff; }
  a.shot img { display: block; width: 100%; height: auto; }
  h2 { font-size: 1.15rem; margin: 0.9rem 0 0.15rem; }
  h2 a { color: var(--ink); }
  .date { color: var(--soft); font-size: 0.875rem; margin: 0 0 0.4rem; }
  .desc { margin: 0; }
  a { color: var(--link); text-underline-offset: 0.15em; }
  a:focus-visible { outline: 3px solid var(--link); outline-offset: 2px; }
</style>
</head>
<body>
<main>
<h1>Apache Wicket site designs</h1>
<p class="intro">Designs for wicket.apache.org, published side by side for comparison. The sketches show a homepage only; the full designs include every page. Content on the older designs is as of their date.</p>
<ol>
HEAD
    for i in "${!slugs[@]}"; do
        s=${slugs[$i]}
        cat <<ITEM
<li>
  <a class="shot" href="$s/" tabindex="-1" aria-hidden="true"><img src="thumbs/$s.png" alt="" width="720" height="480" loading="lazy"></a>
  <h2><a href="$s/">$(html "${titles[$i]}")</a></h2>
  <p class="date">$(html "${dates[$i]}")</p>
  <p class="desc">$(html "${descs[$i]}")</p>
</li>
ITEM
    done
    echo '</ol>'
    echo '</main>'
    echo '</body>'
    echo '</html>'
} > "$OUT/index.html"
touch "$OUT/.nojekyll"

du -sh "$OUT"
if [[ "$PUSH" == yes ]]; then
    cd "$OUT"
    rm -rf .git
    git init -q -b gh-pages
    git add -A
    git -c user.name="$(git -C ../.. config user.name)" -c user.email="$(git -C ../.. config user.email)" \
        commit -q -m "Publish site designs $(date +%F-%H%M)"
    git push -q --force "$REPO_URL" gh-pages
    echo "Published to $SITE_URL$BASE/"
fi
