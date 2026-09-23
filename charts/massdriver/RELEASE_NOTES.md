# Massdriver Chart 0.2.4

**Massdriver:** 2.5.2 · **UI:** 2.1.3

The headline of this release is ARM64 support: both images now ship as multi-architecture images, so Massdriver runs on arm64 nodes (AWS Graviton, Azure Ampere, GCP Tau T2A, Apple Silicon dev clusters) without emulation. It also tightens resource type permissions and fixes version-range handling for resources.

## Platform

- **ARM64 images.** `massdrivercloud/massdriver` and `massdrivercloud/massdriver-ui` are published as multi-architecture manifests for `linux/amd64` and `linux/arm64`. Kubernetes pulls the right architecture automatically; no values changes are needed to schedule on arm64 nodes.

## Massdriver 2.5.2

### Changed

- **Resource type visibility follows repository permissions.** The resource type catalog now lists only types whose repository you hold `repo:view` on. Org admins see everything. To preserve current access, an upgrade migration gives every non-admin group with members an allow policy for `repo:view` and `repo:pull` on resource type repositories, plus `repo:push` for groups that could already publish resource types.
- **Publishing a bundle checks access to the resource types it references.** The publisher must hold `repo:pull` on every resource type the bundle references with a `name@version` reference. A denial fails the whole publish, writes nothing, and names the types, e.g. `no access to postgres-connection@1.2.3`. Bundles using legacy `$ref` references are not checked yet, so existing pipelines keep publishing.

### Added

- **REST resources show their resolved type and available upgrade.** The REST resource payload now includes `resource_type` (the exact `name@version` the resource was typed against), `version_constraint` (the range the producing bundle declared), and `available_upgrade` (the newest in-range version newer than the current one, or null). This matches the `availableUpgrade` field in the GraphQL API.

### Fixed

- **Resource version ranges are honored at deploy.** A bundle that declares `resource_type: name@~1` on a resources field now has its resources typed and schema-validated against the newest published version in that range, instead of the unversioned `0.0.0` definition. Moving to a newer version in range updates the resource in place and keeps its grants.
- **Importing a resource accepts a version range.** `mass resource create name@~1` resolves the range to the newest matching version instead of failing with "definition not found".
- **Organization IDs with hyphens are accepted on the create form.** The form now matches what the API already allowed.

### Security

- **Access tokens are scoped to their organization.** A token created in one organization could authenticate against another organization the same account belongs to on Bearer, websocket, and OCI registry requests. Tokens now work only in the organization they were created in. Browser sessions and deployment credentials keep their multi-organization access.

### Maintenance

- Dependency updates.

## UI 2.1.3

### Added

- **Pick a version when importing a resource.** The import dialog shows the chosen resource type in a card with a version selector. It defaults to the latest version, and switching versions reloads that version's form and setup instructions.

### Fixed

- **The import instructions panel no longer crashes.** Setup instructions containing Python or unlabeled code blocks broke syntax highlighting and crashed the panel.
- **Dark mode and markdown fixes in forms.** The bundles empty state renders correctly in dark mode, and markdown links in bundle parameter descriptions render as links instead of literal `[text](url)`.

## Upgrade notes

- No values changes are required. The chart's templates, dependencies, and RBAC are unchanged from 0.2.3.
- **Review resource type permissions after upgrading.** The migration preserves access for existing groups, but groups created afterwards need an explicit `repo:view` (and `repo:pull` to publish bundles that reference resource types) policy on resource type repositories, e.g. scoped to `md-repo-artifact-type: resource-type`.
- **Access tokens used across organizations will stop working.** If a CI pipeline or integration uses one access token against several organizations, create a token in each organization.
