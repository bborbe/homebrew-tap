# bborbe/homebrew-tap

Homebrew tap for [bborbe](https://github.com/bborbe) CLI tools.

## Install

```bash
brew install bborbe/tap/dark-factory
brew install bborbe/tap/vault-cli
brew install bborbe/tap/vault-ui
brew install bborbe/tap/git-ai-sync
brew install bborbe/tap/distill
```

## How casks get here

Casks are published by goreleaser when a GitHub **Release is published** on the
source repo. A git tag alone does **not** reach this tap — the source repos
auto-tag every merge, and only tags a human promotes to a Release (after walking
that repo's scenarios) become brew-installable.

See each repo's `docs/releasing-<repo>.md` for the promotion procedure.

`vault-ui` and `git-ai-sync` are the exceptions: they are Python packages, not
GoReleaser binaries. Their tag-triggered `release-wheel` workflows (in each
source repo) attach the wheel to a Release automatically, and the
`.github/workflows/update-*-cask.yml` workflows in this tap keep each cask's
version + sha256 in sync — no manual promotion.
