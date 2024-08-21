//
//  CardActions.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 21/08/2024.
//

import Foundation

extension StageViewModel {
  // Draw initial hand (e.g., 5 cards)
  func drawInitialHand() {
      for _ in 0..<5 {
          drawCard()
      }
  }

  // Draw a card from the available deck to the player's hand
  func drawCard() {
      if availableDeck.isEmpty {
          reshuffleDiscardedDeck()
      }
      availableDeck.shuffle()
      if let card = availableDeck.popLast() {
          playerHand.append(card)
      }
  }
  
  // Reshuffle the discarded deck into the available deck
  func reshuffleDiscardedDeck() {
      availableDeck = discardedDeck.shuffled()
      discardedDeck.removeAll()
  }

  // Discard all cards in the player's hand
  func discardPlayerHand() {
      discardedDeck.append(contentsOf: playerHand)
      playerHand.removeAll()
  }
  
  // Move a card to the discarded deck
  func moveCardToDiscardedDeck(_ card: Card) {
      if let cardIndex = playerHand.firstIndex(where: { $0.id == card.id }) {
          let removedCard = playerHand.remove(at: cardIndex)
          discardedDeck.append(removedCard)
      }
  }
  
  // Update card values if it is user choice rewards  
  func updateCardValues() {
      // Update values for cards in availableDeck
      for index in availableDeck.indices {
          switch availableDeck[index].cardType {
          case .attack:
              availableDeck[index].currentValue = availableDeck[index].baseValue + player.attackBuff
          case .defense:
              availableDeck[index].currentValue = availableDeck[index].baseValue + player.shieldBuff
          default:
              availableDeck[index].currentValue = availableDeck[index].baseValue
          }
      }

      // Update values for cards in discardedDeck
      for index in discardedDeck.indices {
          switch discardedDeck[index].cardType {
          case .attack:
              discardedDeck[index].currentValue = discardedDeck[index].baseValue + player.attackBuff
          case .defense:
              discardedDeck[index].currentValue = discardedDeck[index].baseValue + player.shieldBuff
          default:
              discardedDeck[index].currentValue = discardedDeck[index].baseValue
          }
      }
  }
}
