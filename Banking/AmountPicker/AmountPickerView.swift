//
//  AmountPickerView.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// A view for choosing payment amounts with a circular slider interface.
struct AmountPickerView: View {
    /// The bill to be paid.
    let bill: Bill
    
    /// The currently selected amount.
    @Binding var selectedAmount: Decimal
    
    /// Closure called when the payment is confirmed.
    let onConfirm: () -> Void
    
    /// Closure called when the view is dismissed.
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            VStack {
                AmountPickerHeader(bill: bill)
                
                CircularAmountPicker(
                    selectedAmount: $selectedAmount,
                    minimumAmount: 0,
                    minimumDueAmount: bill.minimumDueAmount,
                    maximumAmount: bill.amount,
                    topLabel: "CARD BALANCE \(bill.amount.formatted(.currency(code: "USD")))",
                    bottomLabel: "MIN DUE \(bill.minimumDueAmount.formatted(.currency(code: "USD")))"
                )
                
                AmountPickerInfoCard()
                
                AmountPickerActionButtons(
                    selectedAmount: selectedAmount,
                    onConfirm: onConfirm
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        onDismiss()
                    }
                    .buttonStyle(.glass)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedAmount = Decimal(77.39)

    AmountPickerView(
        bill: Bill.samples[0],
        selectedAmount: $selectedAmount,
        onConfirm: {
        },
        onDismiss: {
        }
    )
}
