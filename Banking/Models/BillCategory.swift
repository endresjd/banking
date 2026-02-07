//
//  BillCategory.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import Foundation

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
    
    /// The system icon name for the bill category.
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
