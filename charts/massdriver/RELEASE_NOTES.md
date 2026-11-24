# Massdriver Chart 0.4.1

**Massdriver:** 2.7.0 · **UI:** 2.1.8

A patch release that passes `postgres.port` to Massdriver and adds values for the database connection pool and background work. Massdriver and UI versions are unchanged.

## Platform

- **`postgres.port` is passed to Massdriver.** The chart now sets `POSTGRES_PORT` from `postgres.port`. Before, the value was not used, and Massdriver always connected on port 5432.
- **Connection pool size.** The optional `postgres.poolSize` value sets how many database connections each Massdriver pod holds open. When it is empty, Massdriver uses 20. `poolSize` × `massdriver.replicaCount`, plus a few connections for the migration job, must stay below the database's `max_connections`.
- **Background work per pod.** Optional values under `massdriver.concurrency` set how many jobs of each type a Massdriver pod runs at the same time. When a value is empty, Massdriver uses its default: `environmentDeploys` 10, `eventDeliveries` 10, `integrationRuns` 3, and `deploymentLogCompaction` 5. Each running job uses a database connection, so lower these on a small database.
- **Values in `massdriver.additionalEnvs` take priority.** If you already set `POSTGRES_PORT`, `POSTGRES_POOL_SIZE`, or one of the concurrency variables in `massdriver.additionalEnvs`, the chart does not set it again, and your value is used.

## How to upgrade

Follow the [standard update steps](https://docs.massdriver.cloud/platform-operations/self-hosted/install#updating-your-installation):

```bash
helm repo update
helm upgrade massdriver massdriver/massdriver \
  -n massdriver \
  -f values-custom.yaml
```

No changes to `values-custom.yaml` are required. With unchanged values, the only new environment variable is `POSTGRES_PORT`, set from `postgres.port`.

## Upgrade notes

- **Port.** If `postgres.port` in your values is not 5432, Massdriver will connect on that port. Make sure it is the correct port for your database.
- **Massdriver support.** Massdriver 2.7.0 reads `POSTGRES_POOL_SIZE` but not `POSTGRES_PORT` or the concurrency variables. Those take effect with the Massdriver release that reads them.
