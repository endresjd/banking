//
//  Bill.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import Foundation

/// Represents a bill that can be paid through the banking app.
struct Bill: Identifiable {
    /// Unique identifier for the bill.
    let id: UUID
    
    /// The name of the payee.
    let payee: String
    
    /// The amount due for this bill.
    let amount: Decimal
    
    /// The minimum amount that must be paid.
    let minimumDueAmount: Decimal
    
    /// The date when the bill is due.
    let dueDate: Date
    
    /// The category of the bill.
    let category: BillCategory
    
    /// Indicates whether the bill has been paid.
    var isPaid: Bool
    
    init(
        id: UUID = UUID(),
        payee: String,
        amount: Decimal,
        minimumDueAmount: Decimal? = nil,
        dueDate: Date,
        category: BillCategory,
        isPaid: Bool = false
    ) {
        self.id = id
        self.payee = payee
        self.amount = amount
        self.minimumDueAmount = minimumDueAmount ?? (amount * 0.125)
        self.dueDate = dueDate
        self.category = category
        self.isPaid = isPaid
    }
}

/// Categories for different types of bills.
enum BillCategory: String, CaseIterable {
    case utilities = "Utilities"
    case internet = "Internet"
    case phone = "Phone"
    case rent = "Rent"
    case insurance = "Insurance"
    case subscription = "Subscription"
    case credit = "Credit Card"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .utilities:
            return "bolt.fill"
        case .internet:
            return "wifi"
        case .phone:
            return "phone.fill"
        case .rent:
            return "house.fill"
        case .insurance:
            return "shield.fill"
        case .subscription:
            return "star.fill"
        case .credit:
            return "creditcard.fill"
        case .other:
            return "doc.fill"
        }
    }
}

extension Bill {
    /// Sample bills for preview and testing purposes.
    static let samples: [Bill] = [
        Bill(
            payee: "Electric Company",
            amount: 142.50,
            dueDate: Date().addingTimeInterval(86400 * 3),
            category: .utilities
        ),
        Bill(
            payee: "Internet Provider",
            amount: 79.99,
            dueDate: Date().addingTimeInterval(86400 * 5),
            category: .internet
        ),
        Bill(
            payee: "Phone Company",
            amount: 65.00,
            dueDate: Date().addingTimeInterval(86400 * 7),
            category: .phone
        ),
        Bill(
            payee: "Landlord Properties",
            amount: 1850.00,
            dueDate: Date().addingTimeInterval(86400 * 10),
            category: .rent
        ),
        Bill(
            payee: "Auto Insurance",
            amount: 245.00,
            dueDate: Date().addingTimeInterval(86400 * 15),
            category: .insurance
        ),
        Bill(
            payee: "Streaming Service",
            amount: 15.99,
            dueDate: Date().addingTimeInterval(86400 * 2),
            category: .subscription,
            isPaid: true
        )
    ]
}
