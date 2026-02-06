//
//  CircularAmountPicker.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// A circular slider for selecting payment amounts.
struct CircularAmountPicker: View {
    /// The currently selected amount.
    @Binding var selectedAmount: Decimal
    
    /// The minimum amount that can be selected.
    let minimumAmount: Decimal
    
    /// The minimum due amount that must be paid.
    let minimumDueAmount: Decimal
    
    /// The maximum amount that can be selected.
    let maximumAmount: Decimal
    
    /// The label to display at the top of the circle.
    let topLabel: String
    
    /// The label to display at the bottom of the circle.
    let bottomLabel: String
    
    @State private var dragAngle: Double = 0
    @State private var isDragging = false
    
    private let circleSize: CGFloat = 280
    private let strokeWidth: CGFloat = 24
    
    /// The progress value from 0 to 1 representing the selected amount.
    private var progress: Double {
        guard maximumAmount > minimumAmount else {
            return 0
        }
        
        let range = maximumAmount - minimumAmount
        let current = selectedAmount - minimumAmount
        let ratio = current / range
        
        return Double("\(ratio)") ?? 0
    }
    
    /// The angle in degrees for the progress arc (0 to 360).
    private var progressAngle: Double {
        progress * 360
    }
    
    /// The progress value for the minimum due amount (0 to 1).
    private var minimumDueProgress: Double {
        let range = maximumAmount - minimumAmount
        let current = minimumDueAmount - minimumAmount
        let ratio = current / range
        
        return Double("\(ratio)") ?? 0
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(
                    Color(.systemGray5),
                    lineWidth: strokeWidth
                )
                .frame(width: circleSize, height: circleSize)
            
            // Progress arc with rounded cap
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.green,
                    style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round)
                )
                .frame(width: circleSize, height: circleSize)
                .rotationEffect(.degrees(-90))
            
            // Top label (curved like a frown - arc bending down)
            CurvedText(
                text: topLabel,
                radius: circleSize / 2 - 25,
                angle: 85,
                clockwise: false
            )
            .font(.system(size: 10, weight: .regular))
            .foregroundStyle(.secondary)
            
            // Center amount
            VStack(spacing: 4) {
                Text(selectedAmount, format: .currency(code: "USD"))
                    .font(.system(size: 48, weight: .semibold))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
            
            // Bottom label (curved like a smile - arc bending up)
            CurvedText(
                text: bottomLabel,
                radius: circleSize / 2 - 25,
                angle: 85,
                clockwise: true
            )
            .font(.system(size: 10, weight: .regular))
            .foregroundStyle(.secondary)
            
            // Minimum due indicator (small filled circle)
            Circle()
                .fill(Color.white)
                .frame(width: 12, height: 12)
                .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                .offset(
                    x: cos((minimumDueProgress * 360 - 90) * .pi / 180) * circleSize / 2,
                    y: sin((minimumDueProgress * 360 - 90) * .pi / 180) * circleSize / 2
                )
            
            // Full payment indicator (small filled circle at top)
            Circle()
                .fill(Color.white)
                .frame(width: 12, height: 12)
                .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                .offset(x: 0, y: -circleSize / 2)
            
            // End handle (at progress point with checkmark)
            Circle()
                .fill(Color.white)
                .frame(width: strokeWidth + 8, height: strokeWidth + 8)
                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 1)
                .overlay(
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.green)
                )
                .offset(x: cos((progressAngle - 90) * .pi / 180) * circleSize / 2,
                       y: sin((progressAngle - 90) * .pi / 180) * circleSize / 2)
                .gesture(
                    DragGesture(coordinateSpace: .named("circularPicker"))
                        .onChanged { value in
                            isDragging = true
                            updateAmount(for: value.location)
                        }
                        .onEnded { _ in
                            isDragging = false
                        }
                )
        }
        .frame(width: circleSize + 100, height: circleSize + 100)
        .coordinateSpace(name: "circularPicker")
    }
    
    /// Updates the selected amount based on the drag location.
    ///
    /// - Parameter location: The current drag location.
    private func updateAmount(for location: CGPoint) {
        let center = CGPoint(x: (circleSize + 100) / 2, y: (circleSize + 100) / 2)
        let deltaX = location.x - center.x
        let deltaY = location.y - center.y
        
        var angle = atan2(deltaY, deltaX) * 180 / .pi
        angle += 90
        
        if angle < 0 {
            angle += 360
        }
        
        // Calculate the angle for minimum due amount
        let totalRange = maximumAmount - minimumAmount
        let minimumDueProgress = totalRange > 0 ? Double("\((minimumDueAmount - minimumAmount) / totalRange)") ?? 0 : 0
        let minimumDueAngle = minimumDueProgress * 360
        
        // Only clamp in the narrow dead zone at the top (355° to minimum due angle)
        if angle > 355 || angle < minimumDueAngle {
            // We're in the dead zone
            // Use the previous position to determine which way to clamp
            let currentAngle = progressAngle
            
            if currentAngle < 180 {
                // Was on the right side, snap to minimum due
                angle = minimumDueAngle
            } else {
                // Was on the left side, snap to 360
                angle = 360
            }
        }
        
        let newProgress = angle / 360
        let range = maximumAmount - minimumAmount
        let progressDecimal = Decimal(newProgress)
        let amount = minimumAmount + (progressDecimal * range)
        
        selectedAmount = min(max(amount, minimumAmount), maximumAmount)
    }
}

#Preview {
    @Previewable @State var selectedAmount: Decimal = 277.39

    CircularAmountPicker(
        selectedAmount: $selectedAmount,
        minimumAmount: 0,
        minimumDueAmount: 39.60,
        maximumAmount: 316.98,
        topLabel: "CARD BALANCE $316.98",
        bottomLabel: "NO INTEREST CHARGES"
    )
}

