# bborbe/homebrew-tap

Homebrew tap for [bborbe](https://github.com/bborbe) CLI tools.

## Install

```bash
brew install bborbe/tap/dark-factory
brew install bborbe/tap/vault-cli
brew install bborbe/tap/vault-ui
brew install bborbe/tap/distill
```

## How casks get here

Casks are published by goreleaser when a GitHub **Release is published** on the
source repo. A git tag alone does **not** reach this tap — the source repos
auto-tag every merge, and only tags a human promotes to a Release (after walking
that repo's scenarios) become brew-installable.

See each repo's `docs/releasing-<repo>.md` for the promotion procedure.

`vault-ui` is the exception: it is a Python package, not a GoReleaser binary.
Its tag-triggered `release-wheel` workflow (in the vault-ui repo) attaches the
wheel to a Release automatically, and `.github/workflows/update-vault-ui-cask.yml`
in this tap keeps the cask's version + sha256 in sync — no manual promotion.
