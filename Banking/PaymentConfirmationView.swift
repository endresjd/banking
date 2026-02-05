//
//  PaymentConfirmationView.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// Displays a confirmation sheet for paying a bill.
struct PaymentConfirmationView: View {
    let bill: Bill
    @Binding var accountBalance: Double
    let onConfirm: () -> Void
    let onDismiss: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var isProcessing = false
    @State private var showSuccess = false
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
                        paymentDate: paymentDate,
                        onDismiss: {
                            onDismiss()
                            dismiss()
                        }
                    )
                } else {
                    PaymentConfirmationContentView(
                        bill: bill,
                        accountBalance: accountBalance,
                        hasInsufficientFunds: hasInsufficientFunds,
                        paymentDate: $paymentDate,
                        isProcessing: isProcessing,
                        onConfirm: {
                            processPayment()
                        }
                    )
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
        bill: Bill.samples[0],
        accountBalance: .constant(5000.00),
        onConfirm: {
        },
        onDismiss: {
        }
    )
}

#Preview("Insufficient Funds") {
    PaymentConfirmationView(
        bill: Bill.samples[3],
        accountBalance: .constant(500.00),
        onConfirm: {
        },
        onDismiss: {
        }
    )
}
