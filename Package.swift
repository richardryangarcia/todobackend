// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "todo",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura", from: "2.8.0"),
        .package(name: "KituraOpenAPI", url: "https://github.com/IBM-Swift/Kitura-OpenAPI.git", from: "1.0.0"),
        .package(name: "KituraCORS", url: "https://github.com/IBM-Swift/Kitura-CORS.git", from: "2.1.0"),
        .package(name: "SwiftKueryORM" ,url: "https://github.com/IBM-Swift/Swift-Kuery-ORM", from: "0.4.1"),
        .package(name: "SwiftKueryPostgreSQL", url: "https://github.com/IBM-Swift/Swift-Kuery-PostgreSQL", from: "2.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "todo",
            dependencies: ["Kitura", "KituraOpenAPI", "KituraCORS", "SwiftKueryORM","SwiftKueryPostgreSQL"]),
        .testTarget(
            name: "todoTests",
            dependencies: ["todo"]),
    ]
)
