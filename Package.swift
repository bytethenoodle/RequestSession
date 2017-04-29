import PackageDescription

let package = Package(
    name: "RequestSession",
    dependencies: [
      .Package(url: "https://github.com/neonichu/Requests", "0.1.4")
    ]
)
