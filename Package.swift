// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    //
    name: "MHCoreData",
    
    //
    platforms: [
        .iOS(.v13)
    ],
    
    //
    products: [
        .library(name: "MHCoreData", targets: ["MHCoreData"]),
    ],
    
    dependencies: [
        //
    ],
    
    targets: [
        //
        .target(name: "MHCoreData", dependencies: []),
    ]
)
