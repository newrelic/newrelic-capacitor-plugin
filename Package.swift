// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NewrelicNewrelicCapacitorPlugin",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "NewrelicNewrelicCapacitorPlugin",
            targets: ["NewrelicNewrelicCapacitorPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main"),
        .package(url: "https://github.com/newrelic/newrelic-ios-agent-spm.git", from: "7.6.0")
    ],
    targets: [
        .target(
            name: "NewrelicNewrelicCapacitorPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "CapacitorCordova", package: "capacitor-swift-pm"),
                .product(name: "NewRelic", package: "newrelic-ios-agent-spm")
            ],
            path: "ios/Plugin"
        )
    ]
)
