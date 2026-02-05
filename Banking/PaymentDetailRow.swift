//
//  PaymentDetailRow.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// Displays a row of payment details.
struct PaymentDetailRow: View {
    let label: String
    let value: Double
    let format: FloatingPointFormatStyle<Double>.Currency
    var isWarning: Bool = false
    
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
