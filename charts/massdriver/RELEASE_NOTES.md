# Massdriver Chart 0.2.6

**Massdriver:** 2.5.4 · **UI:** 2.1.5

A patch release that updates Massdriver to 2.5.4 and the UI to 2.1.5. There are no chart configuration changes.

## Massdriver 2.5.4

### Changed

- **Seats are held by group members.** A seat is now held by each person in one or more of the organization's groups, and by each pending invitation. All access comes from group policies, so a member in no group can do nothing and no longer holds a seat. Removing a member from their last group frees their seat. When an identity provider adds people to a group through SCIM, they claim seats at that point, not when the provider first creates the user.

### Fixed

- **Resources can be looked up by their `<instance>.<field>` identifier in organizations with a custom naming convention.** Before, the lookup failed when the naming convention produced cloud resource names that didn't start with the instance identifier.

## UI 2.1.5

### Added

- **Seat usage on the Groups and Members tabs.** A seat meter shows how many of the organization's seats are in use, so admins can see the organization is nearly full before an invitation fails. The Billing tab shows seats used out of the total.

### Changed

- **New organizations see a "book a call" welcome dialog.** It replaces the previous welcome dialog for organizations with no projects and no repositories.

### Maintenance

- Dependency updates.

## How to upgrade

Follow the [standard update steps](https://docs.massdriver.cloud/platform-operations/self-hosted/install#updating-your-installation):

```bash
helm repo update
helm upgrade massdriver massdriver/massdriver \
  -n massdriver \
  -f values-custom.yaml
```

## Upgrade notes

- No values changes are required. Only the Massdriver and UI images move. The chart's dependencies, templates, and RBAC are unchanged from 0.2.5.
