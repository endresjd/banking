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
        VStack(spacing: 8) {
            HStack {
                Image(systemName: bill.category.icon)
                    .font(.system(size: 30))
                    .foregroundStyle(.blue)

                Text(bill.payee)
                    .font(.title2)
                    .bold()
            }
            
//            Text(bill.category.rawValue)
//                .font(.subheadline)
//                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    PaymentBillHeader(bill: Bill.samples[0])
}
