//
//  AccountType.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import Foundation

/// Represents the type of a bank account.
enum AccountType: String, CaseIterable {
    /// A checking account for daily transactions.
    case checking = "Checking"
    
    /// A savings account for storing money.
    case savings = "Savings"
}
