//
//  PaymentDetailRow.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// Displays a row of payment details.
struct PaymentDetailRow: View {
    /// The label describing the value.
    let label: String
    
    /// The monetary value to display.
    let value: Decimal
    
    /// The currency format style for displaying the value.
    let format: Decimal.FormatStyle.Currency
    
    /// Indicates whether to display the value as a warning (in red).
    var isWarning = false
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value, format: format)
                .bold()
                .foregroundStyle(isWarning ? .red : .primary)
        }
    }
}
