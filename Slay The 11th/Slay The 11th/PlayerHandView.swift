//
//  PlayerHandView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct PlayerHandView: View {
    @Binding var deck: [Card]
    @Binding var selectedCard: Card? // Bind to selected card
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(deck.indices, id: \.self) { index in
                            CardView(card: deck[index])
                                .padding()
                                .background(
                                    selectedCard?.id == deck[index].id ? Color.yellow.opacity(0.3) : Color.clear
                                )
                                .onTapGesture {
                                    if selectedCard?.id == deck[index].id {
                                        // If the card is already selected, deselect it
                                        selectedCard = nil
                                    } else {
                                        // Otherwise, select the card
                                        selectedCard = deck[index]
                                    }
                                }
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(8, for: .scrollContent)
                .scrollTargetBehavior(.paging)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.red)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -5)
        }
    }
}


#Preview {
    PlayerHandView(deck: .constant(createStaticDeck()), selectedCard: .constant(nil))
}
