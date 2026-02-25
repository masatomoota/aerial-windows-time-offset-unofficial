# Fork Publishing Checklist

This repository is intended to be published as an unofficial fork of `OrangeJedi/Aerial`.

## Recommended Repository Naming
- Display name: `Aerial for Windows Time Offset (Unofficial)`
- GitHub repository slug example: `aerial-windows-time-offset-unofficial`

Note: GitHub repository names cannot include spaces.

## GitHub Repository Settings
1. Keep this repository as a GitHub Fork (do not detach from parent unless required).
2. Set a clear description, for example:
   - `Unofficial fork of OrangeJedi/Aerial with configurable time offset display support.`
3. Keep repository visibility `Public` if you intend to distribute binaries publicly.
4. Enable `Issues` only if you want to accept support requests for this fork.

## Required Documentation
1. Keep upstream MIT `LICENSE` text and attribution intact.
2. Keep fork disclosure and upstream link in `README.md`.
3. Keep `NOTICE.md` with attribution and fork scope.
4. In each release note, include:
   - upstream base version/commit
   - fork-specific changes
   - known behavior differences from upstream

## Sync Practice with Upstream
1. Keep `upstream` remote configured: `https://github.com/OrangeJedi/Aerial.git`
2. Regularly fetch upstream and merge/rebase intentionally.
3. Document conflict resolutions when fork behavior intentionally diverges.

### One-command sync helper
Use the helper script to create an upstream-sync branch from `origin/master` in an isolated worktree:

```bash
scripts/sync_upstream.sh --push
```

- Default branch name: `chore/sync-upstream-YYYYMMDD`
- If merge conflicts occur, the script keeps the temporary worktree path and prints recovery steps.
