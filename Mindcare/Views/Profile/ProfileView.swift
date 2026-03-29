import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = UserViewModel()
    // Injecting the shared psychiatrist VM if possible, or using a new one for demo
    // Ideally this should be shared at the App level or Parent level
    @StateObject var psychiatristVM = PsychiatristViewModel()
    @State private var showEditProfile = false
    @State private var showSignOutAlert = false
    var body: some View {
        ZStack {
            Color.mindHexColor("FFF8E7")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Color.clear.frame(width: 30, height: 30)

                    Spacer()

                    Text("Profile")
                        .font(.custom("Outfit-Bold", size: 20))
                        .foregroundColor(Color.mindHexColor("4A3422"))

                    Spacer()

                    Button(action: { showEditProfile = true }) {
                        Text("Edit")
                            .font(.custom("Outfit-Medium", size: 16))
                            .foregroundColor(Color.mindHexColor("E67E22"))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                ScrollView {
                    VStack(spacing: 25) {
                        // Profile Info
                        VStack(spacing: 12) {
                            Image(viewModel.userProfile?.avatar ?? "Profile")  // Asset: Session2/Page5_Profile/Profile
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())

                            VStack(spacing: 4) {
                                Text(viewModel.name)
                                    .font(.custom("Outfit-Bold", size: 22))
                                    .foregroundColor(Color.mindHexColor("4A3422"))

                                Text("Member since January 2026")
                                    .font(.custom("Outfit-Regular", size: 14))
                                    .foregroundColor(Color.mindHexColor("7C6A5B"))
                            }

                            HStack(spacing: 6) {
                                Image("Location")  // Asset: Session2/Page5_Profile/Location
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text(viewModel.location)
                                    .font(.custom("Outfit-Medium", size: 14))
                                    .foregroundColor(Color.mindHexColor("E67E22"))
                            }
                        }
                        .padding(.top, 10)

                        // Mental Health Journey (Temporarily removed, waiting for AI generate)
                        /*
                        VStack(alignment: .leading, spacing: 15) {
                            Text("My Mental Health Jorney")
                                .font(.custom("Outfit-Bold", size: 18))
                                .foregroundColor(Color.mindHexColor("4A3422"))

                            Image("Graph_Optional")  // Asset: Session2/Page5_Profile/Graph_Optional
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .cornerRadius(20)
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(25)
                        .padding(.horizontal, 20)
                        */

                        // Dedicated Doctor
                        VStack(alignment: .leading, spacing: 15) {
                            Text("My Dedicated Doctor")
                                .font(.custom("Outfit-Bold", size: 18))
                                .foregroundColor(Color.mindHexColor("4A3422"))

                            if let doctor = psychiatristVM.selectedDoctor {
                                HStack(spacing: 15) {
                                    Image(doctor.avatar ?? "Dr")  // Asset: Session2/Page5_Profile/Dr
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(doctor.name)
                                            .font(.custom("Outfit-Bold", size: 16))
                                            .foregroundColor(Color.mindHexColor("4A3422"))

                                        Text(doctor.specialization)
                                            .font(.custom("Outfit-Regular", size: 12))
                                            .foregroundColor(Color.mindHexColor("7C6A5B"))

                                        HStack(spacing: 4) {
                                            Circle().fill(Color.green).frame(width: 6, height: 6)
                                            Text("ONLINE").font(.custom("Outfit-Bold", size: 10))
                                                .foregroundColor(.green)
                                        }
                                    }

                                    Spacer()

                                    Image(systemName: "bubble.left.and.bubble.right.fill")
                                        .foregroundColor(Color.mindHexColor("E67E22"))
                                        .font(.title2)
                                }
                                .padding(15)
                                .background(Color.mindHexColor("FDF1E5"))
                                .cornerRadius(20)
                            } else {
                                Text("No doctor matched yet")
                                    .font(.custom("Outfit-Medium", size: 14))
                                    .foregroundColor(Color.mindHexColor("7C6A5B"))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 20)
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(25)
                        .padding(.horizontal, 20)

                        // Settings List (use systemName)
                        VStack(spacing: 15) {
                            ProfileListRow(
                                systemIconName: "star.circle.fill",
                                title: "Subcription Plan",
                                subtitle: "Premium Monthly • Renew Oct 12"
                            )
                            ProfileListRow(
                                systemIconName: "light.beacon.max.fill",
                                title: "Emergency Contacts",
                                subtitle: "2 contacts assigned"
                            )
                            ProfileListRow(
                                systemIconName: "bell.fill",
                                title: "App Settings",
                                subtitle: "2 contacts assigned"
                            )
                        }
                        .padding(.horizontal, 20)

                        // Sign Out
                        Button(action: { showSignOutAlert = true }) {
                            HStack {
                                Image(systemName: "iphone.and.arrow.right.outward")
                                    .foregroundColor(Color.mindHexColor("EB6538"))
                                    .font(.title3)
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                Text("Sign Out")
                                    .font(.custom("Outfit-Bold", size: 16))
                            }
                            .foregroundColor(Color.mindHexColor("E67E22"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.mindHexColor("E67E22"), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchProfile()
            }
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileView(viewModel: viewModel)
        }
        .alert("Sign Out", isPresented: $showSignOutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Sign Out", role: .destructive) {
                viewModel.signOut()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

struct ProfileListRow: View {
    // SF Symbol name
    let systemIconName: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: systemIconName)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(Color.mindHexColor("E67E22"))
                .padding(9)
                .background(Color.mindHexColor("FDF1E5"))
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Outfit-Bold", size: 16))
                    .foregroundColor(Color.mindHexColor("4A3422"))

                Text(subtitle)
                    .font(.custom("Outfit-Regular", size: 12))
                    .foregroundColor(Color.mindHexColor("7C6A5B"))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(Color.mindHexColor("E67E22"))
                .font(.system(size: 14, weight: .bold))
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(20)
    }
}

#Preview {
    ProfileView()
}
