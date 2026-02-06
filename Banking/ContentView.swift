//
//  ContentView.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

struct ContentView: View {
    /// The current account balance.
    @State private var accountBalance: Decimal = 5432.50
    
    /// The list of bills.
    @State private var bills = Bill.samples
    
    var body: some View {
        BillListView(
            bills: $bills,
            accountBalance: $accountBalance
        )
    }
}

#Preview {
    ContentView()
}
