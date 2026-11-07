// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// These must stay identical for JoltPhysics and CJolt: they change the layout of
// Jolt's types, and the library is compiled separately from the wrapper.
let joltDefines: [CXXSetting] = [
    .define("JPH_OBJECT_LAYER_BITS", to: "32"),
    // joltc declares the debug renderer API unconditionally, so it stays on in every configuration.
    .define("JPH_DEBUG_RENDERER"),
    .define("JPH_PROFILE_ENABLED", .when(configuration: .debug)),
    // SwiftPM does not define NDEBUG in release builds, which would leave JPH_DEBUG on.
    .define("NDEBUG", .when(configuration: .release)),
    .define("JPH_DOUBLE_PRECISION")
]

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    .enableUpcomingFeature("InferIsolatedConformances"),
    .enableUpcomingFeature("MemberImportVisibility"),
]

let package = Package(
    name: "swift-jolt",
    platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .visionOS(.v2)],
    products: [.library(name: "Jolt", targets: ["Jolt"])],
    targets: [
        .target( name: "JoltPhysics"
               , path: "Vendor/JoltPhysics"
               , sources: ["Jolt"]
               , publicHeadersPath: "."
               , cxxSettings: joltDefines ),
        .target( name: "CJoltImpl"
               , dependencies: ["JoltPhysics"]
               , path: "Vendor/joltc"
               , sources: ["src/joltc.cpp", "src/joltc_assert.cpp", "src/joltc.c"]
               , publicHeadersPath: "src"
               , cSettings: [.headerSearchPath("include")]
               , cxxSettings: joltDefines + [.headerSearchPath("include")]),
        .target( name: "CJolt", dependencies: ["CJoltImpl"]),
        .target( name: "Jolt", dependencies: ["CJolt"], swiftSettings: swiftSettings ),
        .testTarget(
            name: "JoltTests",
            dependencies: ["Jolt", "CJolt"],
            swiftSettings: swiftSettings,
        ),
    ],
    cxxLanguageStandard: .cxx17
)
