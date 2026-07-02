# UTeams - Downloads

UTeams is a free, standalone Microsoft Teams desktop app for Linux (Ubuntu). This repository
hosts the **official downloadable builds**. The source code is closed and is not published
here.

**Freeware** - free to use, **not for sale**, and may not be modified, reverse engineered, or
redistributed. See [LICENSE](LICENSE). UTeams is an independent product, not affiliated with
or endorsed by Microsoft. "Microsoft" and "Teams" are trademarks of Microsoft Corporation.

## Download

Get the latest `.deb` or AppImage from the Releases page:

**https://github.com/kiwicangaceiro/UTeamsReleases/releases/latest**

## Install

`.deb` (recommended - adds an app-menu entry):

```bash
sudo apt install ./uteams_<version>_amd64.deb
# remove with:
sudo apt remove uteams
```

AppImage (self-contained single file, nothing installed system-wide):

```bash
chmod +x UTeams-<version>.AppImage
./UTeams-<version>.AppImage
```

## Verify your download is genuine

Only builds from this Releases page that pass these checks are official. A repackaged or
malware-injected build cannot produce a valid signature from the official key.

Every release includes `SHA256SUMS.txt` and a detached GPG signature `SHA256SUMS.txt.asc`.

```bash
curl -s https://github.com/kiwicangaceiro.gpg | gpg --import   # once; the author's public key
gpg --verify SHA256SUMS.txt.asc SHA256SUMS.txt     # expect: Good signature
sha256sum -c SHA256SUMS.txt                          # expect: OK
```

If either check fails, do not install the build.

## Support

UTeams is a personal freeware project by Raul Bento ([bentosoft.net](https://bentosoft.net)).
