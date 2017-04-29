import PackageDescription

let package = Package(
    name: "RequestSession",
    dependencies: [
      .Package(url: "https://github.com/neonichu/Requests", majorVersion: 0)
    ]
)
