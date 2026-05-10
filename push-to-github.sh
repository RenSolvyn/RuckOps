#!/usr/bin/env bash
# Push this RuckOps web MVP to your fork.
#
# Usage:
#   export GITHUB_TOKEN=ghp_...   # personal access token with `repo` scope
#   ./push-to-github.sh <github-username-or-org> [branch]
#
# Example:
#   export GITHUB_TOKEN=ghp_xxxxxxxx
#   ./push-to-github.sh RenSolvyn web-mvp
#
# The token is read from the environment and passed via http.extraHeader.
# It is NEVER written to disk, NEVER committed to git history, and NEVER
# placed in the remote URL.

set -euo pipefail

if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "ERROR: GITHUB_TOKEN env var not set."
  echo "Set it with: export GITHUB_TOKEN=ghp_your_token_here"
  exit 1
fi

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <github-username-or-org> [branch]"
  echo "Example: $0 RenSolvyn web-mvp"
  exit 1
fi

OWNER="$1"
BRANCH="${2:-web-mvp}"
REPO="RuckOps"
REMOTE_URL="https://github.com/${OWNER}/${REPO}.git"
UPSTREAM_URL="https://github.com/khurang-r/${REPO}.git"

# Initialize git if not already
if [ ! -d .git ]; then
  git init -q
  git checkout -q -b "${BRANCH}"
else
  # If on a different branch, create or switch
  current=$(git symbolic-ref --short HEAD 2>/dev/null || echo "")
  if [ "${current}" != "${BRANCH}" ]; then
    git checkout -q -B "${BRANCH}"
  fi
fi

# Configure local identity if not already set
if ! git config user.email > /dev/null 2>&1; then
  git config user.email "ruckops@example.com"
  git config user.name "RuckOps Web MVP"
fi

git add -A
if git diff --cached --quiet; then
  echo "Nothing to commit — working tree matches HEAD."
else
  git commit -q -m "Add web MVP: GitHub Pages-deployable PWA

- index.html / app.js / styles.css: vanilla ES module SPA
- All MVP screens: welcome, onboarding, home, pre-workout, live, summary, history, detail, profile
- Foreground GPS via Geolocation API + Wake Lock
- Leaflet + OSM for route maps
- localStorage persistence, CSV export
- PWA manifest + service worker
- .github/workflows/pages.yml deploys on push to main
- Original planning docs (Project 4 output) kept intact"
fi

# Force-push using a header-based auth — token never stored on disk
echo "Pushing to ${REMOTE_URL} branch ${BRANCH}..."
git -c http.extraHeader="Authorization: Bearer ${GITHUB_TOKEN}" \
    push --force "${REMOTE_URL}" "${BRANCH}:${BRANCH}"

echo ""
echo "Pushed."
echo ""
echo "Open a PR back to khurang-r/RuckOps:"
echo "  https://github.com/khurang-r/${REPO}/compare/main...${OWNER}:${REPO}:${BRANCH}?expand=1"
echo ""
echo "Once GitHub Pages is enabled in Settings → Pages → Source: GitHub Actions,"
echo "the live site will be at:"
OWNER_LC=$(printf '%s' "${OWNER}" | tr '[:upper:]' '[:lower:]')
echo "  https://${OWNER_LC}.github.io/${REPO}/"
