//
//  PaymentBillHeader.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// Displays the bill header with icon, payee name, and category.
struct PaymentBillHeader: View {
    /// The bill to display.
    let bill: Bill
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: bill.category.icon)
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            
            Text(bill.payee)
                .font(.title2)
                .bold()
            
            Text(bill.category.rawValue)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 32)
    }
}

#Preview {
    PaymentBillHeader(bill: Bill.samples[0])
}
