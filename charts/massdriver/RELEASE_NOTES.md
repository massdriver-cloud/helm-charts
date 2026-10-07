# Massdriver Chart 0.2.7

**Massdriver:** 2.5.5 · **UI:** 2.1.6

A patch release that updates Massdriver to 2.5.5 and the UI to 2.1.6. There are no chart configuration changes.

## Massdriver 2.5.5

### Changed

- **Seats follow your identity provider for SCIM users.** A user provisioned through SCIM holds a seat while they are active in your identity provider. Their seat no longer depends on group membership. Deactivating a user releases their seat and keeps their group memberships, so reactivating them restores their access.
- **Choose which SCIM users get a seat.** If your identity provider marks licensed users with an attribute, such as an Entra ID app role, set a seat attribute and value on the SCIM integration. Only active users whose attribute matches get a seat.
- **SCIM sync is never refused at the seat limit.** When the organization is full, new users wait for a seat and get one, longest-waiting first, as soon as a seat is released or the seat limit goes up.
- **Access requires a seat.** A member without a seat keeps their group memberships but has no access until they get one. Service accounts and deployments don't use seats. The organization owner always holds a seat.
- **Invitations no longer hold a seat.** You can send an invitation at any time. When the organization is full, accepting it fails with a message to contact the organization owner, the invitation stays pending, and the owner is notified.
- **Integration settings can be changed in place.** Update an integration's configuration without deleting and recreating it.

### Fixed

- **Changing a custom attribute no longer blocks updates to existing projects, environments, components, and bundles.** An update checks only the attributes it sets, so removing an allowed value no longer prevents renaming entities that still carry it.
- **Custom attribute changes that would break a policy, a grant, or the naming convention are refused.** The error names what to change first.

## UI 2.1.6

### Added

- **Seat and source on the Members tab.** A Holds Seat column shows which members hold a seat, and a source column shows whether each member was added in Massdriver or by SCIM.
- **Edit, enable, and disable integrations.** Each connected integration has a menu with Details, Edit, and Delete, next to a switch that enables or disables it after you confirm.
- **More config actions on every instance.** The Config options menu now stays available after the first deploy. You can load config from a past deployment or from JSON, copy from or promote to another environment, compare with another environment, copy params as JSON, and discard unsaved changes. When a load drops or keeps fields that don't fit the current bundle version, a banner lists them.
- **Glossary help across the app.** Section headers, dialogs, and the Type columns on repositories and resources show help for platform terms.

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

- **No one loses access on upgrade.** A database migration gives a seat to everyone who has access before the upgrade: the organization owner, members of a group, and active SCIM users. This applies even if the organization is over its seat limit. New users wait until a seat is free.
- No values changes are required. Only the Massdriver and UI images move. The chart's dependencies, templates, and RBAC are unchanged from 0.2.6.
