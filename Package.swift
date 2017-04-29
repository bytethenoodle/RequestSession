import PackageDescription

let package = Package(
    name: "RequestSession",
    testDependencies: [
        .Package(url: "https://github.com/neonichu/spectre-build.git", majorVersion: 0),
    ],
    dependencies: [
      .Package(url: "https://github.com/neonichu/Requests", majorVersion: 0),
    ]
)
