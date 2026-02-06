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
    
    /// The current account balance.
    let accountBalance: Decimal
    
    /// Indicates whether the account has insufficient funds.
    let hasInsufficientFunds: Bool
    
    /// Indicates whether a payment is currently being processed.
    let isProcessing: Bool
    
    /// Closure called when the payment is confirmed.
    let onConfirm: () -> Void
    
    /// The currently selected account for payment.
    @State private var selectedAccount = Account.samples[0]
    
    /// The amount to be paid (editable by the user).
    @State private var paymentAmount: Decimal
    
    /// The text representation of the payment amount.
    @State private var amountText = ""
    
    /// Creates a new payment confirmation content view.
    ///
    /// - Parameters:
    ///   - paymentDate: Binding to the selected payment date.
    ///   - bill: The bill to be paid.
    ///   - accountBalance: The current account balance.
    ///   - hasInsufficientFunds: Whether the account has insufficient funds.
    ///   - isProcessing: Whether a payment is currently being processed.
    ///   - onConfirm: Closure called when the payment is confirmed.
    init(
        paymentDate: Binding<Date>,
        bill: Bill,
        accountBalance: Decimal,
        hasInsufficientFunds: Bool,
        isProcessing: Bool,
        onConfirm: @escaping () -> Void
    ) {
        self._paymentDate = paymentDate
        self.bill = bill
        self.accountBalance = accountBalance
        self.hasInsufficientFunds = hasInsufficientFunds
        self.isProcessing = isProcessing
        self.onConfirm = onConfirm
        self._paymentAmount = State(initialValue: bill.amount)
        self._amountText = State(initialValue: bill.amount.formatted(.number.precision(.fractionLength(2))))
    }
    
    /// Indicates whether the selected account has insufficient funds for the payment amount.
    private var accountHasInsufficientFunds: Bool {
        selectedAccount.balance < paymentAmount
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
                
                HStack {
                    Text("Payment Amount")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    TextField(
                        "Amount",
                        text: $amountText
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .bold()
                    .onChange(of: amountText) { _, newValue in
                        if let decimal = Decimal(string: newValue) {
                            paymentAmount = decimal
                        }
                    }
                    .frame(width: 120)
                }
                
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
