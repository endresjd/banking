//
//  BillSortOption.swift
//  Banking
//
//  Created by John Endres on 2/7/26.
//

import Foundation

/// Defines the available sorting options for bills.
enum BillSortOption: String, CaseIterable, Identifiable {
    case dueDate = "Due Date"
    case payee = "Name"
    case amount = "Amount"
    case category = "Type"
    case paid = "Paid Status"
    
    var id: String {
        rawValue
    }
    
    /// Returns the SF Symbol icon for this sort option.
    var icon: String {
        switch self {
        case .dueDate:
            "calendar"
        case .payee:
            "textformat"
        case .amount:
            "dollarsign.circle"
        case .category:
            "folder"
        case .paid:
            "checkmark.circle"
        }
    }
}
