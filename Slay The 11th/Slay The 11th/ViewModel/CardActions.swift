/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 21/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

import Foundation

extension StageViewModel {
  // Draw initial hand (e.g., 5 cards)
  func drawInitialHand() {
    if (mode == .regular) {
      for _ in 0..<5 {
          drawCard()
      }
    } else {
      for card in availableDeck.prefix(5) {
       drawCardTutorialMode(card: card)
     }
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
        AudioManager.shared.queueSFX("drawSfx")
      }
  }
  
  // Draw a specific card in tutorial mode with the drawing effect
  func drawCardTutorialMode(card: Card) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          self.playerHand.append(card)
          AudioManager.shared.queueSFX("drawSfx")
      }
  }
  
  // Reshuffle the discared deck into the available deck after the stage ends
  func reshuffleAllCardsIntoAvailableDeckAfterStageEnds() {
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
