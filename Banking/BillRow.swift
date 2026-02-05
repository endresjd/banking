//
//  BillRow.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// Displays a single bill in a list format.
struct BillRow: View {
    let bill: Bill
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: bill.category.icon)
                .font(.title2)
                .foregroundStyle(bill.isPaid ? .green : .blue)
                .frame(width: 40, height: 40)
                .background(bill.isPaid ? Color.green.opacity(0.1) : Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(bill.payee)
                    .font(.headline)
                
                Text(bill.category.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(bill.amount, format: .currency(code: "USD"))
                    .font(.headline)
                    .foregroundStyle(bill.isPaid ? .secondary : .primary)
                
                Text(bill.dueDate, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if bill.isPaid {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.title3)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview("Unpaid Bill") {
    BillRow(bill: Bill.samples[0])
        .padding()
}

#Preview("Paid Bill") {
    BillRow(bill: Bill.samples[5])
        .padding()
}
