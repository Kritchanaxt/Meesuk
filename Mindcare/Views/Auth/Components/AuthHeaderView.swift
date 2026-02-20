import SwiftUI

struct AuthHeaderView: View {
    var showBackButton: Bool = false
    var onBackAction: (() -> Void)? = nil

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                // Background Watercolor Image
                Image("Background-Page3")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea()

                // Back Button
                if showBackButton {
                    Button(action: {
                        onBackAction?()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.55))
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.top, 44)  // Account for safe area
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    AuthHeaderView(showBackButton: true)
        .frame(height: 300)
}
