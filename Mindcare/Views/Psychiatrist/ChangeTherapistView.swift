import SwiftUI

struct ChangeTherapistView: View {
    let currentAppointmentId: String
    @Environment(\.dismiss) private var dismiss

    @State private var psychiatrists: [Psychiatrist] = []
    @State private var isLoading = true
    @State private var selectedPsychiatrist: Psychiatrist?
    @State private var isChanging = false
    @State private var errorMessage: String?
    @State private var showConfirm = false
    @State private var isSuccess = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 1.0, green: 0.97, blue: 0.88).ignoresSafeArea()

                if isLoading {
                    VStack(spacing: 16) {
                        ProgressView().scaleEffect(1.4)
                        Text("กำลังโหลดรายชื่อหมอ...")
                            .font(.system(size: 14)).foregroundColor(.gray)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 14) {
                            if let error = errorMessage {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.orange)
                                    Text(error)
                                        .font(.system(size: 13))
                                }
                                .padding(12)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }

                            if isSuccess {
                                VStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 48))
                                        .foregroundColor(.green)
                                    Text("เปลี่ยนหมอสำเร็จ!")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .padding(.top, 40)
                            } else {
                                Text("เลือกหมอใหม่")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                ForEach(psychiatrists) { doctor in
                                    DoctorSelectionCard(
                                        doctor: doctor,
                                        isSelected: selectedPsychiatrist?.id == doctor.id
                                    ) {
                                        selectedPsychiatrist = doctor
                                    }
                                    .padding(.horizontal)
                                }

                                if let selected = selectedPsychiatrist {
                                    Button(action: { showConfirm = true }) {
                                        HStack {
                                            if isChanging {
                                                ProgressView()
                                                    .tint(.white)
                                                    .padding(.trailing, 4)
                                            }
                                            Text("ยืนยันเปลี่ยนเป็น \(selected.name)")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(Color(red: 0.93, green: 0.45, blue: 0.35))
                                        .cornerRadius(20)
                                    }
                                    .padding(.horizontal)
                                    .disabled(isChanging)
                                }
                            }
                        }
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("เปลี่ยนจิตแพทย์")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("ยกเลิก") { dismiss() }
                        .foregroundColor(.gray)
                }
            }
            .confirmationDialog(
                "ยืนยันการเปลี่ยนหมอ?",
                isPresented: $showConfirm,
                titleVisibility: .visible
            ) {
                Button("ยืนยัน", role: .destructive) {
                    Task { await changeTherapist() }
                }
                Button("ยกเลิก", role: .cancel) {}
            } message: {
                Text("คุณต้องการเปลี่ยนไปหา \(selectedPsychiatrist?.name ?? "")?")
            }
        }
        .onAppear { Task { await loadPsychiatrists() } }
    }

    private func loadPsychiatrists() async {
        isLoading = true
        do {
            psychiatrists = try await APIService.shared.getPsychiatrists()
        } catch {
            errorMessage = "โหลดรายชื่อหมอไม่สำเร็จ"
        }
        isLoading = false
    }

    private func changeTherapist() async {
        guard let selected = selectedPsychiatrist else { return }
        isChanging = true
        errorMessage = nil
        do {
            _ = try await APIService.shared.changeTherapist(
                appointmentId: currentAppointmentId,
                newPsychiatristId: selected.id
            )
            isSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { dismiss() }
        } catch {
            errorMessage = "เปลี่ยนหมอไม่สำเร็จ: \(error.localizedDescription)"
        }
        isChanging = false
    }
}

// MARK: - Doctor Selection Card

struct DoctorSelectionCard: View {
    let doctor: Psychiatrist
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 52, height: 52)
                    .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35).opacity(0.4))

                VStack(alignment: .leading, spacing: 4) {
                    Text(doctor.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))
                    Text(doctor.specialization)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    if let rating = doctor.rating {
                        HStack(spacing: 3) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", rating))
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? Color(red: 1.0, green: 0.92, blue: 0.88) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(isSelected ? Color(red: 0.93, green: 0.45, blue: 0.35) : Color.clear, lineWidth: 1.5)
                    )
                    .shadow(color: .black.opacity(0.04), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
