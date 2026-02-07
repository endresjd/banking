//
//  UnpaidTotalCard.swift
//  Banking
//
//  Created by John Endres on 2/7/26.
//

import SwiftUI

/// Displays the total amount of unpaid bills.
struct UnpaidTotalCard: View {
    /// The total amount of unpaid bills.
    let unpaidTotal: Decimal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Total Unpaid")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text(unpaidTotal, format: .currency(code: "USD"))
                .font(.title)
                .bold()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    List {
        Section {
            UnpaidTotalCard(unpaidTotal: 1234.56)
        }
    }
}
