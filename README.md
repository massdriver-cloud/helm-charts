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

## Contributing

A `gh-pages` branch is managed for publishing helm charts to artifact hub. This branch does not need to contain `./charts` as it is only maintained for artifact hub integration and generating the static repository.

From time to time files need to be synced (artifacthub-repo.yml, README.md, .github). Please ensure that only the necessary files are added to this branch.
