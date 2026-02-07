//
//  PaymentConfirmationContentView.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// Displays the payment confirmation content with details and date picker.
struct PaymentConfirmationContentView: View {
    /// The selected date for the payment.
    @Binding var paymentDate: Date
    
    /// The bill to be paid.
    let bill: Bill
    
    /// Indicates whether a payment is currently being processed.
    let isProcessing: Bool
    
    /// Closure called when the payment is confirmed.
    let onConfirm: () -> Void
    
    /// The currently selected account for payment.
    @State private var selectedAccount = Account.samples[0]
    
    /// The amount to be paid (editable by the user).
    @State private var paymentAmount: Decimal
    
    /// Indicates whether the amount picker sheet is presented.
    @State private var showAmountPicker = false
    
    /// Creates a new payment confirmation content view.
    ///
    /// - Parameters:
    ///   - paymentDate: Binding to the selected payment date.
    ///   - bill: The bill to be paid.
    ///   - isProcessing: Whether a payment is currently being processed.
    ///   - onConfirm: Closure called when the payment is confirmed.
    init(
        paymentDate: Binding<Date>,
        bill: Bill,
        isProcessing: Bool,
        onConfirm: @escaping () -> Void
    ) {
        self._paymentDate = paymentDate
        self.bill = bill
        self.isProcessing = isProcessing
        self.onConfirm = onConfirm
        self._paymentAmount = State(initialValue: bill.amount)
    }

    /// Indicates whether the selected account has insufficient funds for the payment amount.
    private var accountHasInsufficientFunds: Bool {
        selectedAccount.balance < paymentAmount
    }
    
    var body: some View {
        ScrollView {
            PaymentBillHeader(bill: bill)
            
            PaymentDetailsCard(
                bill: bill,
                selectedAccount: $selectedAccount,
                paymentAmount: $paymentAmount,
                showAmountPicker: $showAmountPicker
            )
            
            PaymentDateCard(paymentDate: $paymentDate)
            
            if accountHasInsufficientFunds {
                InsufficientFundsWarning()
            }
            
            PaymentConfirmButton(
                isProcessing: isProcessing,
                isDisabled: accountHasInsufficientFunds || isProcessing,
                onConfirm: onConfirm
            )
        }
    }
}

#Preview("Default") {
    @Previewable @State var paymentDate = Date()

    let bill = Bill.samples[0]
    
    PaymentConfirmationContentView(
        paymentDate: $paymentDate,
        bill: bill,
        isProcessing: false
    ) {
    }
    .padding(.horizontal)
}

#Preview("Insufficient Funds Warning") {
    @Previewable @State var paymentDate = Date()

    let bill = Bill.samples[3]
    
    PaymentConfirmationContentView(
        paymentDate: $paymentDate,
        bill: bill,
        isProcessing: false
    ) {
    }
    .padding(.horizontal)
}
