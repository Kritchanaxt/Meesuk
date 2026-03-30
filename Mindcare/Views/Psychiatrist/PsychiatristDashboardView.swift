import SwiftUI

struct PsychiatristDashboardView: View {
    @StateObject private var viewModel = PsychiatristDashboardViewModel()
    @EnvironmentObject var authService: AuthService
    @State private var showPatientMood = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 25) {
                // MARK: - Header
                HStack(spacing: 15) {
                    Image("Dr") // Asset: Session2/Page1_Dashboard/Dr
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .background(Color.mindHexColor("FDF1E5"))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))

                    VStack(alignment: .leading, spacing: 2) {
                        Text("สวัสดีตอนเช้า")
                            .font(.custom("Outfit-Regular", size: 14))
                            .foregroundColor(Color.mindHexColor("9A8B7F"))
                        Text(authService.currentUser?.name ?? "Demo Doctor")
                            .font(.custom("Outfit-Bold", size: 22))
                            .foregroundColor(Color.mindHexColor("4A3422"))
                    }

                    Spacer()

                    Button(action: {}) {
                        ZStack(alignment: .topTrailing) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 46, height: 46)
                                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                            Image(systemName: "bell.fill")
                                .font(.system(size: 18))
                                .foregroundColor(Color.mindHexColor("EB6538"))
                                .frame(width: 46, height: 46)
                            Circle()
                                .fill(Color.red)
                                .frame(width: 9, height: 9)
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .offset(x: -2, y: 2)
                        }
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 20)

                // MARK: - Stats Cards
                HStack(spacing: 16) {
                    StatCard(
                        title: "รอรับคิว",
                        value: "\(viewModel.pendingQueue.count)",
                        trend: "+\(viewModel.pendingQueue.count)",
                        icon: "person.2.fill",
                        trendColor: Color.mindHexColor("EB6538")
                    )
                    StatCard(
                        title: "วันนี้",
                        value: "\(viewModel.confirmedToday.count)",
                        trend: "นัดหมาย",
                        icon: "calendar.badge.clock",
                        trendColor: Color.mindHexColor("3498DB")
                    )
                }
                .padding(.horizontal, 25)

                // MARK: - Pending Queue Section
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Text("คิวรอรับ")
                            .font(.custom("Outfit-Bold", size: 20))
                            .foregroundColor(Color.mindHexColor("4A3422"))
                        Spacer()
                        Button(action: {
                            Task { await viewModel.loadQueue() }
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color.mindHexColor("EB6538"))
                        }
                    }
                    .padding(.horizontal, 25)

                    if viewModel.pendingQueue.isEmpty {
                        EmptyStateView(message: "ไม่มีคิวรอรับในขณะนี้")
                    } else {
                        VStack(spacing: 15) {
                            ForEach(viewModel.pendingQueue) { appt in
                                QueueCard(appointment: appt) {
                                    Task { await viewModel.acceptAppointment(id: appt.id) }
                                } onViewMood: {
                                    Task {
                                        await viewModel.loadPatientMoodHistory(userId: appt.patientId)
                                        showPatientMood = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 25)
                    }
                }

                // MARK: - Today's Appointments
                VStack(alignment: .leading, spacing: 18) {
                    Text("นัดหมายวันนี้")
                        .font(.custom("Outfit-Bold", size: 20))
                        .foregroundColor(Color.mindHexColor("4A3422"))
                        .padding(.horizontal, 25)

                    if viewModel.confirmedToday.isEmpty {
                        EmptyStateView(message: "ไม่มีการนัดหมายวันนี้")
                    } else {
                        VStack(spacing: 15) {
                            ForEach(viewModel.confirmedToday) { appt in
                                ConfirmedSessionCard(appointment: appt) {
                                    Task {
                                        await viewModel.loadPatientMoodHistory(userId: appt.patientId)
                                        showPatientMood = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 25)
                    }
                }

                Spacer().frame(height: 120)
            }
        }
        .background(Color.mindHexColor("FFF8E7").ignoresSafeArea())
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

// MARK: - Subviews

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
                    .foregroundColor(Color.mindHexColor("4A3422").opacity(0.7))
                Spacer()
                Text(trend)
                    .font(.custom("Outfit-Bold", size: 10))
                    .foregroundColor(trendColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(trendColor.opacity(0.12))
                    .cornerRadius(8)
            }
            Text(title)
                .font(.custom("Outfit-Regular", size: 12))
                .foregroundColor(Color.mindHexColor("9A8B7F"))
            Text(value)
                .font(.custom("Outfit-Bold", size: 32))
                .foregroundColor(Color.mindHexColor("4A3422"))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.mindHexColor("FDF6EC"))
        .cornerRadius(28)
        .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 5)
    }
}

struct QueueCard: View {
    let appointment: Appointment
    let onAccept: () -> Void
    let onViewMood: () -> Void

    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 15) {
                Image(systemName: "person.circle.fill") // Replace with patient avatar if available
                    .resizable()
                    .frame(width: 54, height: 54)
                    .foregroundColor(Color.mindHexColor("E67E22").opacity(0.3))

                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.patientName ?? "John Doe")
                        .font(.custom("Outfit-Bold", size: 18))
                        .foregroundColor(Color.mindHexColor("4A3422"))

                    Text(appointment.scheduledAt.formatted(.dateTime.day().month().hour().minute()))
                        .font(.custom("Outfit-Regular", size: 13))
                        .foregroundColor(Color.mindHexColor("9A8B7F"))

                    Text(appointment.type.displayName)
                        .font(.custom("Outfit-Medium", size: 11))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.mindHexColor("EB6538").opacity(0.7))
                        .cornerRadius(8)
                }
                Spacer()
            }

            HStack(spacing: 12) {
                Button(action: onViewMood) {
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("ดู Mood")
                    }
                    .font(.custom("Outfit-SemiBold", size: 15))
                    .foregroundColor(Color.mindHexColor("EB6538"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.mindHexColor("FFF2EE"))
                    .cornerRadius(16)
                }

                Button(action: onAccept) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("รับคิว")
                    }
                    .font(.custom("Outfit-Bold", size: 15))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [Color.mindHexColor("EB6538"), Color.mindHexColor("F39C12")],
                            startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(16)
                }
            }
        }
        .padding(20)
        .background(Color.mindHexColor("FDF6EC"))
        .cornerRadius(30)
        .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 6)
    }
}

struct ConfirmedSessionCard: View {
    let appointment: Appointment
    let onViewMood: () -> Void

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.mindHexColor("3AB05D").opacity(0.3))

            VStack(alignment: .leading, spacing: 4) {
                Text(appointment.patientName ?? "Jane Smith")
                    .font(.custom("Outfit-Bold", size: 17))
                    .foregroundColor(Color.mindHexColor("4A3422"))
                Text(appointment.scheduledAt.formatted(.dateTime.hour().minute()) + " — \(appointment.duration) นาที")
                    .font(.custom("Outfit-Regular", size: 13))
                    .foregroundColor(Color.mindHexColor("9A8B7F"))
            }

            Spacer()

            Button(action: onViewMood) {
                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.mindHexColor("EB6538"))
            }
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
    }
}

struct EmptyStateView: View {
    let message: String
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 10) {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 40))
                    .foregroundColor(Color.mindHexColor("D0C0B0"))
                Text(message)
                    .font(.custom("Outfit-Regular", size: 14))
                    .foregroundColor(Color.mindHexColor("9A8B7F"))
            }
            .padding(40)
            Spacer()
        }
        .background(Color.mindHexColor("FDF6EC").opacity(0.5))
        .cornerRadius(25)
    }
}
