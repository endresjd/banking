//
//  AccountSelectorRow.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// A row that allows selecting an account from a menu.
struct AccountSelectorRow: View {
    /// The currently selected account.
    @Binding var selectedAccount: Account
    
    var body: some View {
        HStack {
            Text("Account")
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Menu {
                ForEach(Account.samples) { account in
                    Button {
                        selectedAccount = account
                    } label: {
                        VStack(alignment: .leading) {
                            Text(account.name)
                            Text(account.balance, format: .currency(code: "USD"))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(selectedAccount.name)
                        .foregroundStyle(.primary)
                    
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedAccount = Account.samples[0]
    
    AccountSelectorRow(selectedAccount: $selectedAccount)
        .padding()
}
