//
//  PaymentModels.swift
//  Mindcare
//
//  Created for MindCareAI Project
//

import Foundation

// MARK: - Billing Interval

enum BillingInterval: String, Codable {
    case day = "day"
    case week = "week"
    case month = "month"
    case year = "year"
    case monthly = "monthly"
    case quarterly = "quarterly"
    case yearly = "yearly"
    
    var displayName: String {
        switch self {
        case .day: return "Daily"
        case .week: return "Weekly"
        case .month: return "Monthly"
        case .year: return "Yearly"
        case .monthly: return "Monthly"
        case .quarterly: return "Quarterly"
        case .yearly: return "Yearly"
        }
    }
}

// MARK: - Payment Type

enum PaymentType: String, Codable {
    case consultation = "consultation"
    case subscription = "subscription"
    case topUp = "top_up"
    case refund = "refund"
    case fee = "fee"
    case oneTime = "one_time"
    
    var displayName: String {
        switch self {
        case .consultation: return "Consultation"
        case .subscription: return "Subscription"
        case .topUp: return "Top Up"
        case .refund: return "Refund"
        case .fee: return "Platform Fee"
        case .oneTime: return "One Time"
        }
    }
    
    var icon: String {
        switch self {
        case .consultation: return "person.2.fill"
        case .subscription: return "repeat.circle.fill"
        case .topUp: return "plus.circle.fill"
        case .refund: return "arrow.uturn.backward.circle.fill"
        case .fee: return "percent"
        case .oneTime: return "1.circle.fill"
        }
    }
}

// MARK: - Transaction Status

enum TransactionStatus: String, Codable {
    case pending = "pending"
    case processing = "processing"
    case completed = "completed"
    case failed = "failed"
    case refunded = "refunded"
    case cancelled = "cancelled"
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var color: String {
        switch self {
        case .pending: return "yellow"
        case .processing: return "blue"
        case .completed: return "green"
        case .failed: return "red"
        case .refunded: return "orange"
        case .cancelled: return "gray"
        }
    }
    
    var icon: String {
        switch self {
        case .pending: return "clock.fill"
        case .processing: return "arrow.triangle.2.circlepath"
        case .completed: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
        case .refunded: return "arrow.uturn.backward.circle.fill"
        case .cancelled: return "minus.circle.fill"
        }
    }
}

// MARK: - Subscription Status

enum SubscriptionStatus: String, Codable {
    case active = "active"
    case trialing = "trialing"
    case pastDue = "past_due"
    case cancelled = "cancelled"
    case expired = "expired"
    case paused = "paused"
    
    var displayName: String {
        switch self {
        case .active: return "Active"
        case .trialing: return "Trial"
        case .pastDue: return "Past Due"
        case .cancelled: return "Cancelled"
        case .expired: return "Expired"
        case .paused: return "Paused"
        }
    }
    
    var color: String {
        switch self {
        case .active: return "green"
        case .trialing: return "blue"
        case .pastDue: return "orange"
        case .cancelled, .expired: return "red"
        case .paused: return "gray"
        }
    }
}

// MARK: - Payment Method Type

enum PaymentMethodType: String, Codable {
    case card = "card"
    case applePay = "apple_pay"
    case bankTransfer = "bank_transfer"
    case promptPay = "promptpay"
    
    var displayName: String {
        switch self {
        case .card: return "Credit/Debit Card"
        case .applePay: return "Apple Pay"
        case .bankTransfer: return "Bank Transfer"
        case .promptPay: return "PromptPay"
        }
    }
}

// MARK: - Subscription Plan

struct SubscriptionPlan: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Decimal
    let currency: String
    let interval: BillingInterval
    let intervalCount: Int
    let features: [String]
    let trialDays: Int?
    let isActive: Bool
    let discount: Decimal?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, price, currency, interval
        case intervalCount = "interval_count"
        case features
        case trialDays = "trial_days"
        case isActive = "is_active"
        case discount
    }
    
    var displayName: String {
        "\(name) (\(interval.displayName))"
    }
    
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        let priceString = formatter.string(from: price as NSDecimalNumber) ?? "\(currency) \(price)"
        
        switch interval {
        case .day: return "\(priceString)/day"
        case .week: return "\(priceString)/week"
        case .month, .monthly: return "\(priceString)/month"
        case .year, .yearly: return "\(priceString)/year"
        case .quarterly: return "\(priceString)/quarter"
        }
    }
}

// MARK: - Transaction Metadata

struct TransactionMetadata: Codable {
    let appointmentId: String?
    let subscriptionId: String?
    let psychiatristId: String?
    let psychiatristName: String?
    let consultationType: String?
    let platformFee: Decimal?
    let netAmount: Decimal?
    
    enum CodingKeys: String, CodingKey {
        case appointmentId = "appointment_id"
        case subscriptionId = "subscription_id"
        case psychiatristId = "psychiatrist_id"
        case psychiatristName = "psychiatrist_name"
        case consultationType = "consultation_type"
        case platformFee = "platform_fee"
        case netAmount = "net_amount"
    }
}

// MARK: - Payment Transaction

struct PaymentTransaction: Codable, Identifiable {
    let id: String
    let userId: String
    let amount: Decimal
    let currency: String
    let status: TransactionStatus
    let paymentMethod: String
    let paymentType: PaymentType
    let description: String
    let metadata: TransactionMetadata?
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case amount
        case currency
        case status
        case paymentMethod = "payment_method"
        case paymentType = "payment_type"
        case description
        case metadata
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(currency) \(amount)"
    }
}

// MARK: - User Subscription

struct UserSubscription: Codable, Identifiable {
    let id: String
    let userId: String
    let planId: String
    let plan: SubscriptionPlan?
    let status: SubscriptionStatus
    let currentPeriodStart: Date
    let currentPeriodEnd: Date
    let cancelAtPeriodEnd: Bool
    let trialEnd: Date?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case planId = "plan_id"
        case plan
        case status
        case currentPeriodStart = "current_period_start"
        case currentPeriodEnd = "current_period_end"
        case cancelAtPeriodEnd = "cancel_at_period_end"
        case trialEnd = "trial_end"
        case createdAt = "created_at"
    }
    
    var isActive: Bool {
        status == .active || status == .trialing
    }
    
    var daysRemaining: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: currentPeriodEnd).day ?? 0
    }
}

// MARK: - Billing Address

struct BillingAddress: Codable {
    let line1: String?
    let line2: String?
    let city: String?
    let state: String?
    let postalCode: String?
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case line1, line2, city, state
        case postalCode = "postal_code"
        case country
    }
}

// MARK: - Billing Details

struct BillingDetails: Codable {
    let name: String?
    let email: String?
    let phone: String?
    let address: BillingAddress?
    let taxId: String?
    
    enum CodingKeys: String, CodingKey {
        case name, email, phone, address
        case taxId = "tax_id"
    }
}

// MARK: - Receipt Item

struct ReceiptItem: Codable, Identifiable {
    var id: String { description }
    let description: String
    let quantity: Int
    let unitPrice: Decimal
    let total: Decimal
    
    enum CodingKeys: String, CodingKey {
        case description
        case quantity
        case unitPrice = "unit_price"
        case total
    }
}

// MARK: - Payment Receipt

struct PaymentReceipt: Codable, Identifiable {
    let id: String
    let transactionId: String
    let receiptNumber: String
    let amount: Decimal
    let currency: String
    let paidAt: Date
    let items: [ReceiptItem]
    let billingDetails: BillingDetails?
    let downloadUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case transactionId = "transaction_id"
        case receiptNumber = "receipt_number"
        case amount
        case currency
        case paidAt = "paid_at"
        case items
        case billingDetails = "billing_details"
        case downloadUrl = "download_url"
    }
}

// MARK: - Payment History Response

struct PaymentHistoryResponse: Codable {
    let transactions: [PaymentTransaction]
    let totalCount: Int
    let hasMore: Bool
    
    enum CodingKeys: String, CodingKey {
        case transactions
        case totalCount = "total_count"
        case hasMore = "has_more"
    }
}

// MARK: - Refund Request

struct RefundRequest: Codable {
    let transactionId: String
    let reason: String
    let amount: Decimal?
    
    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
        case reason
        case amount
    }
}

// MARK: - Refund Response

struct RefundResponse: Codable {
    let success: Bool
    let refundId: String
    let amount: Decimal
    let status: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case refundId = "refund_id"
        case amount
        case status
        case message
    }
}

// MARK: - Payment Method

struct PaymentMethod: Codable, Identifiable {
    let id: String
    let type: PaymentMethodType
    let last4: String?
    let brand: String?
    let expiryMonth: Int?
    let expiryYear: Int?
    let isDefault: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, type, last4, brand
        case expiryMonth = "expiry_month"
        case expiryYear = "expiry_year"
        case isDefault = "is_default"
    }
    
    var displayName: String {
        if let brand = brand, let last4 = last4 {
            return "\(brand) •••• \(last4)"
        }
        return type.displayName
    }
    
    var icon: String {
        switch brand?.lowercased() {
        case "visa": return "creditcard.fill"
        case "mastercard": return "creditcard.fill"
        case "amex": return "creditcard.fill"
        default: return "creditcard"
        }
    }
}

// MARK: - Pricing Tier (สำหรับ Dynamic Pricing)

struct PricingTier: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let basePrice: Decimal
    let currency: String
    let features: [String]
    let isPopular: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case basePrice = "base_price"
        case currency
        case features
        case isPopular = "is_popular"
    }
}
