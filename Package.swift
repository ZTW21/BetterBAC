// swift-tools-version: 6.0
import PackageDescription

// Tests compile the same core files used by the iOS application.
let package = Package(
    name: "ClearSipCore",
    platforms: [.macOS(.v13)],
    products: [.library(name: "ClearSipCore", targets: ["ClearSipCore"])],
    targets: [
        .target(name: "ClearSipCore", path: "BetterBAC", exclude: [
            "Assets.xcassets", "BetterBACApp.swift", "Info.plist", "Managers", "Preview Content", "Views",
            "ViewModels/ProfileViewModel.swift", "Utilities/AppTheme.swift", "PrivacyInfo.xcprivacy"
        ], sources: [
            "Models", "Utilities/SessionMetricsCalculator.swift", "Utilities/PersistenceManager.swift",
            "ViewModels/SessionViewModel.swift"
        ]),
        .testTarget(name: "ClearSipCoreTests", dependencies: ["ClearSipCore"], path: "Tests")
    ],
    swiftLanguageModes: [.v5]
)
