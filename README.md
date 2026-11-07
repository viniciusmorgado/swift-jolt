# SwiftJolt (early development)

Swift bindings for [Jolt Physics](https://github.com/jrouwe/JoltPhysics) 5.6: including rigid bodies, a character controller, wheeled and tracked vehicles and motorcycles, ragdolls, soft bodies, constraints and contact events, built for deterministic simulation. Underneath are raw bindings to the joltc C wrapper. Everything runs headless and is tested without a window.

## Status

This package is in early development. Only engine initialization is currently exposed; the Swift API surface is still being built out on top of the `CJolt`/`joltc` bridge.

## Determinism

A simulation replays identically when it runs on the same build of the library with the same inputs in the same order. Results are not guaranteed to match across different builds or CPU architectures, such as arm64 and x86_64.

Cross-platform determinism would require compiling with `-ffp-contract=off`, which SwiftPM only accepts through unsafe flags, and those prevent other packages from depending on this one by version.

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
    .package(url: "https://github.com/viniciusmorgado/swift-jolt", branch: "main")
]
```

Then add `Jolt` to your target's dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [.product(name: "Jolt", package: "swift-jolt")]
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

## Roadmap

The goal is to cover all of Jolt Physics 5.6. Features are ordered by how much a AAA production depends on them, from what every game needs down to what few projects use.

† Not exposed by `joltc` yet. These will be contributed upstream to `joltc` first, and the Swift API follows once they land.

### 1. Foundation

- [x] Engine initialization
- [ ] Engine shutdown and object lifetime across the FFI boundary, including reference-counted shapes and settings
- [ ] Math types: vectors, quaternions and matrices
- [ ] Custom allocators and temp allocators
- [ ] Job system: thread pool, plus custom job systems to run on an engine's own scheduler
- [ ] Single-threaded job system †
- [ ] Trace and assert handlers
- [ ] `PhysicsSystem`: setup, stepping, gravity, `PhysicsSettings` and update errors
- [ ] Collision layers: object layers and broad phase layers, with table and mask implementations

### 2. Rigid body simulation

- [ ] Bodies: creation settings, motion types, mass properties, allowed degrees of freedom, damping, gravity factor and user data
- [ ] Continuous collision detection through motion quality
- [ ] Sleeping and activation
- [ ] Sensors (trigger volumes)
- [ ] Forces, impulses, velocities and kinematic movement
- [ ] Body access: `BodyInterface`, locking and non-locking variants, single and multi-body locks
- [ ] Batch body insertion for level streaming †
- [ ] Friction and restitution, physics materials
- [ ] Custom friction and restitution combine functions †
- [ ] Convex shapes: sphere, box, capsule, tapered capsule, cylinder, tapered cylinder, triangle and convex hull
- [ ] Static geometry: mesh, height field and plane
- [ ] Compound shapes: static and mutable
- [ ] Decorated shapes: scaled, rotated/translated and offset center of mass
- [ ] Empty shape
- [ ] Sub-shape IDs and shape introspection: mass properties, volume, leaf shapes and supporting faces
- [ ] Triangle extraction from shapes †

### 3. Collision queries and events

- [ ] Ray casts
- [ ] Point and shape collision tests
- [ ] Shape casts
- [ ] Broad phase queries
- [ ] Collision collectors
- [ ] Filters: body, shape, object layer, broad phase layer, group and simulation shape filters
- [ ] Contact listener, contact manifolds and contact settings
- [ ] Body activation listener
- [ ] Physics step listener
- [ ] Ghost collision handling: active edges and enhanced internal edge removal
- [ ] Collision response estimation
- [ ] `TransformedShape` for queries outside the physics system †

### 4. Characters

- [ ] `CharacterVirtual`: movement outside the simulation step, with `ExtendedUpdate`, stair walking and stick to floor
- [ ] `Character`: rigid body character
- [ ] Character contact listener
- [ ] Character vs character collision

### 5. Constraints

- [ ] Constraint base: enabling and disabling (for breakable constraints), priorities and solver step overrides
- [ ] Motors and springs
- [ ] Fixed, point, distance, hinge and slider constraints
- [ ] Cone, swing-twist and six degrees of freedom constraints

### 6. Ragdolls and animation

- [ ] Skeletons, skeleton poses and skeletal animation
- [ ] Ragdolls: creation, stabilization and collision between parent and child joints
- [ ] Hard keying, soft keying and driving motors to an animated pose
- [ ] Skeleton mapping between animation and ragdoll skeletons
- [ ] Automatic ragdoll constraint priorities †

### 7. Vehicles

- [ ] Vehicle constraint and collision testers: ray, sphere and cylinder
- [ ] Wheeled vehicles
- [ ] Engine, transmission, differentials, anti-roll bars and `LinearCurve`
- [ ] Motorcycles
- [ ] Tracked vehicles

### 8. Production and online play

- [ ] Saving and restoring simulation state with `StateRecorder`, for rollback netcode and replays †
- [ ] State recorder filters for partial snapshots †
- [ ] Binary serialization of shapes, bodies and constraints for baked level data †
- [ ] `PhysicsScene` for saving and loading whole scenes †
- [ ] Reading creation settings back from bodies and constraints, to apply new ones or move them between physics systems †
- [ ] Multiple physics systems
- [ ] Large worlds through double precision, as an opt-in build configuration
- [ ] Level of detail through simulation shape filters
- [ ] Runtime terrain editing: changing height field heights and materials †
- [ ] Debug renderer
- [ ] Profiler †
- [ ] Simulation, broad phase and narrow phase statistics †

### 9. Secondary simulation

- [ ] Water buoyancy
- [ ] Submerged volume calculation †
- [ ] Soft bodies: creation settings, vertices, faces and generated constraints
- [ ] Soft body fine-grained constraints: edge, dihedral bend, Cosserat rod, tetrahedron volume and long range attachment †
- [ ] Soft body skinning †
- [ ] Soft body runtime access through `SoftBodyMotionProperties` and `SoftBodyShape` †
- [ ] Soft body contact listener †
- [ ] Compute system: CPU and Metal backends, which the package must also build and bundle shaders for †
- [ ] Strand-based hair simulation on the GPU †

### 10. Specialized mechanisms

- [ ] Gear constraint
- [ ] Rack and pinion constraint †
- [ ] Pulley constraint †
- [ ] Path constraint, with Hermite spline paths †
- [ ] Custom shapes, including registering their collision functions †
- [ ] Custom constraint subtypes †

### 11. Tooling and utilities

- [ ] Debug renderer recording and playback †
- [ ] `ObjectStream` text and binary serialization †
- [ ] Determinism log for debugging simulation divergence †
- [ ] Build configuration reporting †
- [ ] Geometry utilities: convex hull builder, GJK, EPA, closest point and ray intersection helpers †

### Out of scope

- **Cross-platform determinism:** see [Determinism](#determinism).
- **DX12 and Vulkan compute backends:** the package only targets Apple platforms.
- **Internals with no public API to bind:** island building, large island splitting, the quad tree broad phase, AABB tree builders, triangle splitters and codecs, SIMD selection, the RTTI factory, threading primitives and Jolt's container types. They work automatically once the features above exist.
- **Brute force broad phase:** it exists for testing Jolt itself.

## Contributing

### Project structure

Every feature is a slice with the same shape, so once you know one you know them all, and a new feature starts by copying an existing slice. New code follows this structure as features are added.

```text
Sources/Jolt/
├── Jolt.swift
├── JoltBindings.swift
├── Shared/
│   ├── Handle.swift
│   ├── Callbacks.swift
│   └── SharedBindings.swift
└── Features/
    ├── Characters/
    │   ├── Characters.swift
    │   └── CharactersBindings.swift
    └── Constraints/
        ├── Constraints.swift
        ├── Constraints+Hinge.swift
        ├── ConstraintsBindings.swift
        └── ConstraintsSupport.swift

Tests/JoltTests/
└── Features/
    └── Characters/
        └── CharactersTests.swift
```

Feature folders are plural and named after a Jolt concept (`Bodies`, `Shapes`, `Queries`), while the types inside them are singular (`Body`, `Shape`).

| File | Required | Access | Responsibility |
| --- | --- | --- | --- |
| `<Feature>.swift` | Yes | `public` | The feature's public API. Never imports `CJolt`. |
| `<Feature>Bindings.swift` | Yes | `internal` | All calls into `CJolt` and all conversions between Swift and C types. |
| `<Feature>Tests.swift` | Yes | | The feature's tests, in the matching folder under `Tests/JoltTests/Features`. |
| `<Feature>+<Topic>.swift` | No | `public` | Part of the public API, split out when `<Feature>.swift` grows too large. |
| `<Feature>Support.swift` | No | `internal` | Internal logic in pure Swift, such as validation. Never imports `CJolt`. |

### Rules

- **Only `*Bindings.swift` files import `CJolt`**, always as `internal import CJolt`. Swift checks imports per file, so any other file that tries to call C fails to compile. Public code holds C objects as `OpaquePointer`.
- **Every file name is unique.** Swift rejects two files with the same name in a module, even in different folders, which is why each file carries its feature's name.
- **Every type name is unique.** Folders don't create namespaces in Swift, so nest generic names inside their owner: `Character.Settings` and `Body.Settings`, never a top-level `Settings`.
- **No type is named `Jolt`.** A type with the module's name breaks `Jolt.Body`, the qualified form clients need when they have their own `Body`.
- **`Shared` is internal.** It holds only what several features need, such as handle ownership and callback bridging. It has no public API and never depends on a feature.
- **Everything public lives in a feature**, including math types, which live in `Features/Math`.
- **Features use each other through their public API**, never through each other's bindings. The compiler can't enforce this one, so it's checked in code review.

### Adding a feature

1. Copy an existing slice and its tests, then rename the folders and files.
2. Write the C calls and conversions in `<Feature>Bindings.swift`.
3. Write the public API in `<Feature>.swift`.
4. Add tests that run headless.
5. Check the feature off in the [Roadmap](#roadmap).

If `joltc` doesn't expose what the feature needs, contribute the missing API to [joltc](https://github.com/amerkoleci/joltc) first, then update the `Vendor/joltc` submodule.

### Public API and semantic versioning

The public API is everything declared `public`, which only appears in `Jolt.swift` and in the public files of each feature. Other projects depend on it through semantic versioning, so:

- Public signatures never expose `CJolt` types. The compiler rejects this as long as the import stays `internal`.
- Adding a `case` to a public `enum` breaks any exhaustive `switch` in client code. For sets of values that are likely to grow, use a `struct` with static constants instead.
- Removing or renaming anything public, or changing a signature, is a breaking change.
- `swift package diagnose-api-breaking-changes <tag>` compares the current API with a previous release.
