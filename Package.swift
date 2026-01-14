// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NewrelicNewrelicCapacitorPlugin",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "NewrelicNewrelicCapacitorPlugin",
            targets: ["NewrelicNewrelicCapacitorPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0"),
        .package(url: "https://github.com/newrelic/newrelic-ios-agent-spm.git", from: "7.6.0")
    ],
    targets: [
        .target(
            name: "NewrelicNewrelicCapacitorPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "NewRelic", package: "newrelic-ios-agent-spm")
            ],
            path: "ios/Plugin",
            exclude: [
                "Info.plist",
                "NewRelicCapacitorPluginPlugin.m",
                "NewRelicCapacitorPluginPlugin.h",
                "Public"
            ],
            sources: [
                "NewRelicCapacitorPlugin.swift",
                "NewRelicCapacitorPluginPlugin.swift"
            ]
        )
    ]
)
