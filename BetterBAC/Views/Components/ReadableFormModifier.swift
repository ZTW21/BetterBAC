import SwiftUI

struct ReadableFormModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: AppLayout.readableWidth)
            .frame(maxWidth: .infinity)
            .background(.background.secondary)
    }
}

extension View {
    func readableForm() -> some View { modifier(ReadableFormModifier()) }
}
