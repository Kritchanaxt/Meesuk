import SwiftUI

struct PsychiatristView: View {
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

                    DoctorCardOverview(onTapChange: { showChangeDoctor = true })

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
            QuestionnaireView(onFinished: {
                showQuestionnaire = false
                // Small delay to let sheet dismiss before showing next
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showRecommendation = true
                }
            })
        }
        .sheet(isPresented: $showChangeDoctor) {
            ChangeDoctorView()
        }
        .sheet(isPresented: $showRecommendation) {
            DoctorRecommendationView(onFinish: {
                isMatched = true
                showRecommendation = false
            })
        }
    }
}

// MARK: - Supporting Views for Psychiatrist Flow

struct QuestionnaireView: View {
    @State private var currentStep = 2
    @Environment(\.dismiss) var dismiss
    var onFinished: () -> Void

    private let totalSteps = 5

    var body: some View {
        ZStack {
            Color.mindHexColor("FFF8E7")  // Warm background
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

                    Text("Matching Questionnaire")
                        .font(.custom("Outfit-Bold", size: 20))
                        .foregroundColor(Color.mindHexColor("4A3422"))

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Progress
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Matching progress...")
                            .font(.custom("Outfit-Regular", size: 14))
                            .foregroundColor(Color.mindHexColor("7C6A5B"))

                        Spacer()

                        Text("Step \(currentStep) of \(totalSteps)")
                            .font(.custom("Outfit-Regular", size: 14))
                            .foregroundColor(Color.mindHexColor("7C6A5B"))
                    }

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.mindHexColor("E0E0E0"))
                                .frame(height: 6)

                            Capsule()
                                .fill(Color.mindHexColor("E67E22"))
                                .frame(
                                    width: geo.size.width * CGFloat(currentStep)
                                        / CGFloat(totalSteps), height: 6)
                        }
                    }
                    .frame(height: 6)
                }
                .padding(25)

                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        // Question
                        VStack(alignment: .leading, spacing: 10) {
                            Text(
                                currentStep == 2
                                    ? "How Intense Does This Feel Right Now?"
                                    : "What Kind Of Support Feels Right For You?"
                            )
                            .font(.custom("Outfit-Bold", size: 20))
                            .foregroundColor(Color.mindHexColor("4A3422"))

                            Text(
                                currentStep == 2
                                    ? "How much does this affect your daily life?"
                                    : "Everyone connects differently. What feels best for you?"
                            )
                            .font(.custom("Outfit-Regular", size: 14))
                            .foregroundColor(Color.mindHexColor("7C6A5B"))
                        }

                        // Options
                        VStack(spacing: 15) {
                            if currentStep == 2 {
                                ChoiceOptionButton(
                                    title: "Mild – I Can Manage Most Days", isSelected: true)
                                ChoiceOptionButton(
                                    title: "Moderate – It’s Starting To Interfere",
                                    isSelected: false)
                                ChoiceOptionButton(
                                    title: "High – It’s Affecting My Work Or Relationships",
                                    isSelected: false)
                                ChoiceOptionButton(
                                    title: "Very High – I Need Professional Support",
                                    isSelected: false)
                            } else {
                                LazyVGrid(
                                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                                    spacing: 15
                                ) {
                                    ChoiceOptionButton(title: "Warm & Supportive", isSelected: true)
                                    ChoiceOptionButton(
                                        title: "Calm And A Good Listener", isSelected: false)
                                    ChoiceOptionButton(
                                        title: "Structured & Goal-Oriented", isSelected: false)
                                    ChoiceOptionButton(
                                        title: "Practical With Clear Advice", isSelected: false)
                                    ChoiceOptionButton(
                                        title: "Friendly & Conversational", isSelected: false)
                                    ChoiceOptionButton(
                                        title: "Not Sure — Help Me Decide", isSelected: false)
                                }
                            }
                        }

                        // AI Recommendation Box
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "sparkles")
                                .foregroundColor(Color.mindHexColor("3498DB"))

                            VStack(alignment: .leading, spacing: 4) {
                                Text("AI Recommendation")
                                    .font(.custom("Outfit-Bold", size: 14))
                                    .foregroundColor(Color.mindHexColor("3498DB"))

                                Text(
                                    "Select specific areas helps our algorithm map your needs to psychiatrists who specialize in those clinical areas."
                                )
                                .font(.custom("Outfit-Regular", size: 12))
                                .foregroundColor(Color.mindHexColor("7C6A5B"))
                                .lineSpacing(2)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.mindHexColor("3498DB"), lineWidth: 1)
                                .background(Color.white.opacity(0.5))
                        )
                        .cornerRadius(15)

                        // Continue Button
                        Button(action: {
                            if currentStep < totalSteps {
                                currentStep += 1
                            } else {
                                onFinished()
                            }
                        }) {
                            HStack {
                                Spacer()
                                Text("Continue")
                                    .font(.custom("Outfit-Bold", size: 16))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundColor(Color.mindHexColor("E67E22"))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(Color.mindHexColor("FDF1E5"))
                            .cornerRadius(12)
                        }
                    }
                    .padding(25)
                    .background(Color.white)
                    .cornerRadius(30)
                    .padding(.horizontal, 20)
                }

                Spacer()
            }
        }
    }
}

struct ChoiceOptionButton: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.custom("Outfit-Medium", size: 14))
                .foregroundColor(Color.mindHexColor("4A3422"))

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.green)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.mindHexColor(isSelected ? "C4FBCA" : "FDF1E5"))
        )
    }
}

struct DoctorRecommendationView: View {
    @Environment(\.dismiss) var dismiss
    var onFinish: () -> Void

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
                            Text("We’ve Found Your Perfect Match")
                                .font(.custom("Outfit-Bold", size: 24))
                                .foregroundColor(Color.mindHexColor("E67E22"))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 40)

                        // Doctor Card
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
                                    Text("98% Match")
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
                                    Text("Dr. Sarah Jenkins, MD")
                                        .font(.custom("Outfit-Bold", size: 22))
                                        .foregroundColor(Color.mindHexColor("3498DB"))

                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color.mindHexColor("3498DB"))
                                }

                                Text("Psychiatrist • 12+ Years Experience")
                                    .font(.custom("Outfit-Medium", size: 14))
                                    .foregroundColor(Color.mindHexColor("3498DB"))

                                // Skills Tags
                                HStack(spacing: 10) {
                                    SkillTag(title: "CBT")
                                    SkillTag(title: "ANXIETY MANAGEMENT")
                                }
                                SkillTag(title: "ADHD SPECAILIST")
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
                                    "Dr. Jenkins specializes in adult tele-psychiatry with a focus on holistic mental wellness. She was matched with you because of your preference for evening sessions and evidence-based CBT approaches."
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

                        // Other Options
                        VStack(spacing: 8) {
                            Text("Not quite what you were looking for?")
                                .font(.custom("Outfit-Regular", size: 14))
                                .foregroundColor(Color.mindHexColor("7C6A5B"))

                            Button(action: { dismiss() }) {
                                Text("See Other Doctor Recommendations")
                                    .font(.custom("Outfit-Bold", size: 14))
                                    .foregroundColor(Color.mindHexColor("E67E22"))
                            }
                        }

                        // Action Button
                        Button(action: onFinish) {
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
                    .padding(.top, 10)
                }
            }
        }
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
    @State private var reason = ""
    @State private var anythingElse = ""
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

                                Text("Dr. Aris Thorne, MD")
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
                            Button(action: {}) {
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
    var onTapChange: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 15) {
                Image("Dr_img")  // Asset: Session2/Page3_Match/Dr_img
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text("Dr. Aris Thorne, MD")
                        .font(.custom("Outfit-Bold", size: 18))
                        .foregroundColor(Color.mindHexColor("4A3422"))

                    Text("Clinical Psychiatrist")
                        .font(.custom("Outfit-Medium", size: 14))
                        .foregroundColor(Color.mindHexColor("7C6A5B"))
                }

                Spacer()
            }

            Divider()

            Button(action: onTapChange) {
                Text("Change Doctor")
                    .font(.custom("Outfit-SemiBold", size: 14))
                    .foregroundColor(Color.mindHexColor("E67E22"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.mindHexColor("FDF1E5"))
                    .cornerRadius(10)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    PsychiatristView()
}
