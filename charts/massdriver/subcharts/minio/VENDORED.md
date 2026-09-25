# Vendored MinIO chart

This is an unmodified copy of the upstream MinIO Helm chart, version 5.4.0. It was unpacked from
`https://charts.min.io/helm-releases/minio-5.4.0.tgz`, whose sha256 matches the upstream index:
`25fa2740480d1ebc9e64340854a6c42d3a7bc39c2a77378da91b21f144faa9af`.

MinIO has withdrawn its community releases. Its public container images are no longer pullable
(September 2026). The chart is vendored so that packaging the Massdriver chart does not depend on
`charts.min.io` remaining available. chart-releaser runs dependency update on every release.

Don't edit these files. Override behavior from the parent chart's `values.yaml` under `minio:`.
The container images are overridden there to `massdrivercloud/minio`. That image is an unmodified
mirror of `cgr.dev/chainguard/minio`, which Chainguard builds from its maintained fork of MinIO:
upstream MinIO's final release, plus security fixes and dependency updates. MinIO is licensed under
AGPLv3. The source for the image is
https://github.com/chainguard-forks/minio/tree/RELEASE.2026-09-22T19-25-18Z
