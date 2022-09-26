// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pjproject-ios",
    platforms: [.iOS(.v10), .macOS(.v10_11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "pjproject-ios",
            targets: ["pjproject-ios"])
    ],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
	],
    targets: [
        .binaryTarget(
            name: "pjproject-ios",
            url: "https://git.nfon.net/users/denis.ramic/repos/pjsipdistribute/raw/download/2.12.1.1/libpjproject.xcframework.zip",
            checksum: "8e41279534b9cd7efa2a9a791d896961254c19ca91311804327e4dbaa5341a44"
        ),
    ]
)
