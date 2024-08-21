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
  
  // Reshuffle the discared deck into the available deck after the stage ends
  func reshuffleAllCardsIntoAvailableDeckAfterTurnEnds() {
    availableDeck.append(contentsOf: discardedDeck)
    availableDeck.append(contentsOf: playerHand)
    discardedDeck.removeAll()
    playerHand.removeAll()
  }
  
  // Reshuffle the discarded deck into the available deck if hands
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
  }
}
