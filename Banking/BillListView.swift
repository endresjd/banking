//
//  BillListView.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// Displays a list of bills with filtering options.
struct BillListView: View {
    @Binding var bills: [Bill]
    @Binding var accountBalance: Double
    @State private var showPaidBills = false
    @State private var selectedBill: Bill?
    
    var filteredBills: [Bill] {
        bills
            .filter {
                showPaidBills ? true : !$0.isPaid
            }
            .sorted {
                $0.dueDate < $1.dueDate
            }
    }
    
    var unpaidTotal: Double {
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
            .sheet(item: $selectedBill) { bill in
                PaymentConfirmationView(
                    bill: bill,
                    accountBalance: $accountBalance,
                    onConfirm: {
                        payBill(bill)
                    }
                )
            }
        }
    }
    
    private func payBill(_ bill: Bill) {
        guard let index = bills.firstIndex(where: { $0.id == bill.id }) else {
            return
        }
        
        bills[index].isPaid = true
        accountBalance -= bill.amount
        selectedBill = nil
    }
}

#Preview {
    BillListView(
        bills: .constant(Bill.samples),
        accountBalance: .constant(5000.00)
    )
}
