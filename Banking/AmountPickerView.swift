//
//  AmountPickerView.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// A view for choosing payment amounts with a circular slider interface.
struct AmountPickerView: View {
    /// The bill to be paid.
    let bill: Bill
    
    /// The currently selected amount.
    @Binding var selectedAmount: Decimal
    
    /// Closure called when the payment is confirmed.
    let onConfirm: () -> Void
    
    /// Closure called when the view is dismissed.
    let onDismiss: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Choose Amount")
                        .font(.title2)
                        .bold()
                    
                    Text("Make payments by \(bill.dueDate.formatted(date: .abbreviated, time: .omitted)).")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                CircularAmountPicker(
                    selectedAmount: $selectedAmount,
                    minimumAmount: 0,
                    minimumDueAmount: bill.minimumDueAmount,
                    maximumAmount: bill.amount,
                    topLabel: "CARD BALANCE \(bill.amount.formatted(.currency(code: "USD")))",
                    bottomLabel: "NO INTEREST CHARGES"
                )
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Pay January Balance")
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Paying your monthly balance is recommended to help keep you financially healthy and avoid interest charges.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(spacing: 12) {
                        Button {
                        } label: {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                Text("Learn More")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.subheadline)
                        }
                        
                        Button {
                        } label: {
                            HStack {
                                Image(systemName: "keyboard.chevron.compact.down.fill")
                                Text("Other Amount")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.subheadline)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom)

                HStack(spacing: 16) {
                    Button {
                    } label: {
                        Text("Schedule")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    
                    Button {
                        onConfirm()
                        dismiss()
                    } label: {
                        Text("Pay \(selectedAmount.formatted(.currency(code: "USD")))")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                    .controlSize(.large)
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .padding(.top, 12)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        onDismiss()
                        dismiss()
                    }
                    .buttonStyle(.glass)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedAmount = Decimal(77.39)

    AmountPickerView(
        bill: Bill.samples[0],
        selectedAmount: $selectedAmount,
        onConfirm: {
        },
        onDismiss: {
        }
    )
}
