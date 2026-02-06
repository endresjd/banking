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
    let id: UUID
    
    /// The display name of the account.
    let name: String
    
    /// The type of account (e.g., "Checking", "Savings").
    let accountType: String
    
    /// The current balance of the account.
    var balance: Decimal
    
    init(id: UUID = UUID(), name: String, accountType: String, balance: Decimal) {
        self.id = id
        self.name = name
        self.accountType = accountType
        self.balance = balance
    }
    
    static let samples: [Account] = [
        Account(name: "Checking Account", accountType: "Checking", balance: 5432.50),
        Account(name: "Savings Account", accountType: "Savings", balance: 12500.00),
        Account(name: "Emergency Fund", accountType: "Savings", balance: 8000.00)
    ]
}
