import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: UserViewModel
    @Environment(\.dismiss) var dismiss

    @State private var tempName: String = ""
    @State private var tempEmail: String = ""
    @State private var tempLocation: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.mindHexColor("FFF8E7")
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 25) {
                        // Avatar Section (Static for now)
                        VStack(spacing: 12) {
                            Image(viewModel.userProfile?.avatar ?? "Profile")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.mindHexColor("E67E22"), lineWidth: 2)
                                )

                            Text("Change Photo")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(Color.mindHexColor("E67E22"))
                        }
                        .padding(.top, 20)

                        // Form fields
                        VStack(alignment: .leading, spacing: 20) {
                            ProfileEditField(label: "Full Name", text: $tempName)
                            ProfileEditField(label: "Email", text: $tempEmail)
                            ProfileEditField(label: "Location", text: $tempLocation)
                        }
                        .padding(.horizontal, 20)

                        Spacer()
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.mindHexColor("4A3422"))
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.updateProfile(
                            newName: tempName,
                            newEmail: tempEmail,
                            newLocation: tempLocation
                        )
                        dismiss()
                    }
                    .font(.custom("Outfit-Bold", size: 16))
                    .foregroundColor(Color.mindHexColor("E67E22"))
                }
            }
            .onAppear {
                // Pre-populate fields
                tempName = viewModel.name
                tempEmail = viewModel.email
                tempLocation = viewModel.location
            }
        }
    }
}

struct ProfileEditField: View {
    let label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.custom("Outfit-Medium", size: 14))
                .foregroundColor(Color.mindHexColor("7C6A5B"))

            TextField("", text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .font(.custom("Outfit-Regular", size: 16))
                .foregroundColor(Color.mindHexColor("4A3422"))
        }
    }
}

#Preview {
    EditProfileView(viewModel: UserViewModel())
}
