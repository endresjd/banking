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

    /// Closure called when the payment is confirmed.
    let onConfirm: () -> Void

    /// The currently selected account for payment.
    @State private var selectedAccount = Account.samples[0]

    /// The selected payment date.
    @State private var paymentDate = Date()

    /// The currently selected amount.
    @State private var selectedAmount: Decimal
    
    @Environment(\.dismiss) private var dismiss

    init(bill: Bill, onConfirm: @escaping () -> Void) {
        self.bill = bill
        self.onConfirm = onConfirm
        self._selectedAmount = State(initialValue: bill.minimumDueAmount)
    }

    /// Indicates whether the selected account has insufficient funds for the minimum due.
    private var insufficientFundsForMinimum: Bool {
        selectedAccount.balance < bill.minimumDueAmount
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
//                PaymentBillHeader(bill: bill)
//                    .padding(.vertical)

                AmountPickerDetailsCard(
                    selectedAccount: $selectedAccount,
                    paymentDate: $paymentDate,
                    selectedAmount: selectedAmount
                )

                if insufficientFundsForMinimum {
                    InsufficientFundsErrorBanner(minimumDueAmount: bill.minimumDueAmount)
                } else {
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
        }
    }
}

#Preview {
    AmountPickerView(
        bill: Bill.samples[0],
        onConfirm: {
        }
    )
}
