# Massdriver Helm Charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/massdriver)](https://artifacthub.io/packages/search?repo=massdriver)

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```shell
helm repo add massdriver https://massdriver-cloud.github.io/helm-charts
```

You can then run `helm search repo massdriver` to see the charts.

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
massdriver` to see the charts.

To install the <chart-name> chart:

```shell
helm install my-<chart-name> massdriver/<chart-name>
```

To uninstall the chart:

```shell
helm delete my-<chart-name>
```

## ArtifactHub

A `gh-pages` branch is managed for publishing helm charts to ArtifactHub.

## Releasing the massdriver chart

Merging a `version:` bump in `charts/massdriver/Chart.yaml` to `main` triggers
chart-releaser, which tags the release and publishes a GitHub Release using
`charts/massdriver/RELEASE_NOTES.md` as the body.

One-time setup (per clone) to auto-generate the notes on commit:

```shell
git config core.hooksPath .githooks
```

With that in place, committing a chart version bump runs `claude "/release-notes"`,
which diffs the old and new image tags against the sibling `massdriver` and
`massdriver-ui` checkouts and regenerates `RELEASE_NOTES.md` for the new version.
Review the generated notes in the PR — they publish verbatim on merge. To draft
them manually, run `claude "/release-notes"` yourself; to skip the hook, commit
with `--no-verify`.
