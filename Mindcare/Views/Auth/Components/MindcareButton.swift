import SwiftUI

struct MindcareButton: View {
    let title: String
    let action: () -> Void
    var backgroundColor: Color = Color(red: 1.0, green: 0.8, blue: 0.44)  // Orange/Yellow
    var textColor: Color = Color(red: 0.2, green: 0.1, blue: 0.05)
    var isLoading: Bool = false

    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .padding(.trailing, 8)
                }

                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(textColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(backgroundColor)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    MindcareButton(title: "Login", action: {})
        .padding()
}
