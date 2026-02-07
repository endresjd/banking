//
//  PaymentDateCard.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// A card displaying a date picker for selecting the payment date.
struct PaymentDateCard: View {
    /// The selected payment date.
    @Binding var paymentDate: Date
    
    var body: some View {
        PaymentDateRow(paymentDate: $paymentDate)
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    @Previewable @State var paymentDate = Date()
    
    PaymentDateCard(paymentDate: $paymentDate)
        .padding()
}
