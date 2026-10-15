import SwiftUI

/// Keeps the same children alive while moving from a stack to equal-width columns.
/// An optional footer sits between the columns in a stack and below them when expanded.
struct AdaptiveColumnsLayout: Layout {
    var expanded: Bool
    var footerIndex: Int? = nil
    var layoutDirection: LayoutDirection = .leftToRight
    var spacing: CGFloat = AppLayout.sectionSpacing

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = max(0, proposal.width ?? AppLayout.readableWidth)
        let frames = frames(width: width, subviews: subviews)
        return CGSize(width: width, height: frames.map(\.maxY).max() ?? 0)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let frames = frames(width: bounds.width, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            let frame = frames[index]
            subview.place(at: CGPoint(x: bounds.minX + (layoutDirection == .rightToLeft ? bounds.width - frame.maxX : frame.minX), y: bounds.minY + frame.minY),
                          anchor: .topLeading, proposal: ProposedViewSize(frame.size))
        }
    }

    private func frames(width: CGFloat, subviews: Subviews) -> [CGRect] {
        var frames = Array(repeating: CGRect.zero, count: subviews.count)
        let columns = subviews.indices.filter { $0 != footerIndex }
        guard expanded, columns.count == 2 else {
            var y: CGFloat = 0
            for index in subviews.indices {
                let height = subviews[index].sizeThatFits(ProposedViewSize(width: width, height: nil)).height
                frames[index] = CGRect(x: 0, y: y, width: width, height: height)
                if height > 0 { y += height + spacing }
            }
            return frames
        }

        let columnWidth = max(0, (width - spacing) / 2)
        for (column, index) in columns.enumerated() {
            let height = subviews[index].sizeThatFits(ProposedViewSize(width: columnWidth, height: nil)).height
            frames[index] = CGRect(x: CGFloat(column) * (columnWidth + spacing), y: 0,
                                   width: columnWidth, height: height)
        }
        if let footerIndex, subviews.indices.contains(footerIndex) {
            let height = subviews[footerIndex].sizeThatFits(ProposedViewSize(width: width, height: nil)).height
            let bottom = frames.map(\.maxY).max() ?? 0
            frames[footerIndex] = CGRect(x: 0, y: height > 0 ? bottom + spacing : bottom,
                                         width: width, height: height)
        }
        return frames
    }
}
