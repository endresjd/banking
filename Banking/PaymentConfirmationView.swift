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
    @Environment(\.dismiss) private var dismiss
    @State private var isProcessing = false
    @State private var showSuccess = false
    
    var hasInsufficientFunds: Bool {
        accountBalance < bill.amount
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if showSuccess {
                    successView
                } else {
                    confirmationContent
                }
            }
            .padding()
            .navigationTitle("Confirm Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    }
                    .disabled(isProcessing || showSuccess)
                }
            }
        }
    }
    
    @ViewBuilder
    private var confirmationContent: some View {
        VStack(spacing: 16) {
            Image(systemName: bill.category.icon)
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            
            Text(bill.payee)
                .font(.title2)
                .bold()
            
            Text(bill.category.rawValue)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 32)
        
        Spacer()
        
        VStack(alignment: .leading, spacing: 16) {
            PaymentDetailRow(label: "Payment Amount", value: bill.amount, format: .currency(code: "USD"))
            
            Divider()
            
            PaymentDetailRow(label: "Current Balance", value: accountBalance, format: .currency(code: "USD"))
            
            PaymentDetailRow(
                label: "Balance After Payment",
                value: accountBalance - bill.amount,
                format: .currency(code: "USD"),
                isWarning: hasInsufficientFunds
            )
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        
        if hasInsufficientFunds {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                
                Text("Insufficient funds")
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.orange.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        
        Button {
            processPayment()
        } label: {
            Group {
                if isProcessing {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Confirm Payment")
                        .bold()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(hasInsufficientFunds || isProcessing)
    }
    
    @ViewBuilder
    private var successView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.green)
            
            Text("Payment Successful")
                .font(.title)
                .bold()
            
            Text("Your payment to \(bill.payee) has been processed.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .bold()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
    
    private func processPayment() {
        isProcessing = true
        
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            
            onConfirm()
            showSuccess = true
            isProcessing = false
            
            try? await Task.sleep(for: .seconds(1.5))
            
            dismiss()
        }
    }
}

/// Displays a row of payment details.
struct PaymentDetailRow: View {
    let label: String
    let value: Double
    let format: FloatingPointFormatStyle<Double>.Currency
    var isWarning: Bool = false
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value, format: format)
                .bold()
                .foregroundStyle(isWarning ? .red : .primary)
        }
    }
}

#Preview("Sufficient Funds") {
    PaymentConfirmationView(
        bill: Bill.samples[0],
        accountBalance: .constant(5000.00),
        onConfirm: {}
    )
}

#Preview("Insufficient Funds") {
    PaymentConfirmationView(
        bill: Bill.samples[3],
        accountBalance: .constant(500.00),
        onConfirm: {}
    )
}
