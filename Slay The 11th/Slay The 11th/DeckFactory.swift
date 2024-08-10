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
//    8 Attack Cards
    Card(id: UUID(), name: "Attack", description: "Deal 3 damage.", cardType: .attack, value: 3, image: Image(systemName: "flame.fill")),
    Card(id: UUID(), name: "Attack", description: "Deal 3 damage.", cardType: .attack, value: 3, image: Image(systemName: "flame.fill")),
    Card(id: UUID(), name: "Attack", description: "Deal 3 damage.", cardType: .attack, value: 3, image: Image(systemName: "flame.fill")),
    Card(id: UUID(), name: "Attack", description: "Deal 3 damage.", cardType: .attack, value: 3, image: Image(systemName: "flame.fill")),
    Card(id: UUID(), name: "Attack", description: "Deal 3 damage.", cardType: .attack, value: 3, image: Image(systemName: "flame.fill")),
    Card(id: UUID(), name: "Attack", description: "Deal 3 damage.", cardType: .attack, value: 3, image: Image(systemName: "flame.fill")),
    Card(id: UUID(), name: "Attack", description: "Deal 3 damage.", cardType: .attack, value: 3, image: Image(systemName: "flame.fill")),
    Card(id: UUID(), name: "Attack", description: "Deal 3 damage.", cardType: .attack, value: 3, image: Image(systemName: "flame.fill")),
//    6 Defense Cards
    Card(id: UUID(), name: "Defense", description: "Gain 2 defense.", cardType: .defense, value: 2, image: Image(systemName: "shield.fill")),
    Card(id: UUID(), name: "Defense", description: "Gain 2 defense.", cardType: .defense, value: 2, image: Image(systemName: "shield.fill")),
    Card(id: UUID(), name: "Defense", description: "Gain 2 defense.", cardType: .defense, value: 2, image: Image(systemName: "shield.fill")),
    Card(id: UUID(), name: "Defense", description: "Gain 2 defense.", cardType: .defense, value: 2, image: Image(systemName: "shield.fill")),
    Card(id: UUID(), name: "Defense", description: "Gain 2 defense.", cardType: .defense, value: 2, image: Image(systemName: "shield.fill")),
    Card(id: UUID(), name: "Defense", description: "Gain 2 defense.", cardType: .defense, value: 2, image: Image(systemName: "shield.fill")),
//    4 Poison Cards
    Card(id: UUID(), name: "Poison", description: "Inflict 2 poison.", cardType: .poison, value: 2, image: Image(systemName: "drop.fill")),
    Card(id: UUID(), name: "Poison", description: "Inflict 2 poison.", cardType: .poison, value: 2, image: Image(systemName: "drop.fill")),
    Card(id: UUID(), name: "Poison", description: "Inflict 2 poison.", cardType: .poison, value: 2, image: Image(systemName: "drop.fill")),
    Card(id: UUID(), name: "Poison", description: "Inflict 2 poison.", cardType: .poison, value: 2, image: Image(systemName: "drop.fill")),
//    3 Silence Cards
    Card(id: UUID(), name: "Silence", description: "Silence enemy.", cardType: .silence, value: 1, image: Image(systemName: "speaker.slash.fill")),
    Card(id: UUID(), name: "Silence", description: "Silence enemy.", cardType: .silence, value: 1, image: Image(systemName: "speaker.slash.fill")),
    Card(id: UUID(), name: "Silence", description: "Silence enemy.", cardType: .silence, value: 1, image: Image(systemName: "speaker.slash.fill")),
//    3 Draw Cards
    Card(id: UUID(), name: "Draw Cards", description: "Draw 2 cards.", cardType: .drawCards, value: 2, image: Image(systemName: "rectangle.stack.fill")),
    Card(id: UUID(), name: "Draw Cards", description: "Draw 2 cards.", cardType: .drawCards, value: 2, image: Image(systemName: "rectangle.stack.fill")),
    Card(id: UUID(), name: "Draw Cards", description: "Draw 2 cards.", cardType: .drawCards, value: 2, image: Image(systemName: "rectangle.stack.fill")),
  ]
}

func sample3CardDeck() -> [Card] {
  return [
    Card(id: UUID(), name: "Attack", description: "Deal 3 damage.", cardType: .attack, value: 3, image: Image(systemName: "flame.fill")),
    Card(id: UUID(), name: "Attack", description: "Deal 3 damage.", cardType: .attack, value: 3, image: Image(systemName: "flame.fill")),
    Card(id: UUID(), name: "Attack", description: "Deal 3 damage.", cardType: .attack, value: 3, image: Image(systemName: "flame.fill")),
  ]
}
