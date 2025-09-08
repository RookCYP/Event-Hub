// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EventHub",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "EventHub",
            targets: ["EventHub"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "EventHub",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCore", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")
            ]),
        .testTarget(
            name: "EventHubTests",
            dependencies: ["EventHub"]),
    ]
)
