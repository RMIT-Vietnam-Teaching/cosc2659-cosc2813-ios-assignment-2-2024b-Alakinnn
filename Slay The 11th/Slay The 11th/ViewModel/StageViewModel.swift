//
//  StageViewModel.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 11/08/2024.
//

import Foundation
import SwiftUI
import Observation

@Observable
class StageViewModel {
    var deck: [Card] = createStaticDeck()
    var selectedCard: Card? = nil
    
    func selectCard(_ card: Card) {
        if selectedCard?.id == card.id {
            selectedCard = nil
        } else {
            selectedCard = card
        }
    }
    
    func applyCardToEnemy() {
        if let card = selectedCard {
            print("Card used on enemy ")
            selectedCard = nil
        } else {
            print("No card selected")
        }
    }
}
