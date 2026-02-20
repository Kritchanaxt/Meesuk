import SwiftUI

struct MindcareTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))

            HStack {
                if isSecure && !isPasswordVisible {
                    SecureField(
                        "", text: $text,
                        prompt: Text(placeholder).foregroundColor(.gray.opacity(0.6)))
                } else {
                    TextField(
                        "", text: $text,
                        prompt: Text(placeholder).foregroundColor(.gray.opacity(0.6)))
                }

                if isSecure {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(red: 0.96, green: 0.9, blue: 0.77))  // Light beige
            .cornerRadius(12)
        }
    }
}

#Preview {
    VStack {
        MindcareTextField(
            label: "Mobile Number", placeholder: "Your Phone Number", text: .constant(""))
        MindcareTextField(
            label: "Password", placeholder: "**********", text: .constant(""), isSecure: true)
    }
    .padding()
}
