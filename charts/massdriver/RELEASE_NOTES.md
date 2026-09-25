# Massdriver Chart 0.2.5

**Massdriver:** 2.5.3 · **UI:** 2.1.3

This release fixes installs that use the bundled MinIO object storage. MinIO no longer publishes public container images, so the chart's MinIO pods and bucket setup job could not pull their images. That broke new installs, and existing installs whenever a MinIO pod was rescheduled to a node without the image cached. It also updates Massdriver to 2.5.3, which lets you configure the provisioner logger image.

## Platform

- **MinIO images now come from `massdrivercloud/minio`.** The chart's MinIO server and its bucket and user setup jobs use `massdrivercloud/minio:RELEASE.2026-09-22T19-25-18Z`. It mirrors `cgr.dev/chainguard/minio`, which Chainguard builds from [its maintained fork of MinIO](https://github.com/chainguard-forks/minio): upstream MinIO's final open-source release, plus security fixes and dependency updates. It is published for `linux/amd64` and `linux/arm64`, and replaces the `quay.io/minio/minio` and `quay.io/minio/mc` images, which can no longer be pulled.

## Massdriver 2.5.3

### Added

- **The provisioner logger image is configurable.** Each deployment step runs a logger sidecar that streams the step's logs to Massdriver. Set `provisioner.loggerImage` to use your own image, for example from a private registry mirror. It defaults to `massdrivercloud/provisioner-logger:latest`, which is the image used before this release.

## Upgrade notes

- **Existing MinIO data is kept, and no migration is needed.** The new MinIO server reuses your existing persistent volumes and reads the data already on them. Deployment logs, bundles, and OpenTofu/Terraform state are preserved. We tested the upgrade in place and a rollback to the previous MinIO release against the chart's default two-replica layout.
- **Upgrade when no deployments are running.** The MinIO pods restart one at a time. With the default two replicas, writes are unavailable for a short time while each pod restarts, so a deployment writing state during the rollout could fail. Reads keep working during the rollout.
- **If you already override `minio.image` or `minio.mcImage`, your override still applies.** The images you set are used instead of the new defaults. Make sure the image you point to can still be pulled.
- **Installs that use external object storage are not affected.** If you set `minio.enabled: false` and use S3, GCS, or Azure Blob Storage, nothing changes for you.
- **Don't use `helm rollback` to return to chart 0.2.4 or earlier.** Those versions reference the MinIO images that can no longer be pulled, and `helm rollback` reuses the old release's values. If you need to go back, run `helm upgrade --version <old version>` and set `minio.image` and `minio.mcImage` to `massdrivercloud/minio:RELEASE.2026-09-22T19-25-18Z`.
- **New optional value: `provisioner.loggerImage`.** The default matches the image already in use, so no action is required.
- The UI and Argo Workflows versions, RBAC, and all other values are unchanged.
