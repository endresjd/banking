//
//  PaymentDateRow.swift
//  Banking
//
//  Created by John Endres on 2/7/26.
//

import SwiftUI

/// A row displaying a date picker for selecting the payment date.
struct PaymentDateRow: View {
    /// The selected payment date.
    @Binding var paymentDate: Date
    
    var body: some View {
        HStack {
            Text("Payment Date")
                .foregroundStyle(.secondary)
            
            Spacer()
            
            DatePicker(
                "Select payment date",
                selection: $paymentDate,
                in: Date()...,
                displayedComponents: [.date]
            )
            .labelsHidden()
            .datePickerStyle(.compact)
        }
    }
}

#Preview {
    @Previewable @State var paymentDate = Date()
    
    PaymentDateRow(paymentDate: $paymentDate)
        .padding()
}
