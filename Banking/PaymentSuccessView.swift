//
//  PaymentSuccessView.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// Displays the payment success message.
struct PaymentSuccessView: View {
    let bill: Bill
    let paymentDate: Date
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.green)
            
            Text("Payment Successful")
                .font(.title)
                .bold()
            
            Text("Your payment to \(bill.payee) has been scheduled for \(paymentDate.formatted(date: .long, time: .omitted)).")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                onDismiss()
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
}
