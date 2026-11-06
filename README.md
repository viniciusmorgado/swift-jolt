# SwiftJolt (early development)

Swift bindings for [Jolt Physics](https://github.com/jrouwe/JoltPhysics) 5.6: including rigid bodies, a character controller, wheeled and tracked vehicles and motorcycles, ragdolls, soft bodies, constraints and contact events, built for deterministic simulation. Underneath are raw bindings to the joltc C wrapper. Everything runs headless and is tested without a window.

## Status

This package is in early development. Only engine initialization is currently exposed; the Swift API surface is still being built out on top of the `CJolt`/`joltc` bridge.

## Layout

- `Sources/Jolt` — the public Swift API.
- `Vendor/joltc` — a C wrapper around Jolt Physics, exposed to Swift as the `CJolt` target.
- `Vendor/JoltPhysics` — the vendored upstream Jolt Physics C++ engine.

## Requirements

- Swift tools version 6.4
- macOS 12+ or iOS 15+

## Installation

Add SwiftJolt as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "<repository-url>", branch: "main")
]
```

Then add `Jolt` to your target's dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["Jolt"]
)
```

## Usage

```swift
import Jolt

guard Jolt.initialize() else {
    fatalError("Failed to initialize Jolt Physics")
}
```

## Testing

```sh
swift test
```
