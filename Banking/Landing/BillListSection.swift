//
//  BillListSection.swift
//  Banking
//
//  Created by John Endres on 2/7/26.
//

import SwiftUI

/// Displays a section of bills with a header.
struct BillListSection: View {
    /// The filtered list of bills to display.
    let bills: [Bill]
    
    /// Indicates whether paid bills are shown.
    let showPaidBills: Bool
    
    /// Callback when a bill is tapped.
    let onBillTapped: (Bill) -> Void
    
    var body: some View {
        Section {
            ForEach(bills) { bill in
                Button {
                    if !bill.paid {
                        onBillTapped(bill)
                    }
                } label: {
                    BillRow(bill: bill)
                }
                .buttonStyle(.plain)
                .disabled(bill.paid)
            }
        } header: {
            Text(showPaidBills ? "All Bills" : "Upcoming Bills")
        }
    }
}

#Preview {
    List {
        BillListSection(
            bills: Bill.samples,
            showPaidBills: false,
            onBillTapped: { _ in }
        )
    }
}
