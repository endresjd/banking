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
    
    /// The currently selected sort option.
    @State private var sortOption = BillSortOption.dueDate
    
    /// Whether to sort in ascending order.
    @State private var ascending = true
    
    /// The currently selected bill for payment.
    @State private var selectedBill: Bill?
    
    /// Returns the filtered and sorted list of bills.
    var filteredBills: [Bill] {
        let filtered = bills.filter {
            showPaidBills ? true : !$0.paid
        }
        
        return filtered.sorted { first, second in
            let comparison: Bool
            
            switch sortOption {
            case .dueDate:
                comparison = first.dueDate < second.dueDate
            case .payee:
                comparison = first.payee.localizedStandardCompare(second.payee) == .orderedAscending
            case .amount:
                comparison = first.amount < second.amount
            case .category:
                comparison = first.category.rawValue.localizedStandardCompare(second.category.rawValue) == .orderedAscending
            case .paid:
                comparison = !first.paid && second.paid
            }
            
            return ascending ? comparison : !comparison
        }
    }
    
    /// Returns the total amount of unpaid bills.
    var unpaidTotal: Decimal {
        bills
            .filter {
                !$0.paid
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
                        UnpaidTotalCard(unpaidTotal: unpaidTotal)
                    }
                }
                
                BillListSection(
                    bills: filteredBills,
                    showPaidBills: showPaidBills,
                    onBillTapped: { bill in
                        selectedBill = bill
                    }
                )
            }
            .navigationTitle("Banking")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    BillSortPicker(sortOption: $sortOption, ascending: $ascending)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    BillFilterButton(showPaidBills: $showPaidBills)
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
        
        bills[index].paid = true
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
