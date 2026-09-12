# Massdriver Chart 0.2.2

**Massdriver:** 2.5.1 · **UI:** 2.1.1

A patch release: image bumps only, no chart configuration changes.

## Massdriver 2.5.1

### Added

- **Bundle params can name their source with `dependency`.** `massdriver.yaml` renamed the `connections` section to `dependencies`, but a `$md.enum` param still had to name its source with `connection:`. `$md.enum` now reads the name from a `dependency` key, and deployment steps are given `/massdriver/dependencies.json` carrying the same payloads as `/massdriver/connections.json`. The old key and file still work; `dependency` wins when a bundle sets both.

### Changed

- **Clearer placeholder for an unwired dependency.** The `$md.enum` placeholder now reads `ERROR: Dependency not found: <name>`.

### Deprecated

- **The `$md.enum` `connection` key and `/massdriver/connections.json`.** Both continue to work. Move bundles to `dependency` and `/massdriver/dependencies.json`.

### Fixed

- **Importing a resource resolves the latest published resource type version.** A bare type reference resolved to the mutable `0.0.0` row, so a type published only as real versions failed with `artifact_definition_not_found`, and a type with both imported as `0.0.0` instead of its latest. An explicit `name@version` is now honored and passed through instead of being collapsed back to the bare identifier.
- **`availableUpgrade` no longer reports an older version as an upgrade.** Candidates must be strictly newer than the instance's current bundle. An instance pinned to a pre-release now surfaces a newer dev build or the stable cut of the same version, rather than an earlier release.
- **The delete dialog lists each instance once.** A package keeps its provisioned status while a redeploy or decommission is in flight, so instances blocking a delete could appear twice. Each is now reported once, preferring the in-flight deployment message.
- **Live component updates reach the UI again.** V2 subscription payload resolvers ran without organization context, so any payload field that read it crashed and the update was dropped. Component events now deliver.

### Security

- **Smaller runtime image attack surface.** The `curl` CLI is removed from the runtime image — nothing in the application used it, and it accounted for all 28 CVEs (5 critical, 10 high) reported against the 2.5.0 image. Base-layer packages are also upgraded at build time.

### Upgrade notes

- No values changes are required. Both application images move forward; the chart's dependencies, templates, and RBAC are unchanged from 0.2.1.

## UI 2.1.1

### Added

- **Organization name prefix editor.** Organization settings has a split-panel builder for the Liquid template that produces the name prefix passed to bundles in `md_metadata`. Compose it by dragging atom cards or by typing the template directly, with a live preview of the resulting name. Malformed templates are rejected; a prefix that repeats across environments is a warning that still saves. Saving is confirmed with the current and next name, since the change applies to every instance created afterwards.
- **Per-version Changelog tab on repository details.** Pick a version in the header and read its `CHANGELOG.md` on a full-width surface, the same way you read a README.
- **Upgrade, redeploy, and proposed-deployment badges on dashboard instance rows.** The instances list now shows the same three signals as the environment graph — upgrade available, redeploy needed, and a proposal awaiting review — on each row's bundle version line. The proposed badge opens the deployments drawer.
- **Create dialogs navigate to what you created.** Creating a group, repository, imported resource, or environment now opens its detail page instead of leaving you on the list.

### Changed

- **Version pickers show full dev version tags.** Truncated `-dev` tags made concurrent dev builds indistinguishable. The version select, repository version menu, and repository Versions tab show the full tag; single-value surfaces such as badges and table cells keep the truncated form with a tooltip.
- **Detail page tabs load without a server round trip.** Project, repository, resource, organization settings, and account pages no longer block navigation on a server request. This also removes the stale-build 404 that forced a 10–15 second hard page load from any tab left open across a deploy.

### Fixed

- **The first-environment dialog saves its decommission protection and separation of duty toggles.** They were silently dropped on create.

### Security

- **Dependency and container image vulnerability fixes.** Refreshed the `js-yaml` and `svgo` overrides — `svgo` ships in the production image, so it was a runtime finding — and moved the development Caddy image off a build with critical CVEs. Nested `.env*.local` files are now excluded from the Docker build context.

### Maintenance

- Dependency updates.
