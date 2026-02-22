import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.mindHexColor("FFF8E7")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.mindHexColor("4A3422"))
                            .font(.title3)
                    }

                    Spacer()

                    Text("Profile")
                        .font(.custom("Outfit-Bold", size: 20))
                        .foregroundColor(Color.mindHexColor("4A3422"))

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                ScrollView {
                    VStack(spacing: 25) {
                        // Profile Info
                        VStack(spacing: 12) {
                            Image("Profile")  // Asset: Session2/Page5_Profile/Profile
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())

                            VStack(spacing: 4) {
                                Text("Elena Rodriguez")
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
                                Text("Chonburi, Thailand")
                                    .font(.custom("Outfit-Medium", size: 14))
                                    .foregroundColor(Color.mindHexColor("E67E22"))
                            }
                        }
                        .padding(.top, 10)

                        // Mental Health Journey
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

                        // Dedicated Doctor
                        VStack(alignment: .leading, spacing: 15) {
                            Text("My Dedicated Doctor")
                                .font(.custom("Outfit-Bold", size: 18))
                                .foregroundColor(Color.mindHexColor("4A3422"))

                            HStack(spacing: 15) {
                                Image("Dr")  // Asset: Session2/Page5_Profile/Dr
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Dr. Aris Thorne, MD")
                                        .font(.custom("Outfit-Bold", size: 16))
                                        .foregroundColor(Color.mindHexColor("4A3422"))

                                    Text("Psychiatrist, M.D.")
                                        .font(.custom("Outfit-Regular", size: 12))
                                        .foregroundColor(Color.mindHexColor("7C6A5B"))

                                    HStack(spacing: 4) {
                                        Circle().fill(Color.green).frame(width: 6, height: 6)
                                        Text("ONLINE").font(.custom("Outfit-Bold", size: 10))
                                            .foregroundColor(.green)
                                    }
                                }

                                Spacer()

                                Image("chat")  // Asset: Session2/Page5_Profile/chat
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                            .padding(15)
                            .background(Color.mindHexColor("FDF1E5"))
                            .cornerRadius(20)
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(25)
                        .padding(.horizontal, 20)

                        // Settings List
                        VStack(spacing: 15) {
                            ProfileListRow(
                                icon: "Subcription", title: "Subcription Plan",
                                subtitle: "Premium Monthly • Renew Oct 12")
                            ProfileListRow(
                                icon: "Emergency", title: "Emergency Contacts",
                                subtitle: "2 contacts assigned")
                            ProfileListRow(
                                icon: "Setting", title: "App Settings",
                                subtitle: "2 contacts assigned")  // Based on screenshot
                        }
                        .padding(.horizontal, 20)

                        // Sign Out
                        Button(action: {}) {
                            HStack {
                                Image("signout")  // Asset: Session2/Page5_Profile/signout
                                    .resizable()
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
    }
}

struct ProfileListRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 15) {
            Image(icon)
                .resizable()
                .frame(width: 40, height: 40)

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
