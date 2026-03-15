import SwiftUI

struct QuestionnaireView: View {
    @ObservedObject var viewModel: PsychiatristViewModel
    @State private var currentStep = 1
    @Environment(\.dismiss) var dismiss
    var onFinished: () -> Void

    private let totalSteps = 5

    // UI Helpers
    var titleText: String {
        switch currentStep {
        case 1: return "What brings you here today?"
        case 2: return "How Intense Does This Feel Right Now?"
        case 3: return "What Kind Of Support Feels Right For You?"
        case 4: return "How do you prefer to communicate?"
        case 5: return "What is your preferred budget range?"
        default: return ""
        }
    }

    var subtitleText: String {
        switch currentStep {
        case 1: return "Select the primary concerns you want help with."
        case 2: return "How much does this affect your daily life?"
        case 3: return "Everyone connects differently. What feels best for you?"
        case 4: return "Choose the format that makes you feel most comfortable."
        case 5: return "We will match based on your financial flexibility."
        default: return ""
        }
    }

    var body: some View {
        ZStack {
            Color.mindHexColor("FFF8E7")  // Warm background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        if currentStep > 1 {
                            currentStep -= 1
                        } else {
                            dismiss()
                        }
                    }) {
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
                        // Question Header
                        VStack(alignment: .leading, spacing: 10) {
                            Text(titleText)
                                .font(.custom("Outfit-Bold", size: 20))
                                .foregroundColor(Color.mindHexColor("4A3422"))

                            Text(subtitleText)
                                .font(.custom("Outfit-Regular", size: 14))
                                .foregroundColor(Color.mindHexColor("7C6A5B"))
                        }

                        // Options Data Render
                        VStack(spacing: 15) {
                            renderStepOptions()
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
                                    "Selecting accurate areas helps our algorithm map your needs to psychiatrists who specialize in those clinical areas."
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
                            guard !viewModel.isMatching else { return }

                            if currentStep < totalSteps {
                                currentStep += 1
                            } else {
                                // Execute Matching
                                viewModel.performMatch {
                                    onFinished()
                                }
                            }
                        }) {
                            HStack {
                                Spacer()
                                if viewModel.isMatching {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text(currentStep < totalSteps ? "Continue" : "Find My Match")
                                        .font(.custom("Outfit-Bold", size: 16))
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .bold))
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 20)
                            .background(Color.mindHexColor("E67E22"))
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

    @ViewBuilder
    private func renderStepOptions() -> some View {
        switch currentStep {
        case 1:
            // Step 1: Problem Type (Multi-select)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(ProblemType.allCases, id: \.self) { problem in
                    ChoiceOptionButton(
                        title: problem.rawValue,
                        isSelected: viewModel.selectedProblems.contains(problem)
                    ) {
                        if viewModel.selectedProblems.contains(problem) {
                            viewModel.selectedProblems.remove(problem)
                        } else {
                            viewModel.selectedProblems.insert(problem)
                        }
                    }
                }
            }

        case 2:
            // Step 2: Intensity (Single select)
            ForEach(IntensityLevel.allCases, id: \.self) { level in
                ChoiceOptionButton(
                    title: level.rawValue,
                    isSelected: viewModel.selectedIntensity == level
                ) {
                    viewModel.selectedIntensity = level
                }
            }

        case 3:
            // Step 3: Style (Multi-select)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(TherapyStylePreference.allCases, id: \.self) { style in
                    ChoiceOptionButton(
                        title: style.rawValue,
                        isSelected: viewModel.selectedStyles.contains(style)
                    ) {
                        if viewModel.selectedStyles.contains(style) {
                            viewModel.selectedStyles.remove(style)
                        } else {
                            viewModel.selectedStyles.insert(style)
                        }
                    }
                }
            }

        case 4:
            // Step 4: Communication (Single Select)
            ForEach(CommunicationPreference.allCases, id: \.self) { comm in
                ChoiceOptionButton(
                    title: comm.rawValue,
                    isSelected: viewModel.selectedCommunication == comm
                ) {
                    viewModel.selectedCommunication = comm
                }
            }

        case 5:
            // Step 5: Budget (Single Select)
            ForEach(BudgetPreference.allCases, id: \.self) { budget in
                ChoiceOptionButton(
                    title: budget.rawValue,
                    isSelected: viewModel.selectedBudget == budget
                ) {
                    viewModel.selectedBudget = budget
                }
            }

        default:
            EmptyView()
        }
    }
}

struct ChoiceOptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(Color.mindHexColor("4A3422"))
                    .multilineTextAlignment(.leading)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.mindHexColor("27AE60"))
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .frame(minHeight: 56)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.mindHexColor(isSelected ? "C4FBCA" : "FDF1E5"))
            )
            // Fix layout bug causing multi-select to squish
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
