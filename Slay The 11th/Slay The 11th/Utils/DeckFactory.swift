//
//  DeckFactory.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import Foundation
import SwiftUI

func createStaticDeck() -> [Card] {
  return [
    // 8 Attack Cards
    Card(id: UUID(), name: NSLocalizedString("card_attack_name", comment: "Attack"), description: NSLocalizedString("card_attack_description", comment: "Slash the enemy"), cardType: .attack, value: 3, imageName: "flame.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_attack_name", comment: "Attack"), description: NSLocalizedString("card_attack_description", comment: "Slash the enemy"), cardType: .attack, value: 3, imageName: "flame.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_attack_name", comment: "Attack"), description: NSLocalizedString("card_attack_description", comment: "Slash the enemy"), cardType: .attack, value: 3, imageName: "flame.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_attack_name", comment: "Attack"), description: NSLocalizedString("card_attack_description", comment: "Slash the enemy"), cardType: .attack, value: 3, imageName: "flame.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_attack_name", comment: "Attack"), description: NSLocalizedString("card_attack_description", comment: "Slash the enemy"), cardType: .attack, value: 3, imageName: "flame.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_attack_name", comment: "Attack"), description: NSLocalizedString("card_attack_description", comment: "Slash the enemy"), cardType: .attack, value: 3, imageName: "flame.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_attack_name", comment: "Attack"), description: NSLocalizedString("card_attack_description", comment: "Slash the enemy"), cardType: .attack, value: 3, imageName: "flame.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_attack_name", comment: "Attack"), description: NSLocalizedString("card_attack_description", comment: "Slash the enemy"), cardType: .attack, value: 3, imageName: "flame.fill"),

    // 6 Defense Cards
    Card(id: UUID(), name: NSLocalizedString("card_defense_name", comment: "Defense"), description: NSLocalizedString("card_defense_description", comment: "Shield yourself"), cardType: .defense, value: 2, imageName: "shield.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_defense_name", comment: "Defense"), description: NSLocalizedString("card_defense_description", comment: "Shield yourself"), cardType: .defense, value: 2, imageName: "shield.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_defense_name", comment: "Defense"), description: NSLocalizedString("card_defense_description", comment: "Shield yourself"), cardType: .defense, value: 2, imageName: "shield.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_defense_name", comment: "Defense"), description: NSLocalizedString("card_defense_description", comment: "Shield yourself"), cardType: .defense, value: 2, imageName: "shield.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_defense_name", comment: "Defense"), description: NSLocalizedString("card_defense_description", comment: "Shield yourself"), cardType: .defense, value: 2, imageName: "shield.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_defense_name", comment: "Defense"), description: NSLocalizedString("card_defense_description", comment: "Shield yourself"), cardType: .defense, value: 2, imageName: "shield.fill"),

    // 4 Poison Cards
    Card(id: UUID(), name: NSLocalizedString("card_poison_name", comment: "Poison"), description: NSLocalizedString("card_poison_description", comment: "Poison the enemy"), cardType: .poison, value: 2, imageName: "drop.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_poison_name", comment: "Poison"), description: NSLocalizedString("card_poison_description", comment: "Poison the enemy"), cardType: .poison, value: 2, imageName: "drop.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_poison_name", comment: "Poison"), description: NSLocalizedString("card_poison_description", comment: "Poison the enemy"), cardType: .poison, value: 2, imageName: "drop.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_poison_name", comment: "Poison"), description: NSLocalizedString("card_poison_description", comment: "Poison the enemy"), cardType: .poison, value: 2, imageName: "drop.fill"),

    // 3 Silence Cards
    Card(id: UUID(), name: NSLocalizedString("card_silence_name", comment: "Silence"), description: NSLocalizedString("card_silence_description", comment: "Silence the enemy"), cardType: .silence, value: 1, imageName: "speaker.slash.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_silence_name", comment: "Silence"), description: NSLocalizedString("card_silence_description", comment: "Silence the enemy"), cardType: .silence, value: 1, imageName: "speaker.slash.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_silence_name", comment: "Silence"), description: NSLocalizedString("card_silence_description", comment: "Silence the enemy"), cardType: .silence, value: 1, imageName: "speaker.slash.fill"),

    // 3 Draw Cards
    Card(id: UUID(), name: NSLocalizedString("card_draw_name", comment: "Draw Cards"), description: NSLocalizedString("card_draw_description", comment: "Draw more cards"), cardType: .drawCards, value: 2, imageName: "rectangle.stack.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_draw_name", comment: "Draw Cards"), description: NSLocalizedString("card_draw_description", comment: "Draw more cards"), cardType: .drawCards, value: 2, imageName: "rectangle.stack.fill"),
    Card(id: UUID(), name: NSLocalizedString("card_draw_name", comment: "Draw Cards"), description: NSLocalizedString("card_draw_description", comment: "Draw more cards"), cardType: .drawCards, value: 2, imageName: "rectangle.stack.fill"),
  ]
}


