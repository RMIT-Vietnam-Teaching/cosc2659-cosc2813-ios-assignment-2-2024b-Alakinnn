//
//  EnemyBody2D.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct EnemyBody2D: View {
    let offsetValue: CGFloat
    let width: CGFloat
    let height: CGFloat
    @Binding var selectedCard: Card? // Bind to selected card

    var body: some View {
        ZStack {
            Image(systemName: "person.fill") // Placeholder image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .offset(y: offsetValue)
          
          Rectangle()
              .fill(Color.black.opacity(0.001)) // Use a very transparent color to ensure the tap gesture is detected
              .frame(width: width * 0.8, height: height * 0.6) // Adjust size as needed
              .border(Color.red, width: 2) // Optional: visible border to see the hitbox
              .offset(y: offsetValue)
              .onTapGesture {
                  if let card = selectedCard {
                      print("Card \(card.name) used on enemy")
                      // Apply card effect to the enemy
                      selectedCard = nil // Deselect the card after use
                  } else {
                      print("No card selected")
                  }
              }
        }
    }
}


#Preview {
    EnemyBody2D(offsetValue: 0, width: 100, height: 200, selectedCard: .constant(nil))
}


