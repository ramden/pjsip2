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
            url: "https://github.com/ramden/pjsip2/raw/master/download/2.12.1.1/libpjproject.xcframework.zip",
            checksum: "d0da78b7a262deea6d86dcd1b8f415eee0804bcd61e7c83c9f6c5c3109754b33"
        ),
    ]
)
