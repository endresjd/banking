//
//  PaymentConfirmationContentView.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// Displays the payment confirmation content with details and date picker.
struct PaymentConfirmationContentView: View {
    let bill: Bill
    let accountBalance: Double
    let hasInsufficientFunds: Bool
    @Binding var paymentDate: Date
    let isProcessing: Bool
    let onConfirm: () -> Void
    
    var body: some View {
        ScrollView {
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
            
            HStack {
                Text("Payment Date")
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                DatePicker(
                    "Select payment date",
                    selection: $paymentDate,
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .labelsHidden()
                .datePickerStyle(.compact)
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
                onConfirm()
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
            .padding(.bottom)
        }
    }
}
