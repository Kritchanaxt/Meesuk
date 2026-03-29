import SwiftUI

struct PsychiatristDashboardView: View {
    @StateObject private var viewModel = PsychiatristDashboardViewModel()
    @EnvironmentObject var authService: AuthService
    @State private var showPatientMood = false
    @State private var selectedAppointmentForAccept: Appointment?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {

                // MARK: - Header
                HStack(spacing: 15) {
                    Image("Dr")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .background(Color(red: 0.98, green: 0.92, blue: 0.75))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text("สวัสดีตอนเช้า")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text(authService.currentUser?.name ?? "Dr. Aris Thorne, MD")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))
                    }

                    Spacer()

                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 45, height: 45)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        Image(systemName: "bell")
                            .font(.system(size: 18))
                            .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))

                        if !viewModel.pendingQueue.isEmpty {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 10, height: 10)
                                .offset(x: 12, y: -12)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                // MARK: - Stats Cards
                HStack(spacing: 16) {
                    StatCard(
                        title: "รอรับคิว",
                        value: "\(viewModel.pendingQueue.count)",
                        trend: "+\(viewModel.pendingQueue.count)",
                        icon: "person.2.fill",
                        trendColor: viewModel.pendingQueue.isEmpty ? .gray : .orange
                    )
                    StatCard(
                        title: "วันนี้",
                        value: "\(viewModel.confirmedToday.count)",
                        trend: "นัดหมาย",
                        icon: "calendar.badge.clock",
                        trendColor: .blue
                    )
                }
                .padding(.horizontal, 20)

                // MARK: - Pending Queue Section
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("คิวรอรับ")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))
                        Spacer()
                        Button(action: {
                            Task { await viewModel.loadQueue() }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 16))
                                .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
                        }
                    }
                    .padding(.horizontal, 20)

                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding()
                            Spacer()
                        }
                    } else if viewModel.pendingQueue.isEmpty {
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Image(systemName: "checkmark.circle")
                                    .font(.system(size: 36))
                                    .foregroundColor(.green.opacity(0.6))
                                Text("ไม่มีคิวรอรับ")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            Spacer()
                        }
                    } else {
                        VStack(spacing: 12) {
                            ForEach(viewModel.pendingQueue) { appt in
                                QueueCard(appointment: appt) {
                                    // Accept button tapped
                                    Task { await viewModel.acceptAppointment(id: appt.id) }
                                } onViewMood: {
                                    Task {
                                        await viewModel.loadPatientMoodHistory(userId: appt.patientId)
                                        showPatientMood = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }

                // MARK: - Today's Confirmed Sessions
                if !viewModel.confirmedToday.isEmpty {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("นัดหมายวันนี้")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))
                            .padding(.horizontal, 20)

                        VStack(spacing: 12) {
                            ForEach(viewModel.confirmedToday) { appt in
                                ConfirmedSessionCard(appointment: appt) {
                                    Task {
                                        await viewModel.loadPatientMoodHistory(userId: appt.patientId)
                                        showPatientMood = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }

                // MARK: - Error Alert
                if let error = viewModel.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text(error)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    .padding(12)
                    .background(Color.orange.opacity(0.08))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                }

                // MARK: - Success Banner
                if let success = viewModel.successMessage {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(success)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    .padding(12)
                    .background(Color.green.opacity(0.08))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                }

                Spacer().frame(height: 100)
            }
            .padding(.vertical, 20)
        }
        .background(Color(red: 1.0, green: 0.97, blue: 0.88).ignoresSafeArea())
        .onAppear {
            Task { await viewModel.loadQueue() }
        }
        .sheet(isPresented: $showPatientMood) {
            PatientMoodHistoryView(
                moodEntries: viewModel.patientMoodHistory,
                isLoading: viewModel.isLoadingMoodHistory
            )
        }
    }
}

// MARK: - Queue Card

struct QueueCard: View {
    let appointment: Appointment
    let onAccept: () -> Void
    let onViewMood: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 14) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35).opacity(0.4))

                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.patientName ?? "ผู้ป่วย")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))

                    Text(appointment.scheduledAt.formatted(.dateTime.day().month().hour().minute()))
                        .font(.system(size: 13))
                        .foregroundColor(.gray)

                    Text(appointment.type.displayName)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(red: 0.93, green: 0.45, blue: 0.35))
                        .cornerRadius(8)
                }

                Spacer()
            }

            HStack(spacing: 10) {
                Button(action: onViewMood) {
                    Label("ดู Mood", systemImage: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(Color(red: 1.0, green: 0.92, blue: 0.88))
                        .cornerRadius(14)
                }

                Button(action: onAccept) {
                    Label("รับคิว", systemImage: "checkmark.circle.fill")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(Color(red: 0.93, green: 0.45, blue: 0.35))
                        .cornerRadius(14)
                }
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(red: 1.0, green: 0.95, blue: 0.88))
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 3)
        )
    }
}

// MARK: - Confirmed Session Card

struct ConfirmedSessionCard: View {
    let appointment: Appointment
    let onViewMood: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.green.opacity(0.4))

            VStack(alignment: .leading, spacing: 4) {
                Text(appointment.patientName ?? "ผู้ป่วย")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))
                Text(appointment.scheduledAt.formatted(.dateTime.hour().minute()) + " — \(appointment.duration) นาที")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: onViewMood) {
                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 18))
                    .foregroundColor(Color(red: 0.93, green: 0.45, blue: 0.35))
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
        )
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let trend: String
    let icon: String
    let trendColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.black.opacity(0.7))
                Spacer()
                Text(trend)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(trendColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(trendColor.opacity(0.1))
                    .cornerRadius(10)
            }
            Text(title)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.05))
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(Color(red: 1.0, green: 0.95, blue: 0.88))
                .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    PsychiatristDashboardView()
        .environmentObject(AuthService.shared)
}
