//
//  AmountPickerActionButtons.swift
//  Banking
//
//  Created by John Endres on 2/7/26.
//

import SwiftUI

/// Displays the Schedule and Pay action buttons.
struct AmountPickerActionButtons: View {
    /// The selected payment amount.
    let selectedAmount: Decimal
    
    /// Closure called when the payment is confirmed.
    let onConfirm: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
//            Button {
//            } label: {
//                Text("Schedule")
//                    .frame(maxWidth: .infinity)
//            }
//            .buttonStyle(.bordered)
//            .controlSize(.large)
            
            Button {
                onConfirm()
            } label: {
                Text("Pay \(selectedAmount.formatted(.currency(code: "USD")))")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.black)
            .controlSize(.large)
        }
        .padding(.horizontal)
        .padding(.bottom, 24)
    }
}

#Preview {
    AmountPickerActionButtons(
        selectedAmount: Decimal(142.50),
        onConfirm: {}
    )
}
