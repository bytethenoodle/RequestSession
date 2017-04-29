import PackageDescription

let package = Package(
    name: "RequestSession",
    dependencies: [
      .Package(url: "https://github.com/bytethenoodle/Requests", "0.1.4")
    ]
)
