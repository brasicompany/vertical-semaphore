# Contributing

VerticalSemaphore is intentionally small. Contributions should preserve that:
one focused SwiftUI control, predictable behavior, and no heavy dependencies.

## Local checks

Run these before opening a pull request:

```sh
swift build
swift test
```

## Pull requests

- Keep changes scoped to the control, style API, window chrome helper, docs, or examples.
- Include a short explanation of the UI behavior being changed.
- Add or update tests for public configuration changes.
- Avoid broad visual redesigns unless they are exposed as opt-in style configuration.

## Design rules

- Preserve Apple's familiar red/yellow/green traffic-light order: close, minimize, zoom.
- Keep tab usage compact and window usage comfortable for pointer interaction.
- Keep macOS-native behavior behind `#if os(macOS)`.
- Do not add app-specific BRACOPED dependencies to this package.
