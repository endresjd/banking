//
//  BillListView.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// Displays a list of bills with filtering options.
struct BillListView: View {
    /// The list of bills to display.
    @Binding var bills: [Bill]
    
    /// The current account balance.
    @Binding var accountBalance: Decimal
    
    /// Indicates whether to show paid bills in the list.
    @State private var showPaidBills = false
    
    /// The currently selected bill for payment.
    @State private var selectedBill: Bill?
    
    /// Returns the filtered list of bills based on payment status and sorted by due date.
    var filteredBills: [Bill] {
        bills
            .filter {
                showPaidBills ? true : !$0.isPaid
            }
            .sorted {
                $0.dueDate < $1.dueDate
            }
    }
    
    /// Returns the total amount of unpaid bills.
    var unpaidTotal: Decimal {
        bills
            .filter {
                !$0.isPaid
            }
            .reduce(0) {
                $0 + $1.amount
            }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    AccountBalanceView(balance: accountBalance)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
                
                if !showPaidBills && unpaidTotal > 0 {
                    Section {
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
                
                Section {
                    ForEach(filteredBills) { bill in
                        Button {
                            if !bill.isPaid {
                                selectedBill = bill
                            }
                        } label: {
                            BillRow(bill: bill)
                        }
                        .buttonStyle(.plain)
                        .disabled(bill.isPaid)
                    }
                } header: {
                    Text(showPaidBills ? "All Bills" : "Upcoming Bills")
                }
            }
            .navigationTitle("Banking")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showPaidBills.toggle()
                    } label: {
                        Image(systemName: showPaidBills ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .fullScreenCover(item: $selectedBill) { bill in
                PaymentConfirmationView(
                    accountBalance: $accountBalance,
                    bill: bill,
                    onConfirm: {
                        payBill(bill)
                    }
                ) {
                    selectedBill = nil
                }
            }
        }
    }
    
    /// Marks a bill as paid and deducts the amount from the account balance.
    ///
    /// - Parameter bill: The bill to mark as paid.
    private func payBill(_ bill: Bill) {
        guard let index = bills.firstIndex(where: { $0.id == bill.id }) else {
            return
        }
        
        bills[index].isPaid = true
        accountBalance -= bill.amount
    }
}

#Preview {
    @Previewable @State var bills = Bill.samples
    @Previewable @State var accountBalance: Decimal = 5000.00

    BillListView(
        bills: $bills,
        accountBalance: $accountBalance
    )
}
