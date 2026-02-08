//
//  PaymentDetailsCard.swift
//  Banking
//
//  Created by John Endres on 2/7/26.
//

import SwiftUI

/// Displays payment details including account selection, date, and balance information.
struct AmountPickerDetailsCard: View {
    /// The currently selected account.
    @Binding var selectedAccount: Account
    
    /// The selected payment date.
    @Binding var paymentDate: Date
    
    /// The selected payment amount.
    let selectedAmount: Decimal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AccountSelectorRow(selectedAccount: $selectedAccount)

            Divider()

            PaymentDateRow(paymentDate: $paymentDate)

            Divider()

            LabeledContent("Current Balance") {
                Text(selectedAccount.balance, format: .currency(code: "USD"))
                    .bold()
            }

            Divider()

            LabeledContent("Balance After Payment") {
                Text(selectedAccount.balance - selectedAmount, format: .currency(code: "USD"))
                    .bold()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

#Preview {
    @Previewable @State var selectedAccount = Account.samples[0]
    @Previewable @State var paymentDate = Date()
    
    AmountPickerDetailsCard(
        selectedAccount: $selectedAccount,
        paymentDate: $paymentDate,
        selectedAmount: Decimal(142.50)
    )
    .padding()
}
