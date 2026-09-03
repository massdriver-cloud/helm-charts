# Massdriver Chart 0.2.1

**Massdriver:** 2.5.0 · **UI:** 2.1.0

## Massdriver 2.5.0

### Added

- **Point in-app documentation links at your own docs site.** Set `massdriver.docsUrl` in your values to serve links from your own documentation. Leave it blank to keep linking to docs.massdriver.cloud.
- **Organization naming convention.** Organization settings now accept a Liquid template that controls how resource names are generated for new instances. Templates are validated on save and must include a unique identifier so every rendered name is distinct.
- **Separation of duty for deployment approvals.** Environments have a new setting that prevents the person who proposed a deployment from approving it. Proposers can still withdraw their own proposals.
- **Default bundle access for new repositories.** A new organization setting grants every project pull access to newly created bundle repositories automatically.
- **Version ranges on bundle dependencies.** Bundles declare a version range for each dependency and resource. The matching resource type version is chosen at deploy time, so an environment can hold one default per version and a bundle can pick up a compatible newer version without republishing. Remote references are checked against the expected type and version when assigned.
- **Versioned resource types published through the registry.** Resource types are now versioned and published by pushing to an OCI repository with the `RESOURCE_TYPE` artifact type. The `resourceType` API query accepts `name@version` and `name@~range`, and new queries list the dependents of a resource type in an environment and an environment's unfulfilled dependencies.
- **More list filters.** Projects, repositories, and resources can be filtered by creation date. Repositories and resources can be filtered by attributes. The resources filter accepts a resource type version range.
- **Personal access token and service account token mutations.** `createPersonalAccessToken` caps at one year and `createServiceAccountAccessToken` caps at ten years. The token dialog offers duration presets.
- **AWS Cost and Usage Reports in Parquet format.** The AWS cost integration has a new `format` option that accepts `parquet` in addition to the default `zip`.
- **Seat usage in the API.** Organization billing now reports `seatsUsed` alongside the licensed seat count.

### Changed

- **Seat limits are enforced on SCIM and SSO.** A seat is an active organization membership or a pending invitation. SCIM user creation and reactivation, and SSO auto-join, are refused when the organization is at its seat limit. SCIM refusals return HTTP 409 and the organization owner is emailed once per day. Existing members are never removed.
- **Links between components carry version constraints.** A link's connection is materialized only in environments where both components run versions that satisfy the link's constraints. Existing links were backfilled from their components' current versions, and links whose components run different versions across environments were split into one link per version pair.
- **Stricter bundle publishing.** Publishing rejects connection fields that declare more than one resource type and references to resource types the organization does not have. A dependency range with no published matching version now publishes, since matching happens at deploy time.
- **Policy attribute `md-resource-type` is version-qualified.** Values take the form `identifier@version`. A bare identifier continues to match every version.
- **Longer bundle and repository names.** The limit is raised from 53 to 100 characters.
- **API: `resourceType.id` is now `identifier@version`.** The `resourceTypes` list query is deprecated in favor of the versioned `resourceType` query.
- **API: id filters on `environments`, `integrations`, and `resourceTypes` use `IdFilter`.** Queries that declare a `StringFilter` variable for these fields must be updated.

### Removed

- **API: the deprecated `createAccessToken` mutation is removed.** Use `createPersonalAccessToken` or `createServiceAccountAccessToken`.
- **API: the unfiltered `bundles` list query is removed.** The singular `bundle` query now returns only bundles in repositories the caller can view.

### Fixed

- **Deployments using `.dependencies` in environment variables or step configuration no longer fail.** The jq document behind those settings now carries the renamed `dependencies` section alongside `connections`.
- **Redrawing a link between components on a release channel creates the connection.** Previously the link was saved without a connection when the components tracked `latest`.
- **Bundle publish no longer fails with a server error when a release-channel deployment cannot be queued.** The dropped deployment is reported instead.
- **Rapid successive deployments are queued in order.** Deployment timestamps use microsecond precision so same-second deployments no longer tie.
- **Resource type repositories show their tags, release channels, and icon** in the API and CLI.
- **Publishing a resource type with instructions no longer fails with "manifest invalid".**
- **Access token expiry errors are reported on the `expiresInMinutes` field** so clients can display them.
- **Import checks honor version-pinned policies** consistently with view and edit.

### Upgrade notes

- **Back up your database before upgrading.** This release renames several tables, backfills resource type repositories and link version constraints, and drops the cached bundle schema columns. Migrations run automatically on startup and may take longer than usual on large installations.
- **Check your seat usage before upgrading.** If your organization holds more active members and pending invitations than your license allows, SCIM will refuse to provision new users until usage falls below the limit. Existing members keep access.
- **Review API clients** for the removed `createAccessToken` mutation and `bundles` query, the `IdFilter` change, and the versioned `resourceType.id` format.
- **Colliding resource type names are renamed.** If an organization had a bundle repository and a resource type with the same name, the resource type repository is renamed with a `-resource` suffix. The previous name continues to resolve for reads.
- The new `massdriver.docsUrl` value is optional and defaults to docs.massdriver.cloud. No other values changes are required.

## UI 2.1.0

### Added

- **Organization dashboard.** The organization home page is now a dashboard with an overview of failed, awaiting-approval, and not-yet-deployed instances, plus org-wide Instances and Deployments tabs with filters and a per-instance deployment history drawer.
- **Documentation link follows your configured docs site.** The sidebar Documentation link reads the URL set by `massdriver.docsUrl`.
- **Separation of duty setting on environments.** The environment create, update, and fork forms expose the new setting, and the environments table shows it as a flag alongside Protected.
- **Default bundle access toggle.** Organization settings has a new General tab with a switch that grants all projects access to new bundle repositories. The members list moves to its own Members tab.
- **Redesigned filtering on list pages.** Projects, environments, repositories, and resources share a single Filters control with attribute filters, select filters, and calendar date ranges. Repositories and resources gain sorting, search, and attribute filters.
- **Versioned resource types throughout.** Canvas node handles show the resource type identifier and version separately along with the field's accepted version range. Environment defaults are picked per type version, with guidance on which versions unfulfilled instances need.
- **Rebuilt instance Dependencies and Resources tabs.** Both tabs are now row lists showing the field, the expected resource type and version, and what fulfills it, with actions in a per-row menu. The remote reference picker lists every resource that satisfies the field's version range.
- **Attributes chip on list tables.** Tables show a single attributes chip whose hover groups direct, inherited, and Massdriver-managed attributes. Attribute cards are added to the resource, project, and repository detail pages.
- **Permission-aware controls.** Buttons and forms across the app are disabled or hidden when the viewer's policies do not allow the action.
- **Smaller additions.** HTTPS values in the instance properties table render as links. A Create Environment button appears on the project overview. The organization settings header has a copy-ID button. The repository details header links to the selected version's source code. Dev build versions display as `v1.2.3-dev` with the full tag on hover.

### Fixed

- **Canvas handles fulfilled by an environment default no longer show as unmet.**
- **The per-environment canvas draws only that environment's links.** Previously it fetched every link in the project and could draw connections that did not apply.
- **Resource type lookups on the canvas and import dialog work again** after the API's versioned resource type id change.
- **Cached custom attribute schemas refresh when attributes change** instead of waiting for a page reload.
- **Missing or forbidden pages show a proper 404** instead of partially rendering.
- **The shared-grants tooltip on dependency rows displays.**

### Maintenance

- Dependency updates, including fixes for all reported package vulnerabilities.
