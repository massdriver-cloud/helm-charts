---
description: Generate public release notes for the massdriver chart into charts/massdriver/RELEASE_NOTES.md
allowed-tools: Bash(git:*), Read, Write, Glob, Grep
---

Generate customer-facing release notes for the `massdriver` chart and overwrite
`charts/massdriver/RELEASE_NOTES.md` with them. chart-releaser publishes this file
verbatim as the GitHub Release body when the chart version merges to main.

## Gather the diff

1. Read the new chart version from `charts/massdriver/Chart.yaml` (working tree).
2. Find the last published release of this chart (note the glob excludes
   `massdriver-alarm-channel-*` and `massdriver-prometheus-rules-*`):

   ```
   git tag -l 'massdriver-[0-9]*' --sort=-v:refname | head -1
   ```

   Run `git fetch --tags` first if the tag list looks stale.
3. Compare `charts/massdriver/values.yaml` and `charts/massdriver/Chart.yaml` at that
   tag against the working tree. Extract old → new image tags for:
   - `massdrivercloud/massdriver` (API) — tags in the app repo are bare versions, e.g. `2.4.0`
   - `massdrivercloud/massdriver-ui` (UI) — tags in the app repo are prefixed, e.g. `web-v2.0.13`
   Also note chart-level changes: dependency version bumps, removed/added values blocks,
   template/RBAC changes.
4. The app repos (`massdriver` and `massdriver-ui`) are sibling directories of the
   primary helm-charts checkout. From a linked worktree, locate the primary checkout
   with `git rev-parse --git-common-dir` and look next to it. Run
   `git -C <repo> fetch --tags`, then for each image whose tag changed:

   ```
   git -C <repo> log --oneline <old-tag>..<new-tag>
   ```

   Read individual commits with `git -C <repo> show <sha>` when the one-line subject
   isn't enough to judge customer impact.

## Write the notes

Overwrite `charts/massdriver/RELEASE_NOTES.md`. The first line MUST be
`# Massdriver Chart <new chart version>` — the pre-commit hook checks for the version
on that line. Follow with the app versions, then sections per app and, when relevant,
chart-level upgrade notes. Match the structure of the previous release's notes
(`git show <last-release-tag>:charts/massdriver/RELEASE_NOTES.md`) when it exists.

Audience and style — the readers are self-hosted customers, not Massdriver engineers:

- Only include changes a customer can observe: behavior fixes, new features, API/UI
  changes, deployment topology changes, required values changes.
- Skip internal refactors, module renames with no API change, test infrastructure,
  and CI changes entirely. Collapse dependency bumps to a single "Maintenance:
  dependency updates" line.
- Use public terminology: "bundles" (not "bundle releases"), "resources" (not
  "artifacts"). No internal module names.
- Plain, direct English. Lead each bullet with the user-visible outcome in bold,
  then one or two sentences of detail.
- Add an "Upgrade notes" section whenever the chart diff removes or renames values,
  changes RBAC, or bumps a subchart dependency — state what the operator must do,
  or that no action is required.

Do not commit — the pre-commit hook (or the operator) stages and commits the file
with the version bump. Do not modify any other file.
