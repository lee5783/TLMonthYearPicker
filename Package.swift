// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TLMonthYearPicker",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TLMonthYearPicker",
            targets: ["TLMonthYearPicker"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(name: "TLMonthYearPicker",
                path: "Classes",
                linkerSettings: [
                    .linkedFramework("UIKit", .when(platforms: [.iOS]))
                ]
        )
    ]
)
