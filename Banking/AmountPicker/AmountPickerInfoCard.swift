//
//  AmountPickerInfoCard.swift
//  Banking
//
//  Created by John Endres on 2/7/26.
//

import SwiftUI

/// Displays informational text and action buttons for payment options.
struct AmountPickerInfoCard: View {
    var body: some View {
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
    }
}

#Preview {
    AmountPickerInfoCard()
}
