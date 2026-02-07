//
//  InsufficientFundsErrorBanner.swift
//  Banking
//
//  Created by John Endres on 2/7/26.
//

import SwiftUI

/// Displays an error banner when the account has insufficient funds for the minimum payment.
struct InsufficientFundsErrorBanner: View {
    /// The minimum due amount that cannot be covered.
    let minimumDueAmount: Decimal
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Insufficient Funds")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text("The selected account has insufficient funds to pay the minimum due amount of \(minimumDueAmount.formatted(.currency(code: "USD"))).")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                }
                
                Spacer()
            }
            .padding()
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

#Preview {
    InsufficientFundsErrorBanner(minimumDueAmount: 39.60)
}
