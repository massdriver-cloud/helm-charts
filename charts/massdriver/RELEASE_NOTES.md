# Massdriver Chart 0.4.0

**Massdriver:** 2.7.0 · **UI:** 2.1.8

This release updates Argo Workflows to v4.1.6, adds service accounts for Argo's executor and artifact garbage collection, and ships Massdriver 2.7.0 and UI 2.1.8 with event destinations, moving instances between projects, and the full external resource chain on the environment graph.

## Massdriver 2.7.0

- **Event destinations.** Organization admins can send audit log events to HTTP endpoints through the V2 API. Each destination can filter events and add a jq condition, and admins can pause, resume, and delete destinations, see each destination's deliveries, resend failed deliveries, and test a filter against recent events before saving it.
- **Move an instance to another project.** The new `moveInstance` mutation moves an instance into an environment in another project. Its connections and links are carried over, and a component is added to the destination project when needed.
- **Audit log event names and attributes.** Audit log events are recorded under V2 event names. Each event stores the entity's custom and `md-*` attributes as they were when it happened, and you can filter by them. Per-event values such as the credential used are now under `metadata`. In event data, the `context` key is now `actor` and the `resource` key is now `entity`; existing rows are renamed during the upgrade.
- **Every organization member can see the member list.** Listing an organization's members no longer requires the `organization:manageProfile` action.
- **New `organization:manageMembers` action.** Removing a member from an organization now requires `organization:manageMembers` instead of `organization:manageProfile`. Every existing policy that allows `organization:manageProfile` is given `organization:manageMembers` during the upgrade, so no policy changes are needed.
- **Connections follow bundle version changes.** When an instance's bundle version moves outside the version range of a link, its connections are moved to a matching link or removed. Existing connections that no longer match are reconciled during the upgrade.
- **Bundle version channels.** `ociRepo` tags and release channels accept a `channel` filter, so clients can page through only stable or only development versions.
- **Bundle visibility by project.** `ociRepos` can be filtered to the bundles available to a project, or to bundles the current user can see.
- **Resource producers and access.** Environment defaults show the instance that produced a resource and the groups that can view it.
- **Resource type icons and descriptions.** The repository list and canvas show the icon and description from a resource type's newest version.
- **`connection.deleted` events are sent after the change is saved.** Previously they could be sent before a version change finished.
- **New organizations start on the selected default tags.**
- **Faster instance lists.** Listing instances loads resources and dependencies in batches.
- **Maintenance:** dependency updates.

## UI 2.1.8

- **Full external resource chain.** The environment graph can show the full chain of external resources an environment depends on, with read-only resource handles and the groups that have access on nodes you can't view. A mode menu replaces the external resources toggle.
- **Move an instance to another project.** You can move an instance into another project's environment from the UI, with a reminder to redeploy it.
- **Hide initialized and decommissioned instances.** A canvas toggle hides instances that haven't been deployed or have been decommissioned.
- **Bundles drawer split.** The bundles drawer lists the project's bundles and your own bundles separately.
- **Audit log details.** Audit log entries show the credential used and the entity's attributes, and the filters are in a filter bar.
- **Delete repositories with unused versions.** A repository whose published versions aren't in use can be deleted.
- **Attribute edit form.** The edit attribute form shows its current values when it first opens.
- **Maintenance:** dependency updates.

## Platform

- **Argo Workflows v4.1.6.** The `argo-workflows` subchart moves from 0.47.5 to 2.0.18, and Argo Workflows from v3.7.11 to v4.1.6. This fixes failed workflows that never got deleted after their 24-hour TTL because the `workflows.argoproj.io/artifact-gc` finalizer was never removed. Workflows already stuck this way are released by the new controller on its own.
- **Workflow executor service account.** The chart creates a `<release>-workflow-executor` ServiceAccount and its token Secret, binds it to Argo's workflow Role, and passes its name to Massdriver as `MD_WORKFLOW_EXECUTOR_SERVICE_ACCOUNT_NAME`. Massdriver 2.7.0 runs Argo's init and wait containers as this account. Workflow step pods still run as `<release>-provisioner`.
- **Artifact GC service account.** `provisioner.artifactGC.serviceAccountName` sets the service account Argo's artifact garbage collection pods run as. It defaults to `<release>-provisioner`, which matches current behavior. The chart binds Argo's artifact GC Role to whichever account is set, and passes its name to Massdriver as `MD_WORKFLOW_ARTIFACT_GC_SERVICE_ACCOUNT_NAME`. If you set it, the account must already exist and be able to delete objects from the artifact repository.

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

- **Argo CRDs are installed by a hook Job.** The Argo chart no longer renders its CRDs. A pre-upgrade hook Job installs them with the `quay.io/argoproj/argo-workflows-crdinstaller` image, so the cluster must be able to pull it. If the image can't be pulled, the hook fails and the upgrade stops. Existing CRDs are annotated `helm.sh/resource-policy: keep`, so Helm leaves them, and your workflows, in place.
- **Full CRD schemas.** The installed CRDs validate workflows against Argo's full schema. To keep the smaller CRDs and skip the install Job, set `argo-workflows.crds.full: false`.
- **Existing service accounts.** If you set `massdriver.serviceAccount.create: false`, create a `<release>-workflow-executor` ServiceAccount yourself, along with a `kubernetes.io/service-account-token` Secret named `<release>-workflow-executor.service-account-token`.
- **RBAC change.** Argo's workflow RoleBinding now includes the workflow executor account as well as the provisioner account. Argo's artifact GC RoleBinding is bound to `provisioner.artifactGC.serviceAccountName`, which is the provisioner account by default, so it's unchanged unless you set it.
- **Audit log data migration.** Massdriver 2.7.0 renames keys in stored audit log rows in batches during the upgrade. If you read audit log data directly, expect `actor` and `entity` in place of `context` and `resource`.
