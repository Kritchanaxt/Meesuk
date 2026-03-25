//
//  ApplePayManager.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation
import PassKit
import Combine

/// Apple Pay Manager - จัดการการชำระเงินผ่าน Apple Pay
final class ApplePayManager: NSObject, ObservableObject {
    
    // MARK: - Singleton
    static let shared = ApplePayManager()
    
    // MARK: - Properties
    @Published var paymentStatus: PaymentStatus = .idle
    @Published var lastTransactionId: String?
    
    private var paymentController: PKPaymentAuthorizationController?
    private var paymentContinuation: CheckedContinuation<PKPayment, Error>?
    
    // MARK: - Configuration
    
    /// Merchant ID ที่ลงทะเบียนกับ Apple
    /// ต้องเปลี่ยนเป็น Merchant ID จริงของคุณ
    static let merchantIdentifier = "merchant.com.mindcare.app"
    
    /// ประเทศที่รองรับ
    static let countryCode = "TH"
    
    /// สกุลเงิน
    static let currencyCode = "THB"
    
    /// Networks ที่รองรับ
    static let supportedNetworks: [PKPaymentNetwork] = [
        .visa,
        .masterCard,
        .amex,
        .discover,
        .JCB
    ]
    
    /// Capabilities ที่ต้องการ
    static var merchantCapabilities: PKMerchantCapability {
        if #available(iOS 17.0, *) {
            return [.threeDSecure, .credit, .debit]
        } else {
            return [.capability3DS, .capabilityCredit, .capabilityDebit]
        }
    }
    
    // MARK: - Initialization
    
    private override init() {
        super.init()
    }
    
    // MARK: - Availability Check
    
    /// ตรวจสอบว่าอุปกรณ์รองรับ Apple Pay หรือไม่
    var isApplePayAvailable: Bool {
        PKPaymentAuthorizationController.canMakePayments()
    }
    
    /// ตรวจสอบว่ามีบัตรที่ใช้ได้หรือไม่
    var canMakePayments: Bool {
        PKPaymentAuthorizationController.canMakePayments(
            usingNetworks: Self.supportedNetworks,
            capabilities: Self.merchantCapabilities
        )
    }
    
    /// ตรวจสอบว่าต้องแสดงปุ่ม Setup หรือไม่
    var shouldShowSetupButton: Bool {
        isApplePayAvailable && !canMakePayments
    }
    
    // MARK: - Payment Request
    
    /// สร้าง Payment Request สำหรับ Consultation
    func createConsultationPaymentRequest(
        psychiatristName: String,
        consultationType: ConsultationType,
        amount: Decimal
    ) -> PKPaymentRequest {
        let request = PKPaymentRequest()
        
        // Merchant Info
        request.merchantIdentifier = Self.merchantIdentifier
        request.countryCode = Self.countryCode
        request.currencyCode = Self.currencyCode
        request.supportedNetworks = Self.supportedNetworks
        request.merchantCapabilities = Self.merchantCapabilities
        
        // Payment Summary Items
        var summaryItems: [PKPaymentSummaryItem] = []
        
        // รายละเอียดการชำระ
        summaryItems.append(PKPaymentSummaryItem(
            label: "\(consultationType.displayName) - Dr. \(psychiatristName)",
            amount: NSDecimalNumber(decimal: amount)
        ))
        
        // ค่าธรรมเนียมแพลตฟอร์ม (ถ้ามี)
        let platformFee = amount * Decimal(0.05) // 5% platform fee
        if platformFee > 0 {
            summaryItems.append(PKPaymentSummaryItem(
                label: "Platform Fee",
                amount: NSDecimalNumber(decimal: platformFee)
            ))
        }
        
        // Total
        let total = amount + platformFee
        summaryItems.append(PKPaymentSummaryItem(
            label: "MindCare",
            amount: NSDecimalNumber(decimal: total),
            type: .final
        ))
        
        request.paymentSummaryItems = summaryItems
        
        // Required Shipping/Billing Fields (ถ้าต้องการ)
        request.requiredBillingContactFields = [.emailAddress, .name]
        
        return request
    }
    
    /// สร้าง Payment Request สำหรับ Subscription
    func createSubscriptionPaymentRequest(
        plan: SubscriptionPlan
    ) -> PKPaymentRequest {
        let request = PKPaymentRequest()
        
        request.merchantIdentifier = Self.merchantIdentifier
        request.countryCode = Self.countryCode
        request.currencyCode = Self.currencyCode
        request.supportedNetworks = Self.supportedNetworks
        request.merchantCapabilities = Self.merchantCapabilities
        
        var summaryItems: [PKPaymentSummaryItem] = []
        
        // Subscription Item
        summaryItems.append(PKPaymentSummaryItem(
            label: plan.displayName,
            amount: NSDecimalNumber(decimal: plan.price)
        ))
        
        // Discount (ถ้ามี)
        if let discount = plan.discount, discount > Decimal(0) {
            summaryItems.append(PKPaymentSummaryItem(
                label: "Discount",
                amount: NSDecimalNumber(decimal: -discount)
            ))
        }
        
        // Total
        let total = plan.price - (plan.discount ?? Decimal(0))
        summaryItems.append(PKPaymentSummaryItem(
            label: "MindCare",
            amount: NSDecimalNumber(decimal: total),
            type: .final
        ))
        
        request.paymentSummaryItems = summaryItems
        request.requiredBillingContactFields = [.emailAddress, .name]
        
        // สำหรับ Recurring Payment
        if #available(iOS 16.0, *) {
            request.recurringPaymentRequest = createRecurringPaymentRequest(plan: plan)
        }
        
        return request
    }
    
    /// สร้าง Recurring Payment Request
    @available(iOS 16.0, *)
    private func createRecurringPaymentRequest(plan: SubscriptionPlan) -> PKRecurringPaymentRequest {
        let recurringRequest = PKRecurringPaymentRequest(
            paymentDescription: plan.displayName,
            regularBilling: PKRecurringPaymentSummaryItem(
                label: plan.displayName,
                amount: NSDecimalNumber(decimal: plan.price)
            ),
            managementURL: URL(string: "https://mindcare.app/subscription/manage")!
        )
        
        recurringRequest.billingAgreement = """
        You will be charged \(plan.formattedPrice) \(plan.interval.displayName.lowercased()).
        You can cancel anytime from your MindCare account settings.
        """
        
        return recurringRequest
    }
    
    // MARK: - Present Payment
    
    /// แสดง Apple Pay Sheet
    func presentPaymentSheet(request: PKPaymentRequest) async throws -> PKPayment {
        guard canMakePayments else {
            throw ApplePayError.notAvailable
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.paymentContinuation = continuation
            
            DispatchQueue.main.async {
                self.paymentStatus = .processing
                
                self.paymentController = PKPaymentAuthorizationController(paymentRequest: request)
                self.paymentController?.delegate = self
                
                self.paymentController?.present { presented in
                    if !presented {
                        self.paymentContinuation?.resume(throwing: ApplePayError.presentationFailed)
                        self.paymentContinuation = nil
                        self.paymentStatus = .failed
                    }
                }
            }
        }
    }
    
    /// ชำระเงินสำหรับ Consultation
    func payForConsultation(
        psychiatristName: String,
        consultationType: ConsultationType,
        amount: Decimal
    ) async throws -> PaymentResult {
        let request = createConsultationPaymentRequest(
            psychiatristName: psychiatristName,
            consultationType: consultationType,
            amount: amount
        )
        
        let payment = try await presentPaymentSheet(request: request)
        
        // ส่งไป Backend เพื่อ Process Payment
        let result = try await processPaymentOnBackend(payment: payment, type: .consultation)
        
        return result
    }
    
    /// ชำระเงินสำหรับ Subscription
    func payForSubscription(plan: SubscriptionPlan) async throws -> PaymentResult {
        let request = createSubscriptionPaymentRequest(plan: plan)
        
        let payment = try await presentPaymentSheet(request: request)
        
        // ส่งไป Backend เพื่อ Process Payment
        let result = try await processPaymentOnBackend(payment: payment, type: .subscription)
        
        return result
    }
    
    // MARK: - Process Payment on Backend
    
    private func processPaymentOnBackend(
        payment: PKPayment,
        type: PaymentType
    ) async throws -> PaymentResult {
        // แปลง Payment Token เป็น Base64
        let paymentData = payment.token.paymentData
        let paymentDataBase64 = paymentData.base64EncodedString()
        
        // สร้าง Request Body
        let paymentRequest = ProcessPaymentRequest(
            paymentData: paymentDataBase64,
            paymentMethod: payment.token.paymentMethod.displayName ?? "Apple Pay",
            paymentNetwork: payment.token.paymentMethod.network?.rawValue ?? "",
            transactionIdentifier: payment.token.transactionIdentifier,
            paymentType: type,
            billingContact: extractBillingContact(from: payment)
        )
        
        // ส่งไป Backend
        let result: PaymentResult = try await NetworkManager.shared.post(
            APIEndpoints.Payment.process,
            body: paymentRequest
        )
        
        await MainActor.run {
            self.lastTransactionId = result.transactionId
            self.paymentStatus = result.success ? .completed : .failed
        }
        
        return result
    }
    
    private func extractBillingContact(from payment: PKPayment) -> BillingContact? {
        guard let contact = payment.billingContact else { return nil }
        
        return BillingContact(
            name: contact.name.map { PersonNameComponentsFormatter().string(from: $0) },
            email: contact.emailAddress
        )
    }
    
    // MARK: - Open Wallet App
    
    /// เปิด Wallet App เพื่อ Setup Card
    func openWalletApp() {
        if let url = URL(string: "shoebox://") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - PKPaymentAuthorizationControllerDelegate

extension ApplePayManager: PKPaymentAuthorizationControllerDelegate {
    
    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        // Payment ถูก Authorize แล้ว
        // ส่งไป Backend เพื่อ Process
        
        Task {
            do {
                // Simulate backend processing
                try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                
                // Success
                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                paymentContinuation?.resume(returning: payment)
                paymentContinuation = nil
                
            } catch {
                // Failed
                let error = PKPaymentError(.unknownError, userInfo: [
                    NSLocalizedDescriptionKey: "Payment processing failed"
                ])
                completion(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
                paymentContinuation?.resume(throwing: ApplePayError.processingFailed)
                paymentContinuation = nil
            }
        }
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            // ถ้ายังไม่ได้ Resume หมายความว่าผู้ใช้ Cancel
            if self.paymentContinuation != nil {
                self.paymentContinuation?.resume(throwing: ApplePayError.cancelled)
                self.paymentContinuation = nil
                
                DispatchQueue.main.async {
                    self.paymentStatus = .cancelled
                }
            }
        }
    }
}

// MARK: - Payment Status

enum PaymentStatus: String {
    case idle = "idle"
    case processing = "processing"
    case completed = "completed"
    case failed = "failed"
    case cancelled = "cancelled"
}

// MARK: - Apple Pay Errors

enum ApplePayError: LocalizedError {
    case notAvailable
    case notConfigured
    case presentationFailed
    case cancelled
    case processingFailed
    case invalidPayment
    
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "Apple Pay is not available on this device"
        case .notConfigured:
            return "Apple Pay is not configured properly"
        case .presentationFailed:
            return "Failed to present Apple Pay"
        case .cancelled:
            return "Payment was cancelled"
        case .processingFailed:
            return "Payment processing failed"
        case .invalidPayment:
            return "Invalid payment information"
        }
    }
}

// MARK: - Consultation Type

enum ConsultationType: String, Codable {
    case initial = "initial"
    case followUp = "follow_up"
    case emergency = "emergency"
    
    var displayName: String {
        switch self {
        case .initial: return "Initial Consultation"
        case .followUp: return "Follow-up Session"
        case .emergency: return "Emergency Session"
        }
    }
    
    var basePrice: Decimal {
        switch self {
        case .initial: return 1500
        case .followUp: return 1000
        case .emergency: return 2500
        }
    }
}

// MARK: - Payment Request Models

struct ProcessPaymentRequest: Codable {
    let paymentData: String
    let paymentMethod: String
    let paymentNetwork: String
    let transactionIdentifier: String
    let paymentType: PaymentType
    let billingContact: BillingContact?
    
    enum CodingKeys: String, CodingKey {
        case paymentData = "payment_data"
        case paymentMethod = "payment_method"
        case paymentNetwork = "payment_network"
        case transactionIdentifier = "transaction_identifier"
        case paymentType = "payment_type"
        case billingContact = "billing_contact"
    }
}

struct BillingContact: Codable {
    let name: String?
    let email: String?
}

// MARK: - Payment Result

struct PaymentResult: Codable {
    let success: Bool
    let transactionId: String
    let message: String
    let receiptUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case transactionId = "transaction_id"
        case message
        case receiptUrl = "receipt_url"
    }
}
