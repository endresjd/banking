//
//  PaymentAmountRow.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// A row that displays and allows editing the payment amount.
struct PaymentAmountRow: View {
    /// The bill being paid.
    let bill: Bill
    
    /// The selected payment amount.
    @Binding var paymentAmount: Decimal
    
    /// Indicates whether the amount picker sheet is presented.
    @Binding var showAmountPicker: Bool
    
    var body: some View {
        HStack {
            Text("Payment Amount")
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Button {
                showAmountPicker = true
            } label: {
                Text(paymentAmount.formatted(.currency(code: "USD")))
                    .bold()
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $showAmountPicker) {
            NavigationStack {
                ScrollView {
                    AmountPickerView(
                        bill: bill,
                        onConfirm: {
                            showAmountPicker = false
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var paymentAmount = Decimal(142.50)
    @Previewable @State var showAmountPicker = false
    
    PaymentAmountRow(
        bill: Bill.samples[0],
        paymentAmount: $paymentAmount,
        showAmountPicker: $showAmountPicker
    )
    .padding()
}
