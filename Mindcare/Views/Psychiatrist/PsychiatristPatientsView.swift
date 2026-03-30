import SwiftUI

struct PsychiatristPatientsView: View {
    @State private var searchText = ""
    
    // Mock Patients
    let patients = [
        PatientMock(name: "John Doe", lastSession: "30 Mar 2026", status: "Stable", mood: "😊"),
        PatientMock(name: "Jane Smith", lastSession: "28 Mar 2026", status: "Needs Attention", mood: "😔"),
        PatientMock(name: "Alice Cooper", lastSession: "25 Mar 2026", status: "Stable", mood: "😐"),
        PatientMock(name: "Robert Brown", lastSession: "22 Mar 2026", status: "Improving", mood: "🙂"),
        PatientMock(name: "Emily Davis", lastSession: "20 Mar 2026", status: "Stable", mood: "😃")
    ]
    
    var filteredPatients: [PatientMock] {
        if searchText.isEmpty {
            return patients
        } else {
            return patients.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 15) {
                Text("My Patients")
                    .font(.custom("Outfit-Bold", size: 28))
                    .foregroundColor(Color.mindHexColor("4A3422"))
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.mindHexColor("9A8B7F"))
                    TextField("Search patients...", text: $searchText)
                        .font(.custom("Outfit-Regular", size: 16))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal, 25)
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(filteredPatients) { patient in
                        PatientListItem(patient: patient)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 120)
            }
        }
        .background(Color.mindHexColor("FFF8E7").ignoresSafeArea())
    }
}

struct PatientListItem: View {
    let patient: PatientMock
    
    var body: some View {
        HStack(spacing: 15) {
            // Avatar Placeholder with Mood Emoji
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.mindHexColor("FDF1E5"))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text(patient.name.prefix(1))
                            .font(.custom("Outfit-Bold", size: 24))
                            .foregroundColor(Color.mindHexColor("EB6538"))
                    )
                
                Text(patient.mood)
                    .font(.system(size: 18))
                    .background(Circle().fill(Color.white).frame(width: 24, height: 24))
                    .offset(x: 2, y: 2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(patient.name)
                    .font(.custom("Outfit-Bold", size: 18))
                    .foregroundColor(Color.mindHexColor("4A3422"))
                
                HStack {
                    Text("Last Session:")
                        .font(.custom("Outfit-Regular", size: 12))
                        .foregroundColor(Color.mindHexColor("9A8B7F"))
                    Text(patient.lastSession)
                        .font(.custom("Outfit-Medium", size: 12))
                        .foregroundColor(Color.mindHexColor("4A3422"))
                }
                
                Text(patient.status)
                    .font(.custom("Outfit-Bold", size: 10))
                    .foregroundColor(patient.status == "Needs Attention" ? .red : .green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background((patient.status == "Needs Attention" ? Color.red : Color.green).opacity(0.1))
                    .cornerRadius(8)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.mindHexColor("D0C0B0"))
                    .font(.system(size: 14, weight: .bold))
            }
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.02), radius: 8, x: 0, y: 4)
    }
}

struct PatientMock: Identifiable {
    let id = UUID()
    let name: String
    let lastSession: String
    let status: String
    let mood: String
}

#Preview {
    PsychiatristPatientsView()
}
