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
    
    /// The currently selected account for payment.
    @State private var selectedAccount = Account.samples[0]
    
    /// The selected payment date.
    @State private var paymentDate = Date()
    
    /// Indicates whether the selected account has insufficient funds for the minimum due.
    private var insufficientFundsForMinimum: Bool {
        selectedAccount.balance < bill.minimumDueAmount
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                AmountPickerHeader(bill: bill)
                    .padding(.bottom)

                VStack(alignment: .leading, spacing: 16) {
                    AccountSelectorRow(selectedAccount: $selectedAccount)

                    Divider()
                    
                    PaymentDateRow(paymentDate: $paymentDate)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                if insufficientFundsForMinimum {
                    InsufficientFundsErrorBanner(minimumDueAmount: bill.minimumDueAmount)
                } else {
                    Text("Choose a Payment Amount")
                        .font(.title2)
                        .bold()
                        .padding()

                    CircularAmountPicker(
                        selectedAmount: $selectedAmount,
                        minimumAmount: 0,
                        minimumDueAmount: bill.minimumDueAmount,
                        maximumAmount: bill.amount,
                        dragLimit: selectedAccount.balance
                    )

//                    AmountPickerInfoCard()
                }

                if !insufficientFundsForMinimum {
                    AmountPickerActionButtons(
                        selectedAmount: selectedAmount,
                        onConfirm: onConfirm
                    )
                }

                Spacer()
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
