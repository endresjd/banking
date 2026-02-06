//
//  CurvedText.swift
//  Banking
//
//  Created by John Endres on 2/5/26.
//

import SwiftUI

/// A view that displays text along a curved path.
struct CurvedText: View {
    /// The text to display.
    let text: String
    
    /// The radius of the curve.
    let radius: CGFloat
    
    /// The total angle span in degrees.
    let angle: Double
    
    /// Whether the text follows the curve clockwise or counterclockwise.
    let clockwise: Bool
    
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            
            for (index, character) in text.enumerated() {
                let angle = angleForCharacter(at: index)
                let radians = angle * .pi / 180
                
                let x = center.x + radius * cos(radians)
                let y = center.y + radius * sin(radians)
                
                var textContext = context
                textContext.translateBy(x: x, y: y)
                
                // For top arc (counterclockwise), rotate so text reads left to right
                // For bottom arc (clockwise), rotate so text reads left to right
                if clockwise {
                    textContext.rotate(by: .degrees(angle - 90))
                } else {
                    textContext.rotate(by: .degrees(angle + 90))
                }
                
                let text = Text(String(character))
                
                textContext.draw(text, at: .zero)
            }
        }
        .frame(width: radius * 2 + 100, height: radius * 2 + 100)
    }
    
    /// Calculates the angle for a character at the given index.
    ///
    /// - Parameter index: The index of the character.
    /// - Returns: The angle in degrees.
    private func angleForCharacter(at index: Int) -> Double {
        let characterCount = text.count
        let totalAngle = angle
        let angleStep = totalAngle / Double(max(characterCount - 1, 1))
        
        let startAngle: Double
        if clockwise {
            // Bottom arc: center at 90 degrees (bottom), going left to right
            startAngle = 90 + (totalAngle / 2)
        } else {
            // Top arc: center at -90 degrees (top), going left to right
            startAngle = -90 - (totalAngle / 2)
        }
        
        if clockwise {
            return startAngle - (angleStep * Double(index))
        } else {
            return startAngle + (angleStep * Double(index))
        }
    }
}

#Preview {
    ZStack {
        Circle()
            .stroke(Color.gray, lineWidth: 2)
            .frame(width: 200, height: 200)
        
        CurvedText(
            text: "CARD BALANCE $316.98",
            radius: 60,
            angle: 180,
            clockwise: false
        )
        .font(.caption2)
    }
}
