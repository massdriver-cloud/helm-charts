# Massdriver Chart 0.2.3

**Massdriver:** 2.5.1 · **UI:** 2.1.2

A patch release: the UI image moves forward, no chart configuration changes.

## UI 2.1.2

### Added

- **Grant access is visible on the environment default and remote reference pickers.** Both pickers listed every resource you can see, with no hint of which ones the environment is actually allowed to use, so picking one was trial and error. Each row now carries a grant-access badge, remote reference rows flag resources in the same environment (the API rejects those), and every row links out to the resource.
- **Copy buttons on version tooltips.** Hovering a truncated dev version showed the full build tag but left you retyping the timestamp to use it in the CLI or a config. Version tooltips now include a copy button, and the deployment details dialog shows the untruncated version.

### Fixed

- **A failed environment default swap no longer leaves the environment without a default.** When replacing a default, if setting the new one failed, the previous default is restored, and the resource you picked stays selected instead of jumping back to the restored default — where a second click would have removed the default that was just recovered.

### Maintenance

- Dependency updates, including a Next.js 16 upgrade in the UI build.

### Upgrade notes

- No values changes are required. Only the UI image moves; the Massdriver application image, the chart's dependencies, templates, and RBAC are unchanged from 0.2.2.
