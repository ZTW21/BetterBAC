import SwiftUI

/// Describes the space available to content, rather than identifying a device or pose.
struct AppLayout {
    let sizeClass: UserInterfaceSizeClass?
    let typeSize: DynamicTypeSize

    static let sectionSpacing: CGFloat = 20
    static let contentMargin: CGFloat = 16
    static let readableWidth: CGFloat = 680
    static let dashboardWidth: CGFloat = 1200

    var usesColumns: Bool { sizeClass == .regular && !typeSize.isAccessibilitySize }
}
