# Massdriver Chart 0.4.1

**Massdriver:** 2.7.0 · **UI:** 2.1.8

A patch release that adds values for database connections and background work, and passes `postgres.port` to Massdriver. Massdriver and UI versions are unchanged.

## Platform

- **`postgres.port` is passed to Massdriver.** The chart now sets `POSTGRES_PORT` from `postgres.port`. Before, the value was not used, and Massdriver always connected on port 5432.
- **Database connection settings.** New optional values under `postgres` set the connection pool and query limits. They are empty by default. When a value is empty, the chart does not set its environment variable, and Massdriver uses its own default.

  | Value | Massdriver default | What it controls |
  |---|---|---|
  | `postgres.poolSize` | `20` | Database connections each Massdriver pod holds open. |
  | `postgres.queueTargetMs` | `50` | Target wait, in milliseconds, for a free connection. |
  | `postgres.queueIntervalMs` | `2000` | How long waits can stay above the target before the pool drops requests. |
  | `postgres.timeoutMs` | `15000` | How long one query can run, in milliseconds. |
  | `postgres.prepare` | `named` | Set to `unnamed` for PgBouncer or RDS Proxy in transaction pooling mode. |

  `poolSize` × `massdriver.replicaCount`, plus a few connections for the migration job, must stay below the database's `max_connections`.
- **Database certificate verification.** Set `postgres.ssl.verify: true` to verify the database server's certificate and hostname. Set `postgres.ssl.caCert` to a PEM CA certificate to verify against. The chart stores it in a ConfigMap and mounts it into the Massdriver pods and the migration job. Without `caCert`, the system CA bundle is used. TLS stays on in all cases.
- **Background work per pod.** New optional values under `massdriver.concurrency` set how many jobs of each type a Massdriver pod runs at the same time. Massdriver's defaults are `environmentDeploys` 10, `eventDeliveries` 10, `integrationRuns` 3, and `deploymentLogCompaction` 5. Each running job uses a database connection, so lower these on a small database.
- **Values in `massdriver.additionalEnvs` take priority.** If you already set one of these environment variables in `massdriver.additionalEnvs`, the chart does not set it again, and your value is used.
- **`massdriver.extraEnv`.** A list of Kubernetes-format environment variables, including `valueFrom`, added to the Massdriver container and the migration job.

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
- **Massdriver support.** Massdriver 2.7.0 reads `postgres.poolSize` only. The other new values take effect with the Massdriver release that reads them.
