#!/usr/bin/env bash
set -euo pipefail

releasesRepo="kiwicangaceiro/UTeamsReleases"
scriptDirectory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
projectDirectory="$(dirname "$scriptDirectory")"
uteamsReleaseDirectory="$projectDirectory/../UTeams/release"
versionFile="$projectDirectory/../UTeams/VERSION"

if [ ! -f "$versionFile" ]; then
  echo "Cannot find UTeams/VERSION at $versionFile"
  exit 1
fi

version="$(tr -d '[:space:]' < "$versionFile")"
tag="v$version"

if ! ls "$uteamsReleaseDirectory"/*.deb >/dev/null 2>&1 ||
   ! ls "$uteamsReleaseDirectory"/*.AppImage >/dev/null 2>&1 ||
   [ ! -f "$uteamsReleaseDirectory/SHA256SUMS.txt" ]; then
  echo "Missing built artifacts in $uteamsReleaseDirectory."
  echo "Build them first: (cd ../UTeams && npm run dist && npm run sign)"
  exit 1
fi

files=("$uteamsReleaseDirectory"/*.deb "$uteamsReleaseDirectory"/*.AppImage "$uteamsReleaseDirectory/SHA256SUMS.txt")

if ls "$uteamsReleaseDirectory"/*.asc >/dev/null 2>&1; then
  files+=("$uteamsReleaseDirectory"/*.asc)
else
  echo "WARNING: no GPG signatures (.asc) found. Users will not be able to verify authenticity."
  echo "Sign first with: (cd ../UTeams && npm run sign)"
  read -r -p "Publish UNSIGNED anyway? [y/N] " confirm
  [ "$confirm" = "y" ] || exit 1
fi

echo "Publishing $tag to $releasesRepo with:"
printf '  %s\n' "${files[@]}"

gh release create "$tag" "${files[@]}" \
  --repo "$releasesRepo" \
  --title "UTeams $version" \
  --notes "UTeams $version. Verify your download against SHA256SUMS.txt and its GPG signature - see the repository README."
