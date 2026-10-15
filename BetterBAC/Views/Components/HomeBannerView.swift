import SwiftUI

struct HomeBannerView: View {
    let isVisible: Bool

    var body: some View {
        // The SDK's standard banner is 320 points wide. Never squeeze it into a narrow column.
        GeometryReader { geometry in
            if isVisible && geometry.size.width >= 320 {
                BannerAdView()
                    .frame(width: 320, height: 50)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(height: isVisible ? 50 : 0)
    }
}
