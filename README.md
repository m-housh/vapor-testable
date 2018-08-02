# VaporTestable

Adds helpers for testing Vapor3 applications.

## Usage

### Package.swift
``` swift

// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0-rc.2"),

        // VaporTestable
        .package(url: "https://github.com/m-housh/vapor-testable.git", from:
        "0.1.0"),
       
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentSQLite", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App", "VaporTestable"])
    ]
)
```
