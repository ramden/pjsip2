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
            url: "https://github.com/ramden/pjsip2/blob/f97e5d6fed321ccd3f8eb2fee1980f33d7cc7467/download/2.12.1.1/libpjproject.xcframework.zip",
            checksum: "7850773a7d7ca830618c486535a65f35efb09919ab54c07567ab5a02d68dd3fe"
        ),
    ]
)
