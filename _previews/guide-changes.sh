#!/bin/bash
# Lists the changes to the AsciiDoc user guide in apache/wicket between two refs, and the
# pages in _guide/ that were written from each changed file (their `source` front matter).
# Run it at every release to carry the guide's changes over; see "Releases" in GUIDE.md.
#
# Usage: _previews/guide-changes.sh [--diff] <from-ref> <to-ref>
#
#   _previews/guide-changes.sh rel/wicket-11.0.0 rel/wicket-12.0.0
#   _previews/guide-changes.sh --diff origin/wicket-10.x origin/master
#
# --diff also prints the diff of every changed file. The refs are refs of the Wicket
# repository in $WICKET_DIR (default: a clone named wicket next to this repository's main
# checkout, also when run from a worktree); fetch it first.

set -euo pipefail
cd "$(dirname "$0")/.."

DIFF=no
[[ "${1:-}" == "--diff" ]] && { DIFF=yes; shift; }
if [[ $# -ne 2 ]]; then
    sed -n '2,14s/^# \{0,1\}//p' "$0"
    exit 1
fi
FROM=$1 TO=$2
WICKET_DIR=${WICKET_DIR:-$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")/../wicket}
GUIDE=wicket-user-guide/src/main/asciidoc

# "<adoc file> <slug>" for every source of every page.
map=$(awk '
    FNR == 1 { slug = FILENAME; sub(/.*\//, "", slug); sub(/\.md$/, "", slug); fm = 0 }
    /^---$/ { fm++; next }
    fm == 1 && /^source:/ {
        s = $0; sub(/^source:[ ]*\[/, "", s); sub(/\][ ]*$/, "", s)
        n = split(s, parts, ",")
        for (i = 1; i <= n; i++) { p = parts[i]; gsub(/^[ "]+|[ "]+$/, "", p); if (p != "") print p, slug }
    }' _guide/*.md)

changes=$(git -C "$WICKET_DIR" diff --numstat "$FROM" "$TO" -- "$GUIDE")
if [[ -z "$changes" ]]; then
    echo "No changes to the user guide between $FROM and $TO."
    exit 0
fi

echo "User guide changes between $FROM and $TO"
echo
pages=()
while read -r added deleted path; do
    file=${path#"$GUIDE/"}
    slugs=$(awk -v f="$file" '$1 == f { print $2 }' <<< "$map" | sort -u | paste -sd ' ')
    if [[ -n "$slugs" ]]; then
        pages+=($slugs)
    elif [[ "$file" == */* ]]; then
        slugs="NEW OR UNMAPPED: give it a page, or add it to a page's source"
    else
        slugs="(chapter file or single.adoc: check for new sections)"
    fi
    printf '%-44s +%-4s -%-4s %s\n' "$file" "$added" "$deleted" "$slugs"
done <<< "$changes"

echo
echo "Pages to review:"
printf '%s\n' "${pages[@]}" | sort -u | sed 's/^/  _guide\//; s/$/.md/'

if [[ $DIFF == yes ]]; then
    echo
    git -C "$WICKET_DIR" --no-pager diff "$FROM" "$TO" -- "$GUIDE"
fi
