// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "Mocky",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(name: "Mocky", targets: ["Mocky"])
  ],
  targets: [
    .target(name: "Mocky"),
    .testTarget(name: "MockyTests", dependencies: ["Mocky"], resources: [
      .copy("Responses")
    ])
  ]
)
