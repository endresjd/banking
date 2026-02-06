//
//  PaymentConfirmationView.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// Displays a confirmation sheet for paying a bill.
struct PaymentConfirmationView: View {
    /// The current account balance.
    @Binding var accountBalance: Decimal
    
    /// The bill to be paid.
    let bill: Bill
    
    /// Closure called when the payment is confirmed.
    let onConfirm: () -> Void
    
    /// Closure called when the view is dismissed.
    let onDismiss: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    /// Indicates whether a payment is currently being processed.
    @State private var isProcessing = false
    
    /// Indicates whether the success view should be shown.
    @State private var showSuccess = false
    
    /// The selected date for the payment.
    @State private var paymentDate = Date()
    
    /// Indicates whether the account balance is insufficient to cover the bill amount.
    var hasInsufficientFunds: Bool {
        accountBalance < bill.amount
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if showSuccess {
                    PaymentSuccessView(
                        bill: bill,
                        paymentDate: paymentDate
                    ) {
                        onDismiss()
                        dismiss()
                    }
                } else {
                    PaymentConfirmationContentView(
                        paymentDate: $paymentDate,
                        bill: bill,
                        accountBalance: accountBalance,
                        hasInsufficientFunds: hasInsufficientFunds,
                        isProcessing: isProcessing
                    ) {
                        processPayment()
                    }
                }
            }
            .padding()
            .navigationTitle("Confirm Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !showSuccess {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .cancel) {
                            onDismiss()
                            dismiss()
                        }
                        .disabled(isProcessing)
                    }
                }
            }
            .interactiveDismissDisabled(showSuccess)
        }
    }
    
    /// Processes the payment with a simulated delay and transitions to the success state.
    private func processPayment() {
        isProcessing = true
        
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            
            onConfirm()
            showSuccess = true
            isProcessing = false
        }
    }
}

#Preview("Sufficient Funds") {
    PaymentConfirmationView(
        accountBalance: .constant(5000.00),
        bill: Bill.samples[0],
        onConfirm: {
        },
        onDismiss: {
        }
    )
}

#Preview("Insufficient Funds") {
    PaymentConfirmationView(
        accountBalance: .constant(500.00),
        bill: Bill.samples[3],
        onConfirm: {
        },
        onDismiss: {
        }
    )
}
