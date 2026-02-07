//
//  AmountPickerHeader.swift
//  Banking
//
//  Created by John Endres on 2/7/26.
//

import SwiftUI

/// Displays the header for the amount picker with title and due date.
struct AmountPickerHeader: View {
    /// The bill being paid.
    let bill: Bill
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Choose Amount")
                .font(.title2)
                .bold()
            
            Text("Make payments by \(bill.dueDate.formatted(date: .abbreviated, time: .omitted)).")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    AmountPickerHeader(bill: Bill.samples[0])
}
