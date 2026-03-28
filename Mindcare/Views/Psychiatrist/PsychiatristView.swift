import SwiftUI

struct PsychiatristView: View {
    @State private var appointments: [Appointment] = []
    @StateObject private var viewModel = PsychiatristViewModel()
    @StateObject private var appointmentVM = AppointmentViewModel()

    @State private var showQuestionnaire = false
    @State private var showRecommendation = false
    @State private var showChangeDoctor = false
    @State private var isMatched = false  // Toggle for demo

    var body: some View {
        ZStack {
            Color.mindHexColor("FFF8E7").ignoresSafeArea()

            if isMatched {
                // Show Current Doctor / Change Option
                VStack(spacing: 20) {
                    Text("Your Personal Psychiatrist")
                        .font(.custom("Outfit-Bold", size: 24))
                        .foregroundColor(Color.mindHexColor("4A3422"))
                        .padding(.top, 40)

                    if let selectedDoc = viewModel.selectedDoctor {
                        DoctorCardOverview(
                            doctor: selectedDoc, 
                            appointmentVM: appointmentVM,
                            onTapChange: { showChangeDoctor = true })
                    } else {
                        // Default if none selected yet but we are in matched state
                        Button(action: { showQuestionnaire = true }) {
                            Text("Find Your Doctor")
                                .font(.custom("Outfit-Bold", size: 18))
                                .foregroundColor(.white)
                                .frame(width: 240, height: 60)
                                .background(Color.mindHexColor("E67E22"))
                                .cornerRadius(30)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
            } else {
                // Landing / Start Matching
                VStack(spacing: 30) {
                    Spacer()

                    Image(systemName: "person.2.badge.gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.mindHexColor("E67E22"))

                    VStack(spacing: 12) {
                        Text("Find Your Perfect Match")
                            .font(.custom("Outfit-Bold", size: 26))
                            .foregroundColor(Color.mindHexColor("4A3422"))

                        Text(
                            "Complete a quick questionnaire and let our AI matching engine find the best psychiatrist for your unique needs."
                        )
                        .font(.custom("Outfit-Regular", size: 16))
                        .foregroundColor(Color.mindHexColor("7C6A5B"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    }

                    Button(action: { showQuestionnaire = true }) {
                        Text("Start Matching")
                            .font(.custom("Outfit-Bold", size: 18))
                            .foregroundColor(.white)
                            .frame(width: 240, height: 60)
                            .background(Color.mindHexColor("E67E22"))
                            .cornerRadius(30)
                            .shadow(
                                color: Color.mindHexColor("E67E22").opacity(0.3), radius: 10, x: 0,
                                y: 5)
                    }

                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showQuestionnaire) {
            QuestionnaireView(viewModel: viewModel) {
                showQuestionnaire = false
                // Optional: You could pass the exact matched doctor to recommendation view
                // Small delay to let sheet dismiss before showing next
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showRecommendation = true
                }
            }
        }
        .sheet(isPresented: $showChangeDoctor) {
            if let currentDoc = viewModel.selectedDoctor {
                ChangeDoctorView(doctor: currentDoc) {
                    showChangeDoctor = false
                    viewModel.resetForm()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showQuestionnaire = true
                    }
                }
            }
        }
        .sheet(isPresented: $showRecommendation) {
            DoctorRecommendationView(
                doctors: viewModel.recommendedDoctors,
                onSelect: { selectedDoc in
                    viewModel.selectedDoctor = selectedDoc
                    isMatched = true
                    showRecommendation = false
                })
        }
    }
}

// Extracted Questionnaire View and ChoiceOptionButton to QuestionnaireView.swift

struct DoctorRecommendationView: View {
    let doctors: [Psychiatrist]
    var onSelect: (Psychiatrist) -> Void
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

                    Text("Your Match")
                        .font(.custom("Outfit-Bold", size: 20))
                        .foregroundColor(Color.mindHexColor("4A3422"))

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                ScrollView {
                    VStack(spacing: 25) {
                        // Success Message
                        VStack(spacing: 8) {
                            Text("We’ve Found Your Top Matches")
                                .font(.custom("Outfit-Bold", size: 24))
                                .foregroundColor(Color.mindHexColor("E67E22"))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 40)

                        // Doctor Cards Loop
                        ForEach(Array(doctors.enumerated()), id: \.element.id) { index, doctor in
                            DoctorMatchCard(
                                doctor: doctor, rank: index + 1,
                                onSelect: {
                                    onSelect(doctor)
                                })
                        }

                        // Other Options
                        VStack(spacing: 8) {
                            Text("Not quite what you were looking for?")
                                .font(.custom("Outfit-Regular", size: 14))
                                .foregroundColor(Color.mindHexColor("7C6A5B"))

                            Button(action: { dismiss() }) {
                                Text("Browse All Doctors")
                                    .font(.custom("Outfit-Bold", size: 14))
                                    .foregroundColor(Color.mindHexColor("E67E22"))
                            }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                    }
                    .padding(.top, 10)
                }
            }
        }
    }
}

struct DoctorMatchCard: View {
    let doctor: Psychiatrist
    let rank: Int
    var onSelect: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 20) {
                ZStack(alignment: .topTrailing) {
                    Image("Dr_img")  // Asset: Session2/Page3_Match/Dr_img
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(25)

                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                        Text(rank == 1 ? "Top Match" : "Great Match")
                            .font(.custom("Outfit-Bold", size: 12))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.9))
                    .foregroundColor(Color.mindHexColor("3498DB"))
                    .cornerRadius(20)
                    .padding(15)
                }

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(doctor.name)
                            .font(.custom("Outfit-Bold", size: 22))
                            .foregroundColor(Color.mindHexColor("3498DB"))

                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color.mindHexColor("3498DB"))
                    }

                    Text(
                        "\(doctor.specialization) • \(doctor.yearsOfExperience)+ Years Experience"
                    )
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(Color.mindHexColor("3498DB"))

                    // Skills Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            if let specs = doctor.specialties {
                                ForEach(specs, id: \.self) { spec in
                                    SkillTag(title: spec.uppercased())
                                }
                            }
                            if let styles = doctor.styles {
                                ForEach(styles, id: \.self) { style in
                                    SkillTag(title: style.uppercased())
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

                VStack(alignment: .leading, spacing: 15) {
                    HStack(spacing: 12) {
                        Image("Personal")  // Asset: Session2/Page3_Match/Personal
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("PERSONAL PHILOSOPHY")
                            .font(.custom("Outfit-Bold", size: 16))
                            .foregroundColor(Color.mindHexColor("4A3422"))
                    }

                    Text(
                        doctor.bio
                            ?? "An exceptionally matched professional tailored for your needs."
                    )
                    .font(.custom("Outfit-Regular", size: 14))
                    .foregroundColor(Color.mindHexColor("7C6A5B"))
                    .lineSpacing(4)
                }
                .padding(25)

                Divider()
                    .padding(.horizontal, 25)

                HStack {
                    Image("Credentrails")  // Asset: Session2/Page3_Match/Credentrails
                        .resizable()
                        .frame(width: 30, height: 30)

                    Text("View Full Credentials")
                        .font(.custom("Outfit-Bold", size: 16))
                        .foregroundColor(Color.mindHexColor("4A3422"))

                    Spacer()
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 10)
            }
            .background(Color.white)
            .cornerRadius(30)
            .padding(.horizontal, 20)

            // Action Button
            Button(action: onSelect) {
                HStack {
                    Text("Start With This Doctor")
                        .font(.custom("Outfit-Bold", size: 18))
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(Color.mindHexColor("4A3422"))
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.mindHexColor("FBC58B"))
                .cornerRadius(15)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .padding(.bottom, 15)
    }
}

struct SkillTag: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.custom("Outfit-Bold", size: 10))
            .foregroundColor(Color.mindHexColor("3498DB"))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.mindHexColor("3498DB").opacity(0.1))
            .cornerRadius(10)
    }
}

struct InfoBadgeView: View {
    let icon: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            Image(icon)  // Assets from Session2/Page3_Match
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)

            Text(label)
                .font(.custom("Outfit-Regular", size: 12))
                .foregroundColor(Color.mindHexColor("7C6A5B"))
        }
    }
}

struct ChangeDoctorView: View {
    let doctor: Psychiatrist
    @State private var reason = ""
    @State private var anythingElse = ""
    @Environment(\.dismiss) var dismiss
    var onRequestNewMatch: () -> Void

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

                    Text("Change Doctor")
                        .font(.custom("Outfit-Bold", size: 20))
                        .foregroundColor(Color.mindHexColor("4A3422"))

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        // Title
                        VStack(alignment: .leading, spacing: 10) {
                            Text("We Want You To Feel Comfortable")
                                .font(.custom("Outfit-Bold", size: 24))
                                .foregroundColor(Color.mindHexColor("4A3422"))

                            Text(
                                "Finding the right fit is essential for your progress. If you feel like a different psychiatrist might be a better match, we are here to help you find one."
                            )
                            .font(.custom("Outfit-Regular", size: 14))
                            .foregroundColor(Color.mindHexColor("7C6A5B"))
                            .lineSpacing(4)
                        }

                        // Current Provider
                        HStack(spacing: 15) {
                            Image("Dr")  // Asset: Session2/Page4_Change/Dr
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("CURRENT PROVIDER")
                                    .font(.custom("Outfit-Medium", size: 12))
                                    .foregroundColor(Color.mindHexColor("9A8B7F"))

                                Text(doctor.name)
                                    .font(.custom("Outfit-Bold", size: 16))
                                    .foregroundColor(Color.mindHexColor("4A3422"))
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.mindHexColor("FDF1E5"))
                        .cornerRadius(20)

                        // Reason Selection
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Reason For Changing")
                                .font(.custom("Outfit-Bold", size: 16))
                                .foregroundColor(Color.mindHexColor("4A3422"))

                            Menu {
                                Button(
                                    "Schedule Conflicts", action: { reason = "Schedule Conflicts" })
                                Button(
                                    "Communication Style",
                                    action: { reason = "Communication Style" })
                                Button(
                                    "Need Different Specialty",
                                    action: { reason = "Need Different Specialty" })
                                Button(
                                    "Financial Reasons", action: { reason = "Financial Reasons" })
                                Button("Other", action: { reason = "Other" })
                            } label: {
                                HStack {
                                    Text(reason.isEmpty ? "Select a reason" : reason)
                                        .foregroundColor(
                                            reason.isEmpty
                                                ? Color.mindHexColor("7C6A5B")
                                                : Color.mindHexColor("4A3422"))
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Color.mindHexColor("E67E22"))
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.mindHexColor("E6D5C3"), lineWidth: 1)
                                )
                            }
                        }

                        // Additional Info
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Anything Else We Should Know?")
                                .font(.custom("Outfit-Bold", size: 16))
                                .foregroundColor(Color.mindHexColor("4A3422"))

                            TextField(
                                "e.g., I'm looking for someone more direct, or someone who specializes in trauma recovery...",
                                text: $anythingElse, axis: .vertical
                            )
                            .lineLimit(4...6)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.mindHexColor("E6D5C3"), lineWidth: 1)
                            )
                        }

                        // Hint
                        HStack(alignment: .top, spacing: 10) {
                            Image("protect")  // Asset: Session2/Page4_Change/protect
                                .resizable()
                                .frame(width: 24, height: 24)

                            Text(
                                "Our AI matching engine will use your feedback to prioritize the best compatible experts. Your current doctor will be notified professionally."
                            )
                            .font(.custom("Outfit-Regular", size: 12))
                            .foregroundColor(Color.mindHexColor("7C6A5B"))
                            .lineSpacing(2)
                        }

                        // Action Buttons
                        VStack(spacing: 15) {
                            Button(action: {
                                dismiss()
                                onRequestNewMatch()
                            }) {
                                HStack {
                                    Image("Request")  // Asset: Session2/Page4_Change/Request
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text("Request New Match")
                                        .font(.custom("Outfit-Bold", size: 16))
                                }
                                .foregroundColor(Color.mindHexColor("4A3422"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.mindHexColor("FBC58B"))
                                .cornerRadius(12)
                            }

                            Button(action: { dismiss() }) {
                                Text("Keep Current Doctor")
                                    .font(.custom("Outfit-Medium", size: 16))
                                    .foregroundColor(Color.mindHexColor("7C6A5B"))
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding(30)
                    .background(Color.white)
                    .cornerRadius(40)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct DoctorCardOverview: View {
    let doctor: Psychiatrist
    @ObservedObject var appointmentVM: AppointmentViewModel
    var onTapChange: () -> Void

    @State private var showBookingConfirmation = false

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 15) {
                Image(doctor.avatar ?? "Dr_img")  // Asset: Session2/Page3_Match/Dr_img
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(doctor.name)
                        .font(.custom("Outfit-Bold", size: 18))
                        .foregroundColor(Color.mindHexColor("4A3422"))

                    Text(doctor.specialization)
                        .font(.custom("Outfit-Medium", size: 14))
                        .foregroundColor(Color.mindHexColor("7C6A5B"))
                }

                Spacer()
            }

            Divider()

            HStack(spacing: 15) {
                Button(action: onTapChange) {
                    Text("Change Doctor")
                        .font(.custom("Outfit-SemiBold", size: 14))
                        .foregroundColor(Color.mindHexColor("E67E22"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.mindHexColor("FDF1E5"))
                        .cornerRadius(10)
                }

                Button(action: {
                    Task {
                        // Demo booking for tomorrow
                        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
                        await appointmentVM.bookAppointment(psychiatristId: doctor.id, date: tomorrow)
                        if appointmentVM.isBookingSuccessful {
                            showBookingConfirmation = true
                        }
                    }
                }) {
                    if appointmentVM.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.mindHexColor("E67E22"))
                            .cornerRadius(10)
                    } else {
                        Text("Book Session")
                            .font(.custom("Outfit-SemiBold", size: 14))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.mindHexColor("E67E22"))
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .alert("Appointment Booked!", isPresented: $showBookingConfirmation) {
            Button("OK", role: .cancel) {
                appointmentVM.isBookingSuccessful = false
            }
        } message: {
            Text("Your session with \(doctor.name) has been scheduled.")
        }
    }
}

#Preview {
    PsychiatristView()
}
