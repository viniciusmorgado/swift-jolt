// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let joltDefines: [CXXSetting] = [
    .define("JPH_OBJECT_LAYER_BITS", to: "32"),
    .define("JPH_DEBUG_RENDERER"),
    .define("JPH_PROFILE_ENABLED"),
]

let package = Package(
    name: "swift-jolt",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [.library(name: "Jolt", targets: ["Jolt"])],
    targets: [
        .target( name: "JoltPhysics"
               , path: "Vendor/JoltPhysics"
               , sources: ["Jolt"]
               , publicHeadersPath: "."
               , cxxSettings: joltDefines ),
        .target( name: "CJolt"
               , dependencies: ["JoltPhysics"]
               , path: "Vendor/joltc"
               , sources: ["src/joltc.cpp", "src/joltc_assert.cpp", "src/joltc.c"]
               , publicHeadersPath: "include"
               , cSettings: [.define("JPH_OBJECT_LAYER_BITS", to: "32")]
               , cxxSettings: joltDefines ),
        .target( name: "Jolt"
               , dependencies: ["CJolt"]
               , swiftSettings: [.enableUpcomingFeature("ApproachableConcurrency")]),
        .testTarget(
            name: "JoltTests",
            dependencies: ["Jolt"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ],
    cxxLanguageStandard: .cxx17
)
