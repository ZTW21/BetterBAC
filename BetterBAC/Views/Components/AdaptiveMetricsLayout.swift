import SwiftUI

/// Measures the cards' natural text widths before offering a four-card row.
struct AdaptiveMetricsLayout: Layout {
    var allowsFourColumns: Bool
    var accessibilitySize: Bool
    var layoutDirection: LayoutDirection = .leftToRight
    var spacing: CGFloat = 10

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = max(0, proposal.width ?? AppLayout.readableWidth)
        let frames = frames(width: width, subviews: subviews)
        return CGSize(width: width, height: frames.map(\.maxY).max() ?? 0)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        for (index, frame) in frames(width: bounds.width, subviews: subviews).enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + (layoutDirection == .rightToLeft ? bounds.width - frame.maxX : frame.minX), y: bounds.minY + frame.minY),
                                  anchor: .topLeading, proposal: ProposedViewSize(frame.size))
        }
    }

    private func frames(width: CGFloat, subviews: Subviews) -> [CGRect] {
        let naturalWidth = subviews.map { $0.sizeThatFits(.unspecified).width }.max() ?? 0
        let fitsFour = allowsFourColumns && width >= naturalWidth * 4 + spacing * 3
        let columns = accessibilitySize ? 1 : (fitsFour ? 4 : 2)
        let cardWidth = max(0, (width - spacing * CGFloat(columns - 1)) / CGFloat(columns))
        var frames = Array(repeating: CGRect.zero, count: subviews.count)
        var y: CGFloat = 0
        for start in stride(from: 0, to: subviews.count, by: columns) {
            let indices = start..<min(start + columns, subviews.count)
            let height = indices.map {
                subviews[$0].sizeThatFits(ProposedViewSize(width: cardWidth, height: nil)).height
            }.max() ?? 0
            for index in indices {
                frames[index] = CGRect(x: CGFloat(index - start) * (cardWidth + spacing), y: y,
                                       width: cardWidth, height: height)
            }
            y += height + spacing
        }
        return frames
    }
}
