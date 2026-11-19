# Massdriver Chart 0.4.0

**Massdriver:** 2.6.0 · **UI:** 2.1.7

This release updates Argo Workflows to v4.1.6 and adds a dedicated service account for Argo's executor containers. Massdriver and UI versions are unchanged.

## Platform

- **Argo Workflows v4.1.6.** The `argo-workflows` subchart moves from 0.47.5 to 2.0.18, and Argo Workflows from v3.7.11 to v4.1.6. This fixes failed workflows that never got deleted after their 24-hour TTL because the `workflows.argoproj.io/artifact-gc` finalizer was never removed. Workflows already stuck this way are released by the new controller on its own.
- **Workflow executor service account.** The chart creates a `<release>-workflow-executor` ServiceAccount and its token Secret, binds it to Argo's workflow and artifact GC Roles, and passes its name to Massdriver as `MD_WORKFLOW_EXECUTOR_SERVICE_ACCOUNT_NAME`. Massdriver 2.6.0 doesn't use it yet.

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
- **RBAC change.** Argo's workflow and artifact GC RoleBindings now include the workflow executor account as well as the provisioner account.
