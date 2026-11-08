# Massdriver Chart 0.3.1

**Massdriver:** 2.6.0 · **UI:** 2.1.7

A patch release that grants the Massdriver Role permission to create Secrets. Massdriver and UI versions are unchanged.

## Platform

- **Massdriver can create Secrets.** The Massdriver Role now includes `create` on `secrets`. Massdriver uses it to store each deployment's sensitive inputs in a Secret owned by the deployment's workflow, so Kubernetes deletes the Secret along with the workflow.

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

- **RBAC change.** The Massdriver Role gains `create` on `secrets` in the release namespace. Subchart versions and all values are unchanged.
