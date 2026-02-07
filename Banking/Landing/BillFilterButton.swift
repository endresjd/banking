//
//  BillFilterButton.swift
//  Banking
//
//  Created by John Endres on 2/7/26.
//

import SwiftUI

/// A toolbar button that toggles the visibility of paid bills.
struct BillFilterButton: View {
    /// Indicates whether paid bills are shown.
    @Binding var showPaidBills: Bool
    
    var body: some View {
        Button {
            showPaidBills.toggle()
        } label: {
            Image(systemName: showPaidBills ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
        }
    }
}

#Preview {
    @Previewable @State var showPaidBills = false
    
    NavigationStack {
        List {
            Text("Sample Content")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                BillFilterButton(showPaidBills: $showPaidBills)
            }
        }
    }
}
