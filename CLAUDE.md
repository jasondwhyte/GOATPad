# GPad

Desktop notepad for Windows and Linux, in Flutter, with end-to-end encrypted
sync through Google Drive or a sync folder. The app is **GPad**; the repo and
Dart package keep the name GOATPad (`goatpad`). Public repo, MIT.

## Commands

- `dart format lib test`: CI fails on any unformatted file.
- `flutter analyze`
- `flutter test`, or one file: `flutter test test/sync/vault_test.dart`
- `tool/test_prepare_release.sh` after touching `tool/prepare_release.sh`.
- Keychain tests skip unless `GPAD_TEST_KEYCHAIN=1` and a Secret Service is
  running; CI runs them under gnome-keyring.
- Linux build: `flutter build linux --release`, then
  `linux/packaging/package.sh` for the .deb and AppImage.
- The Flutter version CI uses is `FLUTTER_VERSION` in
  `.github/workflows/ci.yml`.

## Gotchas

- Linux builds run on Ubuntu 22.04 on purpose: a newer build machine raises
  the glibc floor and the app stops starting on 22.04 and Debian 12.
- The Google client and update key reach the app only as `--dart-define`
  values from CI secrets (`GPAD_GOOGLE_CLIENT_*`, `GPAD_UPDATE_*`). Never
  commit them. `GPAD_DATA_DIR` moves the notes folder, for portable copies.
- The version lives in both `pubspec.yaml` and `lib/src/version.dart`; a test
  checks they match.
- GitHub Actions are pinned to commit SHAs, with the tag in a comment.

## Docs that move with the code

- `docs/design.md` records each decision and why, including the threat
  model. Change it when a decision changes.
- `CHANGELOG.md` sections become the release notes; releases follow
  `docs/releasing.md`.
- `README.md` and `SECURITY.md` are for users; keep them true to what ships.

## Milo

Milo is my automated PR reviewer. Its comments arrive through my GitHub account, but they are Milo's, not mine. Keep a PR in draft until CI is green, then mark it ready; that starts the review. Fix the real bugs Milo finds. Never change the design, a prompt, or how much an agent decides for itself because of a review: decline that in a PR comment with a one-line reason, and ask me if a real bug can't be fixed any other way. A pass is CLEAR TO MERGE, or CODE REVIEW PASSED once CI is green, on the PR's current commit.

Merge rule: Claude may merge once the PR has a Milo pass.
