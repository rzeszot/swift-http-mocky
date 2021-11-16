// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "URLSessionMock",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(name: "URLSessionMock", targets: ["URLSessionMock"])
  ],
  targets: [
    .target(name: "URLSessionMock"),
    .testTarget(name: "URLSessionMockTests", dependencies: ["URLSessionMock"])
  ]
)
