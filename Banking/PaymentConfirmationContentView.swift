//
//  PaymentConfirmationContentView.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// Displays the payment confirmation content with details and date picker.
struct PaymentConfirmationContentView: View {
    @Binding var paymentDate: Date
    let bill: Bill
    let accountBalance: Double
    let hasInsufficientFunds: Bool
    let isProcessing: Bool
    let onConfirm: () -> Void
    @State private var selectedAccount = Account.samples[0]
    
    private var accountHasInsufficientFunds: Bool {
        selectedAccount.balance < bill.amount
    }
    
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
                HStack {
                    Text("Account")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Menu {
                        ForEach(Account.samples) { account in
                            Button {
                                selectedAccount = account
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(account.name)
                                    Text(account.balance, format: .currency(code: "USD"))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(selectedAccount.name)
                                .foregroundStyle(.primary)
                            
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Divider()
                
                PaymentDetailRow(label: "Payment Amount", value: bill.amount, format: .currency(code: "USD"))
                
                Divider()
                
                PaymentDetailRow(label: "Current Balance", value: selectedAccount.balance, format: .currency(code: "USD"))
                
                PaymentDetailRow(
                    label: "Balance After Payment",
                    value: selectedAccount.balance - bill.amount,
                    format: .currency(code: "USD"),
                    isWarning: accountHasInsufficientFunds
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
            
            if accountHasInsufficientFunds {
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
            .disabled(accountHasInsufficientFunds || isProcessing)
            .padding(.bottom)
        }
    }
}
