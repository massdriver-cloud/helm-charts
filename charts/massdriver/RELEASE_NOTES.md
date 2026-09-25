# Massdriver Chart 0.2.5

**Massdriver:** 2.5.3 · **UI:** 2.1.4

This release fixes installs that use the bundled MinIO object storage. MinIO no longer publishes public container images, so the chart's MinIO pods and bucket setup job could not pull their images. That broke new installs, and existing installs whenever a MinIO pod was rescheduled to a node without the image cached. It also updates Massdriver to 2.5.3, which lets you configure the provisioner logger image, and the UI to 2.1.4, which can show external resources on the environment graph.

## Platform

- **MinIO images now come from `massdrivercloud/minio`.** The chart's MinIO server and its bucket and user setup jobs use `massdrivercloud/minio:RELEASE.2026-09-22T19-25-18Z`. It mirrors `cgr.dev/chainguard/minio`, which Chainguard builds from [its maintained fork of MinIO](https://github.com/chainguard-forks/minio): upstream MinIO's final open-source release, plus security fixes and dependency updates. It is published for `linux/amd64` and `linux/arm64`, and replaces the `quay.io/minio/minio` and `quay.io/minio/mc` images, which can no longer be pulled.
- **Use cloud object storage for production installations.** The bundled MinIO makes it easy to get started. For production, we recommend Amazon S3, Azure Blob Storage, or Google Cloud Storage, which offer higher durability, richer configuration options, and easier data browsing. To move an existing installation off MinIO, follow [Using Cloud Storage for Massdriver](https://docs.massdriver.cloud/platform-operations/self-hosted/cloud-storage). It covers copying your existing data and pointing Argo Workflows at the new storage.

## Massdriver 2.5.3

### Added

- **The provisioner logger image is configurable.** Each deployment step runs a logger sidecar that streams the step's logs to Massdriver. Set `provisioner.loggerImage` to use your own image, for example from a private registry mirror. It defaults to `massdrivercloud/provisioner-logger:latest`, which is the image used before this release.

## UI 2.1.4

### Added

- **See external resources on the environment graph.** A new toggle in the graph controls draws remote references and environment defaults as nodes, with a line to every instance that uses them. Previously you had to open each instance's Dependencies tab to see what an environment pulls in. The extra data loads only when the toggle is on.

### Changed

- **Help tooltips are consistent.** Term help across the UI now uses one tooltip style, with shorter glossary definitions that link to the docs. Code in tooltips is readable in light mode.

### Maintenance

- Dependency updates.

## How to upgrade

Upgrade when no deployments are running (see the upgrade notes below). Then follow the [standard update steps](https://docs.massdriver.cloud/platform-operations/self-hosted/install#updating-your-installation):

```bash
helm repo update
helm upgrade massdriver massdriver/massdriver \
  -n massdriver \
  -f values-custom.yaml
```

No changes to `values-custom.yaml` are required.

- **Pass your values file with `-f`. Don't use `--reuse-values`.** With `--reuse-values`, Helm keeps the previous chart version's defaults, so the release would keep the old MinIO images that can no longer be pulled, and the old Massdriver and UI versions.
- **Installing from a clone of this repository?** Run `helm dependency update` once after pulling this release, then run `helm upgrade` against your local chart directory. `helm dependency build` will fail with `the lock file (Chart.lock) is out of sync with the dependencies file (Chart.yaml)` until you do. This is expected, because the MinIO subchart is now included in the repository.

## Upgrade notes

- **Existing MinIO data is kept, and no migration is needed.** The new MinIO server reuses your existing persistent volumes and reads the data already on them. Deployment logs, bundles, and OpenTofu/Terraform state are preserved.
- **Upgrade when no deployments are running.** The MinIO pods restart one at a time. With the default two replicas, writes pause briefly while each pod restarts, and reads keep working throughout.
- **If you already override `minio.image` or `minio.mcImage`, your override still applies.** The images you set are used instead of the new defaults. Make sure the image you point to can still be pulled.
- **Installs that use external object storage are not affected.** If you set `minio.enabled: false` and use S3, GCS, or Azure Blob Storage, nothing changes for you.
- **Don't use `helm rollback` to return to chart 0.2.4 or earlier.** Those versions reference the MinIO images that can no longer be pulled, and `helm rollback` reuses the old release's values. If you need to go back, run `helm upgrade --version <old version>` and set `minio.image` and `minio.mcImage` to `massdrivercloud/minio:RELEASE.2026-09-22T19-25-18Z`.
- **New optional value: `provisioner.loggerImage`.** The default matches the image already in use, so no action is required.
- The Argo Workflows version, RBAC, and all other values are unchanged.
