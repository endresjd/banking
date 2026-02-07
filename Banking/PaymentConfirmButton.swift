//
//  PaymentConfirmButton.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// A button for confirming a payment with loading state.
struct PaymentConfirmButton: View {
    /// Indicates whether a payment is currently being processed.
    let isProcessing: Bool
    
    /// Indicates whether the button should be disabled.
    let isDisabled: Bool
    
    /// Closure called when the button is tapped.
    let onConfirm: () -> Void
    
    var body: some View {
        Button {
            onConfirm()
        } label: {
            Group {
                if isProcessing {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Confirm Payment")
                        .bold()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(isDisabled)
        .padding(.bottom)
    }
}

#Preview {
    VStack(spacing: 16) {
        PaymentConfirmButton(
            isProcessing: false,
            isDisabled: false
        ) {
        }
        
        PaymentConfirmButton(
            isProcessing: true,
            isDisabled: true
        ) {
        }
        
        PaymentConfirmButton(
            isProcessing: false,
            isDisabled: true
        ) {
        }
    }
    .padding()
}
