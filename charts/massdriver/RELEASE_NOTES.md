# Massdriver Chart 0.3.0

**Massdriver:** 2.6.0 · **UI:** 2.1.7

This release adds deployment identity tokens, so provisioners can authenticate to your cloud accounts without long-lived credentials, and makes the user login session lifetime configurable. It updates Massdriver to 2.6.0, which adds editable starter groups for new organizations, configurable default tags, a way to copy an environment into a new project, and new bundle param pickers. It updates the UI to 2.1.7, which adds member and service account detail pages, a proposal review view, and a Default tags settings tab.

## Platform

- **Deployment identity tokens.** Massdriver can act as an OIDC identity provider for deployments. Each deployment gets signed identity tokens at the organization, project, environment, and instance level. Your cloud (AWS, GCP, Azure, Vault, Kubernetes) can trust these tokens and grant roles based on their subject and claims, so provisioners authenticate without stored cloud credentials. Configure it under `provisioner.identityTokens`: set `signingKey` to an RSA private key in PEM format and the chart creates a Secret for it, or set `existingSecret` to the name of a Secret you manage. The discovery documents are served from the API at `/.well-known/openid-configuration` and `/.well-known/jwks.json`. The feature is off until a signing key is configured.
- **Configurable login session lifetime.** Set `massdriver.sessionTtlHours` to control how long a user's login session lasts. Users log in again that many hours after they log in, whether they are active or not. The default is 720 hours (30 days).

## Massdriver 2.6.0

### Added

- **Editable starter groups for new organizations.** New organizations get Organization Viewers, Developers, Production Deployers, Platform Engineers, CI / Automation, and Billing groups with matching policies. They start with no members, and admins can rename them, delete them, or change their policies.
- **Choose the attributes sent as default tags.** Organization admins can choose which project, environment, component, and custom attributes Massdriver sends to provisioning runs as default tags. Once enabled, every instance also gets `managed-by: massdriver` and an `md-instance` tag. Organizations keep the current default tags until an admin enables tag selection. Cost and alarm data find instances by the `md-instance` tag as well as the current `md-package` tag.
- **Copy an environment into a new project.** Create a new project from an existing environment. The new project gets the source project's blueprint and one environment whose instances use the same bundle versions. You can start the instances empty, copy their configured params, or copy the params from their latest deployment.
- **Pick groups, service accounts, and projects in bundle params.** Bundle params can use `$md.list` to let users pick Massdriver groups, service accounts, or projects from a list.
- **Resource type forms and exports.** Resource types can set a UI schema under `ui.schema` to control how their forms render, and can declare export formats other than YAML, such as a shell script.
- **Deployments can list their instance's resources.** `GET /v1/resources` with a deployment token returns the resources that the deployment's instance produced.
- **Bundle schemas on the V2 API.** The `Bundle` type has `paramsSchema` and `uiSchema` fields, so you can read the schemas of any bundle version.

### Changed

- **Login sessions end after a fixed time.** Users must log in again 30 days after they log in, or after `massdriver.sessionTtlHours`. Before, each token refresh extended the session, so active users stayed logged in.
- **OIDC autojoin adds users to the admin group.** Users who join an organization through `autojoinOrganization` are added to its admin group. Autojoin skips users who are already members, so existing members keep their groups.
- **The organization viewer group is now an editable group.** In existing organizations, the built-in viewer group becomes a regular group that admins can rename, delete, or change. It keeps its name, members, and policies, and gains allow policies for viewing projects, repositories, and resources.
- **Organization identifiers can't be reused.** After an organization is deleted, no new organization can register its identifier.
- **Undeclared custom attributes are rejected.** When an organization declares no custom attributes for a scope, setting an attribute on that scope is rejected. Values already stored are unchanged.

### Fixed

- **Service accounts that have deployed can be deleted.** Deleting a service account keeps its deployments, which still name it as the deployer, and stops any environment rollouts it started.
- **Cost totals are exact.** Stored cost amounts no longer pick up floating-point rounding when they are summed or averaged.

### Security

- **Service accounts and deployments can only access OCI repositories in their own organization.**

## UI 2.1.7

### Added

- **Default tags settings.** A Default tags tab in organization settings lets admins enable tag selection and choose which attributes are sent. The create attribute dialog can add the new attribute to the default tags.
- **Copy to New Project.** The environment header has a Copy to New Project action, and Clone Project lets you choose between cloning the full project or one environment.
- **Proposal review.** When an instance has proposed deployments, the Config tab shows a review view that displays each proposal in the config form, so reviewers see exactly what would deploy.
- **Service account details.** Each service account has a detail page with its last use, the access its groups grant, recent activity, and its groups. The Service accounts table can sort by last use.
- **Member details.** Each member has a detail view with their seat status and groups. Admins can remove the member from a group there.
- **Your groups.** The account Organizations tab lists the groups you belong to in each organization.
- **Search and sort for members and groups.** The Members and Groups tables have search, more sortable columns, and a rows-per-page picker.
- **Collapsible array items in forms.** Each item in an array field can be collapsed, with Expand all and Collapse all controls.
- **Origin instance links.** A provisioned resource's origin instance links to the environment canvas with that instance open.

### Changed

- **Config tab validates before deploy.** Deploy and Propose check required fields and param rules first and show errors inline on the field, including errors returned by the server.
- **Version lists stay current.** The version dropdown refreshes each time it opens, and instances on a development channel or version open Edit Version with development versions shown.
- **Full project and environment names in the header.** The header dropdowns show full names and only shorten them when space runs out.

### Security

- **Updated Next.js and other dependencies to address published security advisories.**
- **Removed an unused endpoint, and pages can no longer be embedded in frames on any origin.**

### Maintenance

- Dependency updates.

## How to upgrade

Follow the [standard update steps](https://docs.massdriver.cloud/platform-operations/self-hosted/install#updating-your-installation):

```bash
helm repo update
helm upgrade massdriver massdriver/massdriver \
  -n massdriver \
  -f values-custom.yaml
```

No changes to `values-custom.yaml` are required.

## Upgrade notes

- **New optional values: `provisioner.identityTokens` and `massdriver.sessionTtlHours`.** Identity tokens stay off until you set a signing key. The session lifetime defaults to 720 hours.
- **Existing login sessions end within 30 days.** Sessions that started before the upgrade keep their current expiry. Sessions that start after the upgrade end `massdriver.sessionTtlHours` after login.
- **Review OIDC autojoin.** If you set `autojoinOrganization` on an OIDC provider, users who join through it become organization admins. Remove `autojoinOrganization` to stop automatic joining, and invite users to the groups they need instead.
- RBAC, subchart versions, and all other values are unchanged.
