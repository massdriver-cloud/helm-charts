# Massdriver Chart 0.2.0

**Massdriver:** 2.4.0 · **UI:** 2.0.13

## Massdriver 2.4.0

### Changed

- **The Launch Control service has been removed.** Massdriver now builds and submits provisioning workflows to Argo Workflows directly. This removes one deployment, service, and service account from your cluster and eliminates an internal network hop from the deployment path. No configuration changes are required — the chart handles the removal automatically on upgrade.

### Upgrade notes

- The `launchControl` values block is no longer used and can be deleted from your values overrides.
- The Massdriver service account now holds the Argo Workflows RBAC permissions previously granted to Launch Control.
- The bundled Argo Workflows dependency has been updated from 0.45.14 to 0.47.5.

## UI 2.0.13

### Added

- **Project search.** The projects list now has a search box for quickly finding projects by name.
- **Filter projects by attributes.** The projects list can now be filtered by the attributes assigned to each project.

### Maintenance

- Dependency updates.
