# Hand-maintained cask (not GoReleaser-generated): git-ai-sync is a Python
# package distributed as a wheel, installed as a uv tool. The version and
# sha256 are bumped by .github/workflows/update-git-ai-sync-cask.yml when a new
# git-ai-sync release is published.
cask "git-ai-sync" do
  version "0.11.2"
  sha256 "5516f9fdca223c5a42f9c560df81db66297b3c5cf3560f2a85bfad576a42e279"

  url "https://github.com/bborbe/git-ai-sync/releases/download/v#{version}/git_ai_sync-#{version}-py3-none-any.whl"

  name "git-ai-sync"
  desc "Automatic Git repo sync with AI-powered conflict resolution (launchd agent)"
  homepage "https://github.com/bborbe/git-ai-sync"

  depends_on formula: "uv"

  # postflight does not inherit the user shell's PATH — the uv formula was
  # just poured, so resolve it via the Homebrew prefix.
  uv = File.join(HOMEBREW_PREFIX, "bin", "uv")

  postflight do
    system_command uv,
                   args: ["tool", "install", "--force",
                          "https://github.com/bborbe/git-ai-sync/releases/download/v#{version}/git_ai_sync-#{version}-py3-none-any.whl"],
                   print_stdout: true

    # Register the default (Personal) vault's launchd agent. The wheel is a
    # zip, so Homebrew stages it unpacked — install from the release URL instead
    # of staged_path (the sha256 above already validated the artifact). The uv
    # install above put the binary at ~/.local/bin/git-ai-sync; call it by that
    # absolute path because postflight inherits no shell PATH.
    #
    # Best-effort on purpose: `setup-launchd` bootstraps into the gui domain,
    # which fails from SSH / sandboxed install contexts. A broken agent must
    # not fail the cask install — the caveats carry the manual start command.
    # The default vault path is home-relative so the agent is registered for
    # the installing user, not the maintainer.
    default_vault = File.join(Dir.home, "Documents", "Obsidian", "Personal")
    binary = File.join(Dir.home, ".local", "bin", "git-ai-sync")
    system_command binary,
                   args: ["setup-launchd", default_vault],
                   must_succeed: false,
                   print_stdout: true
  end

  uninstall_postflight do
    default_vault = File.join(Dir.home, "Documents", "Obsidian", "Personal")
    binary = File.join(Dir.home, ".local", "bin", "git-ai-sync")
    system_command binary,
                   args: ["remove-launchd", default_vault],
                   must_succeed: false,
                   print_stdout: true
    system_command uv,
                   args: ["tool", "uninstall", "git-ai-sync"],
                   must_succeed: false,
                   print_stdout: true
  end

  caveats do
    <<~EOS
      git-ai-sync is installed as a uv tool and its Personal-vault watcher is
      registered as the launchd agent com.github.bborbe.git-ai-sync-personal
      (watching ~/Documents/Obsidian/Personal).

      If the agent is not running (launchd could not be managed from the
      install context), start it with:
        git-ai-sync setup-launchd ~/Documents/Obsidian/Personal
        # or, when already loaded: launchctl kickstart -k gui/$(id -u)/com.github.bborbe.git-ai-sync-personal

      Per-vault agents (additional Obsidian vaults on this machine):
        git-ai-sync setup-launchd <vault-dir>     # add a watcher
        git-ai-sync remove-launchd <vault-dir>    # remove a watcher

      Update: brew upgrade git-ai-sync
    EOS
  end
end
