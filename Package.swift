// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "CryptoKitten",
    products: [
        .library(
            name: "CryptoKitten",
            targets: ["CryptoKitten"])
    ],
    targets: [
      .target(
        name: "CryptoKitten", dependencies: []
      )
    ]
)
