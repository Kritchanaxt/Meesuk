import SwiftUI

struct SocialLoginButtons: View {
    var onGoogleTap: () -> Void
    var onFacebookTap: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("or sign up with")
                .font(.system(size: 14))
                .foregroundColor(.gray)

            HStack(spacing: 20) {
                SocialButton(imageName: "Google Icon", action: onGoogleTap)
                SocialButton(imageName: "Facebook Icon", action: onFacebookTap)
            }
        }
    }
}

struct SocialButton: View {
    let imageName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 44, height: 44)
                .padding(8)
                .background(Circle().fill(Color.white))
                .overlay(
                    Circle().stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}

#Preview {
    SocialLoginButtons(onGoogleTap: {}, onFacebookTap: {})
}
