//
//  ApplePayButtonView.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import SwiftUI
import PassKit

// MARK: - Apple Pay Button

struct ApplePayButtonView: UIViewRepresentable {
    let type: PKPaymentButtonType
    let style: PKPaymentButtonStyle
    let action: () -> Void
    
    init(
        type: PKPaymentButtonType = .buy,
        style: PKPaymentButtonStyle = .black,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.style = style
        self.action = action
    }
    
    func makeUIView(context: Context) -> PKPaymentButton {
        let button = PKPaymentButton(paymentButtonType: type, paymentButtonStyle: style)
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonTapped), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: PKPaymentButton, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }
    
    class Coordinator: NSObject {
        let action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        @objc func buttonTapped() {
            action()
        }
    }
}

// MARK: - Apple Pay Setup Button

struct ApplePaySetupButtonView: UIViewRepresentable {
    let action: () -> Void
    
    func makeUIView(context: Context) -> PKAddPassButton {
        let button = PKAddPassButton(addPassButtonStyle: .black)
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonTapped), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: PKAddPassButton, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }
    
    class Coordinator: NSObject {
        let action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        @objc func buttonTapped() {
            action()
        }
    }
}

// MARK: - Payment View

struct PaymentView: View {
    @StateObject private var applePayManager = ApplePayManager.shared
    
    let psychiatristName: String
    let consultationType: ConsultationType
    let amount: Decimal
    var onPaymentComplete: ((PaymentResult) -> Void)?
    var onCancel: (() -> Void)?
    
    @State private var isProcessing = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSuccess = false
    @State private var paymentResult: PaymentResult?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                PaymentHeaderView(
                    psychiatristName: psychiatristName,
                    consultationType: consultationType
                )
                
                Divider()
                
                // Price Breakdown
                PriceBreakdownView(
                    consultationType: consultationType,
                    amount: amount
                )
                
                Spacer()
                
                // Payment Buttons
                VStack(spacing: 16) {
                    if applePayManager.canMakePayments {
                        ApplePayButtonView(type: .book, style: .black) {
                            processPayment()
                        }
                        .frame(height: 50)
                        .disabled(isProcessing)
                        
                        Text("or pay with card")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button {
                            // Show card payment form
                        } label: {
                            Text("Pay with Card")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                        }
                    } else if applePayManager.shouldShowSetupButton {
                        // Show setup button
                        VStack(spacing: 12) {
                            Text("Set up Apple Pay to pay quickly and securely")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            ApplePaySetupButtonView {
                                applePayManager.openWalletApp()
                            }
                            .frame(height: 50)
                        }
                    } else {
                        // Apple Pay not available
                        Button {
                            // Show card payment form
                        } label: {
                            Text("Pay with Card")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Security Note
                HStack {
                    Image(systemName: "lock.shield.fill")
                        .foregroundColor(.green)
                    Text("Secure payment powered by Apple Pay")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
            }
            .padding()
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel?()
                    }
                }
            }
            .overlay {
                if isProcessing {
                    ProcessingOverlay()
                }
            }
            .alert("Payment Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .sheet(isPresented: $showSuccess) {
                if let result = paymentResult {
                    PaymentSuccessView(result: result) {
                        onPaymentComplete?(result)
                    }
                }
            }
        }
    }
    
    private func processPayment() {
        isProcessing = true
        
        Task {
            do {
                let result = try await applePayManager.payForConsultation(
                    psychiatristName: psychiatristName,
                    consultationType: consultationType,
                    amount: amount
                )
                
                await MainActor.run {
                    isProcessing = false
                    paymentResult = result
                    showSuccess = true
                }
            } catch let error as ApplePayError {
                await MainActor.run {
                    isProcessing = false
                    if error != .cancelled {
                        errorMessage = error.localizedDescription
                        showError = true
                    }
                }
            } catch {
                await MainActor.run {
                    isProcessing = false
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
}

// MARK: - Payment Header View

struct PaymentHeaderView: View {
    let psychiatristName: String
    let consultationType: ConsultationType
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
            
            Text("Dr. \(psychiatristName)")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(consultationType.displayName)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Price Breakdown View

struct PriceBreakdownView: View {
    let consultationType: ConsultationType
    let amount: Decimal
    
    private var platformFee: Decimal {
        amount * Decimal(0.05)
    }
    
    private var total: Decimal {
        amount + platformFee
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(consultationType.displayName)
                Spacer()
                Text(formatPrice(amount))
            }
            
            HStack {
                Text("Platform Fee (5%)")
                    .foregroundColor(.secondary)
                Spacer()
                Text(formatPrice(platformFee))
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            HStack {
                Text("Total")
                    .fontWeight(.bold)
                Spacer()
                Text(formatPrice(total))
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
            }
            .font(.title3)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func formatPrice(_ price: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "THB"
        return formatter.string(from: price as NSDecimalNumber) ?? "฿\(price)"
    }
}

// MARK: - Processing Overlay

struct ProcessingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                
                Text("Processing Payment...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(32)
            .background(Color(UIColor.systemBackground).opacity(0.9))
            .cornerRadius(16)
        }
    }
}

// MARK: - Payment Success View

struct PaymentSuccessView: View {
    let result: PaymentResult
    var onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Payment Successful!")
                .font(.title)
                .fontWeight(.bold)
            
            Text(result.message)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 8) {
                Text("Transaction ID")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(result.transactionId)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
            
            Spacer()
            
            Button {
                onDismiss()
            } label: {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 32)
            .padding(.bottom)
        }
        .padding()
    }
}

// MARK: - Subscription Payment View

struct SubscriptionPaymentView: View {
    @StateObject private var applePayManager = ApplePayManager.shared
    
    let plan: SubscriptionPlan
    var onPaymentComplete: ((PaymentResult) -> Void)?
    var onCancel: (() -> Void)?
    
    @State private var isProcessing = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Plan Details
                SubscriptionPlanCard(plan: plan)
                
                // Features
                VStack(alignment: .leading, spacing: 12) {
                    Text("What's included:")
                        .font(.headline)
                    
                    ForEach(plan.features, id: \.self) { feature in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(feature)
                                .font(.subheadline)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
                
                Spacer()
                
                // Trial Info
                if let trialDays = plan.trialDays, trialDays > 0 {
                    Text("Start with \(trialDays)-day free trial")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                
                // Payment Button
                if applePayManager.canMakePayments {
                    ApplePayButtonView(type: .subscribe, style: .black) {
                        processSubscription()
                    }
                    .frame(height: 50)
                    .disabled(isProcessing)
                }
                
                // Terms
                Text("By subscribing, you agree to our Terms of Service and Privacy Policy. Subscription renews automatically.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Subscribe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel?()
                    }
                }
            }
            .overlay {
                if isProcessing {
                    ProcessingOverlay()
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func processSubscription() {
        isProcessing = true
        
        Task {
            do {
                let result = try await applePayManager.payForSubscription(plan: plan)
                
                await MainActor.run {
                    isProcessing = false
                    onPaymentComplete?(result)
                }
            } catch {
                await MainActor.run {
                    isProcessing = false
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
}

// MARK: - Subscription Plan Card

struct SubscriptionPlanCard: View {
    let plan: SubscriptionPlan
    
    var body: some View {
        VStack(spacing: 16) {
            Text(plan.name)
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(alignment: .firstTextBaseline) {
                Text(plan.formattedPrice)
                    .font(.system(size: 40, weight: .bold))
                
                Text("/ \(plan.interval.displayName.lowercased())")
                    .foregroundColor(.secondary)
            }
            
            if let discount = plan.discount, discount > 0 {
                Text("Save \(formatPrice(discount))")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green)
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.accentColor.opacity(0.1))
        .cornerRadius(16)
    }
    
    private func formatPrice(_ price: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "THB"
        return formatter.string(from: price as NSDecimalNumber) ?? "฿\(price)"
    }
}

// MARK: - Preview

#Preview {
    PaymentView(
        psychiatristName: "Sarah Johnson",
        consultationType: .initial,
        amount: 1500
    )
}
