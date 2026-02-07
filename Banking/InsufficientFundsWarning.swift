//
//  InsufficientFundsWarning.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// A warning banner displayed when there are insufficient funds.
struct InsufficientFundsWarning: View {
    var body: some View {
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
}

#Preview {
    InsufficientFundsWarning()
        .padding()
}
