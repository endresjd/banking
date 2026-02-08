//
//  OldPaymentDetailsCard.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// A card displaying payment details including account, amount, and balance information.
struct OldPaymentDetailsCard: View {
    /// The bill being paid.
    let bill: Bill
    
    /// The currently selected account.
    @Binding var selectedAccount: Account
    
    /// The selected payment amount.
    @Binding var paymentAmount: Decimal
    
    /// Indicates whether the amount picker sheet is presented.
    @Binding var showAmountPicker: Bool
    
    /// Indicates whether the selected account has insufficient funds for the payment amount.
    private var accountHasInsufficientFunds: Bool {
        selectedAccount.balance < paymentAmount
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AccountSelectorRow(selectedAccount: $selectedAccount)
            
            Divider()
            
            PaymentAmountRow(
                bill: bill,
                paymentAmount: $paymentAmount,
                showAmountPicker: $showAmountPicker
            )
            
            Divider()
            
            PaymentDetailRow(label: "Current Balance", value: selectedAccount.balance, format: .currency(code: "USD"))
            
            PaymentDetailRow(
                label: "Balance After Payment",
                value: selectedAccount.balance - paymentAmount,
                format: .currency(code: "USD"),
                isWarning: accountHasInsufficientFunds
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    @Previewable @State var selectedAccount = Account.samples[0]
    @Previewable @State var paymentAmount = Decimal(142.50)
    @Previewable @State var showAmountPicker = false
    
    OldPaymentDetailsCard(
        bill: Bill.samples[0],
        selectedAccount: $selectedAccount,
        paymentAmount: $paymentAmount,
        showAmountPicker: $showAmountPicker
    )
    .padding()
}
