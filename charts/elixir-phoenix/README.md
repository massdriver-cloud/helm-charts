# Elixir/Phoenix Starter Helm Chart

A getting started helm chart for running a Phoenix web application.

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

**job :: database migration**

Database migrations are run alongside your deployment and _should_ be backwards compatible since both versions of your application (old & new) may be running at the same time.

**service :: epmd**

A headless service for networking elixir nodes via epmd.

## Entrypoint

An `entrypoint.sh` is expected in your container image:

```shell
#!/bin/sh
set -e
exec "$@"
```
