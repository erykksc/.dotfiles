## Git worktrees

- Create shared worktrees at `~/dev/.worktrees/{repo}/{branch-slug}`.
  Use the primary checkout's directory name, even from a linked checkout;
  replace `/` with `-` in branch names (`feature/auth` → `feature-auth`).
- Check `git worktree list` and the destination first. On name collisions,
  choose a distinct branch name; never overwrite a checkout.
- Prefer Worktrunk or Git for creation/removal; agents should reuse existing paths.
- Do not move or recreate existing worktrees. Tool-managed private worktrees
  keep their own locations and lifecycle.
