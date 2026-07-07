#!/usr/bin/env bash
# Build a signed apt repository from .deb artifacts.
# Usage: build-apt-repo.sh <deb-dir> <output-dir> <gpg-key-id>
set -euo pipefail

DEB_DIR="${1:?deb dir required}"
OUT_DIR="${2:?output dir required}"
GPG_KEY_ID="${3:?gpg key id required}"

ORIGIN="${APT_ORIGIN:-Bentosoft}"
LABEL="${APT_LABEL:-Bentosoft}"
SUITE="stable"
COMPONENT="main"
ARCHES=(amd64 arm64)

rm -rf "$OUT_DIR/dists"
mkdir -p "$OUT_DIR/pool/main"
cp "$DEB_DIR"/*.deb "$OUT_DIR/pool/main/" 2>/dev/null || true

pushd "$OUT_DIR" >/dev/null
for arch in "${ARCHES[@]}"; do
  mkdir -p "dists/$SUITE/$COMPONENT/binary-$arch"
  apt-ftparchive packages pool/main >"dists/$SUITE/$COMPONENT/binary-$arch/Packages"
  gzip -kf "dists/$SUITE/$COMPONENT/binary-$arch/Packages"
done
apt-ftparchive \
  -o "APT::FTPArchive::Release::Origin=$ORIGIN" \
  -o "APT::FTPArchive::Release::Label=$LABEL" \
  -o "APT::FTPArchive::Release::Suite=$SUITE" \
  -o "APT::FTPArchive::Release::Codename=$SUITE" \
  -o "APT::FTPArchive::Release::Components=$COMPONENT" \
  -o "APT::FTPArchive::Release::Architectures=${ARCHES[*]}" \
  release "dists/$SUITE" >"dists/$SUITE/Release"
gpg --batch --yes --default-key "$GPG_KEY_ID" -abs -o "dists/$SUITE/Release.gpg" "dists/$SUITE/Release"
gpg --batch --yes --default-key "$GPG_KEY_ID" --clearsign -o "dists/$SUITE/InRelease" "dists/$SUITE/Release"
popd >/dev/null
echo "Built signed apt repo in $OUT_DIR (key $GPG_KEY_ID)"
