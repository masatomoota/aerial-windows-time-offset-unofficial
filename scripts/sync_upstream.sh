#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/sync_upstream.sh [--branch <name>] [--push] [--no-cleanup]

Options:
  --branch <name>  Branch name to create (default: chore/sync-upstream-YYYYMMDD)
  --push           Push the created branch to origin
  --no-cleanup     Keep temporary worktree after success
  -h, --help       Show this help
EOF
}

BRANCH_NAME="chore/sync-upstream-$(date +%Y%m%d)"
PUSH_BRANCH=0
KEEP_WORKTREE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --branch)
      [[ $# -ge 2 ]] || { echo "error: --branch requires a value" >&2; exit 1; }
      BRANCH_NAME="$2"
      shift 2
      ;;
    --push)
      PUSH_BRANCH=1
      shift
      ;;
    --no-cleanup)
      KEEP_WORKTREE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

git remote get-url origin >/dev/null
git remote get-url upstream >/dev/null

if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
  echo "error: local branch already exists: $BRANCH_NAME" >&2
  exit 1
fi
if git show-ref --verify --quiet "refs/remotes/origin/$BRANCH_NAME"; then
  echo "error: remote branch already exists on origin: $BRANCH_NAME" >&2
  exit 1
fi

TMP_WORKTREE="${TMPDIR:-/tmp}/aerial-sync-$$"
cleanup() {
  if [[ $KEEP_WORKTREE -eq 0 ]] && [[ -d "$TMP_WORKTREE" ]]; then
    git worktree remove "$TMP_WORKTREE" --force >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

echo "Fetching origin/upstream..."
git fetch origin --prune
git fetch upstream --prune

echo "Creating worktree and branch: $BRANCH_NAME"
git worktree add -b "$BRANCH_NAME" "$TMP_WORKTREE" origin/master >/dev/null

echo "Merging upstream/master into $BRANCH_NAME"
if ! git -C "$TMP_WORKTREE" merge --no-ff upstream/master -m "chore: sync upstream master ($(date +%Y-%m-%d))"; then
  KEEP_WORKTREE=1
  echo "Merge conflict detected. Resolve in: $TMP_WORKTREE" >&2
  echo "After resolving, push with: git -C \"$TMP_WORKTREE\" push origin \"$BRANCH_NAME\"" >&2
  exit 1
fi

if [[ $PUSH_BRANCH -eq 1 ]]; then
  echo "Pushing branch to origin..."
  git -C "$TMP_WORKTREE" push origin "$BRANCH_NAME"
fi

NEW_HEAD="$(git -C "$TMP_WORKTREE" rev-parse --short HEAD)"
echo
echo "Done."
echo "Branch: $BRANCH_NAME"
echo "Head:   $NEW_HEAD"
echo
echo "Next steps:"
echo "  1) Review changes:"
echo "     git log --oneline origin/master..$BRANCH_NAME"
echo "  2) Run tests/build:"
echo "     npm test"
echo "     npm run build"
echo "  3) Merge into master when ready:"
echo "     git switch master"
echo "     git merge --no-ff $BRANCH_NAME"
echo "     git push origin master"
