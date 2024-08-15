import SwiftUI
import Observation

@Observable class StageViewModel {
    var availableDeck: [Card] = createStaticDeck() // Cards available to draw
    var discardedDeck: [Card] = [] // Cards that have been used
    var playerHand: [Card] = [] // Cards currently in the player's hand
    var selectedCard: Card? = nil
    var isStageCompleted: Bool = false
    var enemies: [Enemy] = []
    var currentStage: Int = 1

    init(difficulty: Difficulty) {
        self.enemies = EnemyFactory.createEnemies(for: difficulty, stage: currentStage)
        drawInitialHand()
    }
    
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

    // Apply a card to an enemy
  func applyCardToEnemy(at index: Int) {
          guard let card = selectedCard else {
              print("No card selected")
              return
          }

          // Ensure the index is valid
          guard index >= 0 && index < enemies.count else {
              print("Invalid enemy index")
              return
          }

          // Work directly with the enemy in the array
          var enemy = enemies[index]

          switch card.cardType {
          case .attack:
              enemy.hp -= card.value
              print("Enemy \(enemy.name) takes \(card.value) damage. Remaining HP: \(enemy.hp)")

          case .poison:
              addOrUpdateDebuff(on: &enemy, type: .poison, value: card.value, duration: 3)
              print("Enemy \(enemy.name) is poisoned for \(card.value) damage per turn.")

          case .silence:
              addOrUpdateDebuff(on: &enemy, type: .silence, value: card.value, duration: 1)
              print("Enemy \(enemy.name) is silenced.")

          default:
              print("Unhandled card type: \(card.cardType)")
          }

          // Update the enemy in the array
          enemies[index] = enemy

          // Move the used card to the discarded deck
          moveCardToDiscardedDeck(card)

          // Clear the selected card after applying
          selectedCard = nil

          // Check if the stage is completed after the attack
          checkIfStageCompleted()
      }

      // Add or update a debuff on the enemy
      private func addOrUpdateDebuff(on enemy: inout Enemy, type: DebuffType, value: Int, duration: Int) {
          if let index = enemy.debuffEffects.firstIndex(where: { $0.type == type }) {
              enemy.debuffEffects[index].value += value
              enemy.debuffEffects[index].duration = max(enemy.debuffEffects[index].duration, duration)
          } else {
              let debuff = Debuff(type: type, value: value, duration: duration)
              enemy.debuffEffects.append(debuff)
          }
      }
    
    // Move a card to the discarded deck
    func moveCardToDiscardedDeck(_ card: Card) {
        if let cardIndex = playerHand.firstIndex(where: { $0.id == card.id }) {
            let removedCard = playerHand.remove(at: cardIndex)
            discardedDeck.append(removedCard)
        }
    }
    
    private func checkIfStageCompleted() {
        if enemies.allSatisfy({ $0.hp <= 0 }) {
            isStageCompleted = true
            // Notify the GameViewModel to advance the stage
            // gameViewModel?.checkAndAdvanceStage() // If you have a reference to GameViewModel
        }
    }
}
