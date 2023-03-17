# Ruby on Rails Starter Helm Chart

A getting started helm chart for running a ruby-on-rails application.

## Kubernetes Resources

This chart runs creates a number of Kubernetes resources:

**deployment**

This runs your application and controls the rollout strategy on deployment.

**horizontal pod autoscaler**

Controls horizontal scaling of your application based on resource requirements.

**service & ingress**

Exposes application over network and configures load balancer traffic ingress.

**secret**

All environment variables are mounted as a secret

**serviceaccount**

A Kubernetes service account for your application.

**database migration job**

Database migrations are run alongside your deployment and _should_ be backwards compatible since both versions of your application (old & new) may be running at the same time.

## Sponsor

Massdriver charts can be installed as both normal Helm Charts or as Apps on [Massdriver Cloud](https://massdriver.cloud).

For more information about running your app on AKS, EKS, and GKE, please check the [docs](https://docs.massdriver.cloud/applications).

This chart is not maintained by the upstream project and any issues with the chart should be raised [on our issues page](https://github.com/massdriver-cloud/helm-charts/issues).

Massdriver is the easiest way for platform engineering teams to enable self-service with governance and guardrails for Ruby on Rails applications.

All Rights Reserved - Massdriver, Inc.
