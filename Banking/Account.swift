//
//  Account.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import Foundation

/// Represents a bank account.
struct Account: Identifiable, Hashable {
    let id: UUID
    let name: String
    let accountType: String
    var balance: Double
    
    init(id: UUID = UUID(), name: String, accountType: String, balance: Double) {
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
