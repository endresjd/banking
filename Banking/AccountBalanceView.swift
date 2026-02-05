//
//  AccountBalanceView.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// Displays the account balance and quick actions.
struct AccountBalanceView: View {
    let balance: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Available Balance")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(balance, format: .currency(code: "USD"))
                .font(.system(size: 40, weight: .bold))
            
            HStack(spacing: 16) {
                BalanceStatusIndicator(
                    icon: "checkmark.circle.fill",
                    text: "Checking Account",
                    color: .green
                )
                
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [.blue, .blue.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

/// Displays a small status indicator with icon and text.
struct BalanceStatusIndicator: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
            
            Text(text)
                .font(.caption)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(color.opacity(0.2))
        .clipShape(Capsule())
    }
}

#Preview {
    AccountBalanceView(balance: 5432.50)
        .padding()
}
