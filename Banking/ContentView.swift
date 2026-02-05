//
//  ContentView.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

struct ContentView: View {
    @State private var accountBalance: Double = 5432.50
    @State private var bills: [Bill] = Bill.samples
    
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
