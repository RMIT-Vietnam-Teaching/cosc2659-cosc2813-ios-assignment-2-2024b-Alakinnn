//
//  MainGameView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct MainGameView: View {
    @State private var deck: [Card] = createStaticDeck()
    @State private var selectedCard: Card? = nil // Track the selected card

    var body: some View {
        VStack(spacing: 0) {
            EnemyZoneView(selectedCard: $selectedCard)
                .frame(height: UIScreen.main.bounds.height * 0.55)
            
            Spacer(minLength: 10)
            
            PlayerHandView(deck: $deck, selectedCard: $selectedCard)
                .frame(height: UIScreen.main.bounds.height * 0.35)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    MainGameView()
}

