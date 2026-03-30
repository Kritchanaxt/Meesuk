import SwiftUI

struct DoctorCredentialsView: View {
    @Environment(\.dismiss) var dismiss
    let doctor: Psychiatrist
    
    var body: some View {
        ZStack {
            Color.mindHexColor("FFF8E7")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()
                    Text("Doctor Credentials")
                        .font(.custom("Outfit-Bold", size: 18))
                        .foregroundColor(Color.mindHexColor("4A3422"))
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color.mindHexColor("9A8B7F"))
                    }
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        // Profile Summary
                        VStack(spacing: 15) {
                            Image("Dr_img") // Asset: Session2/Page3_Match/Dr_img
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                            
                            VStack(spacing: 4) {
                                Text(doctor.name)
                                    .font(.custom("Outfit-Bold", size: 22))
                                    .foregroundColor(Color.mindHexColor("4A3422"))
                                
                                Text(doctor.specialization)
                                    .font(.custom("Outfit-Medium", size: 16))
                                    .foregroundColor(Color.mindHexColor("3498DB"))
                            }
                        }
                        .padding(.top, 10)
                        
                        // Education Section
                        CredentialSection(
                            title: "EDUCATION",
                            icon: "graduationcap.fill",
                            items: [
                                CredentialItem(
                                    title: "Doctor of Medicine (M.D.)",
                                    subtitle: "Chulalongkorn University, Faculty of Medicine",
                                    detail: "Graduated with First Class Honors"
                                ),
                                CredentialItem(
                                    title: "Master of Science in Clinical Psychology",
                                    subtitle: "Harvard Medical School",
                                    detail: "Specialized in Cognitive Behavioral Therapy"
                                )
                            ]
                        )
                        
                        // Board Certifications
                        CredentialSection(
                            title: "BOARD CERTIFICATIONS",
                            icon: "checkmark.seal.fill",
                            items: [
                                CredentialItem(
                                    title: "Dip. Thai Board of Psychiatry",
                                    subtitle: "The Psychiatric Association of Thailand",
                                    detail: "Active License #TH-PSY-2012-0044"
                                ),
                                CredentialItem(
                                    title: "International Board Certified in Sleep Medicine",
                                    subtitle: "World Sleep Society",
                                    detail: "Certified in Insomnia & Sleep Disorders"
                                )
                            ]
                        )
                        
                        // Professional Experience
                        CredentialSection(
                            title: "PROFESSIONAL EXPERIENCE",
                            icon: "briefcase.fill",
                            items: [
                                CredentialItem(
                                    title: "Senior Consultant Psychiatrist",
                                    subtitle: "Mindcare Wellness Center",
                                    detail: "2018 - Present"
                                ),
                                CredentialItem(
                                    title: "Clinical Researcher",
                                    subtitle: "Digital Health Research Lab",
                                    detail: "Focus on AI-Driven Mental Support"
                                )
                            ]
                        )
                    }
                    .padding(25)
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct CredentialSection: View {
    let title: String
    let icon: String
    let items: [CredentialItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(Color.mindHexColor("E67E22"))
                    .font(.headline)
                
                Text(title)
                    .font(.custom("Outfit-Bold", size: 14))
                    .foregroundColor(Color.mindHexColor("4A3422"))
                    .kerning(1.2)
            }
            
            VStack(spacing: 20) {
                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.custom("Outfit-Bold", size: 16))
                            .foregroundColor(Color.mindHexColor("4A3422"))
                        
                        Text(item.subtitle)
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(Color.mindHexColor("7C6A5B"))
                        
                        Text(item.detail)
                            .font(.custom("Outfit-Regular", size: 12))
                            .foregroundColor(Color.mindHexColor("9A8B7F"))
                            .italic()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if item.id != items.last?.id {
                        Divider().background(Color.mindHexColor("E6D5C3").opacity(0.3))
                    }
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 5)
        }
    }
}

struct CredentialItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let detail: String
}

#Preview {
    DoctorCredentialsView(doctor: Psychiatrist(
        id: "1", name: "Dr. Julian Vance", avatar: "Dr_img", specialization: "Clinical Psychiatrist", bio: nil, rating: 5, reviewCount: 120, yearsOfExperience: 12, languages: ["English", "Thai"], isAvailable: true
    ))
}
