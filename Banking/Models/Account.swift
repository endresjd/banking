//
//  Account.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import Foundation

/// Represents a bank account.
struct Account: Identifiable, Hashable {
    /// Unique identifier for the account.
    let id = UUID()
    
    /// The display name of the account.
    let name: String
    
    /// The type of account.
    let accountType: AccountType
    
    /// The current balance of the account.
    var balance: Decimal
    
    static let samples: [Account] = [
        Account(name: "Checking Account", accountType: .checking, balance: 5432.50),
        Account(name: "Savings Account", accountType: .savings, balance: 12500.00),
        Account(name: "Emergency Fund", accountType: .savings, balance: 8000.00),
        Account(name: "Small Account", accountType: .savings, balance: 5.00)
    ]
}
