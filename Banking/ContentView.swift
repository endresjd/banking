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
    
    var upcomingBills: [Bill] {
        bills
            .filter {
                !$0.isPaid
            }
            .sorted {
                $0.dueDate < $1.dueDate
            }
            .prefix(3)
            .map {
                $0
            }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    AccountBalanceView(balance: accountBalance)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Upcoming Bills")
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                            
                            NavigationLink {
                                BillListView(
                                    bills: $bills,
                                    accountBalance: $accountBalance
                                )
                            } label: {
                                Text("See All")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)
                        
                        if upcomingBills.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundStyle(.green)
                                
                                Text("All bills paid!")
                                    .font(.headline)
                                
                                Text("You have no upcoming bills.")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(Array(upcomingBills.enumerated()), id: \.element.id) { index, bill in
                                    NavigationLink {
                                        BillListView(
                                            bills: $bills,
                                            accountBalance: $accountBalance
                                        )
                                    } label: {
                                        BillRow(bill: bill)
                                            .padding(.horizontal)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    if index < upcomingBills.count - 1 {
                                        Divider()
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(.top)
            }
            .navigationTitle("Banking")
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    ContentView()
}
