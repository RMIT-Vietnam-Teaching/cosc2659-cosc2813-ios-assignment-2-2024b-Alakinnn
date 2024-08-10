//
//  PlayerHandView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct PlayerHandView: View {
    @State private var deck: [Card] = createStaticDeck()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(deck) { card in
                            CardView(card: card)
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
    PlayerHandView()
}
