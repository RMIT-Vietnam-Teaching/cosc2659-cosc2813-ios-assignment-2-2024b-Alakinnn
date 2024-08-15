import SwiftUI
import Observation

@Observable class StageViewModel {
    var deck: [Card] = createStaticDeck()
    var selectedCard: Card? = nil
    var isStageCompleted: Bool = false
    var enemies: [Enemy] = []
    var currentStage: Int = 1
  
    init(difficulty: Difficulty) {
        self.enemies = EnemyFactory.createEnemies(for: difficulty, stage: currentStage)
    }
    
    func selectCard(_ card: Card) {
        if selectedCard?.id == card.id {
            selectedCard = nil
        } else {
            selectedCard = card
        }
    }
    
  func applyCardToEnemy(at index: Int) {
      guard let card = selectedCard else {
          print("No card selected")
          return
      }

      guard index >= 0 && index < enemies.count else {
          print("Invalid enemy index")
          return
      }

      var enemy = enemies[index]

      switch card.cardType {
      case .attack:
          enemy.hp -= card.value
          print("Enemy \(enemy.name) takes \(card.value) damage. Remaining HP: \(enemy.hp)")

      case .poison:
          let debuff = Debuff(type: .poison, value: card.value, duration: 3)
          enemy.debuffEffects.append(debuff)
          print("Enemy \(enemy.name) is poisoned for \(card.value) damage per turn.")

      case .silence:
          let debuff = Debuff(type: .silence, value: card.value, duration: 1)
          enemy.debuffEffects.append(debuff)
          print("Enemy \(enemy.name) is silenced.")
      
      default:
          print("Unhandled card type: \(card.cardType)")
      }

    enemies[index] = enemy

      selectedCard = nil

      checkIfStageCompleted()
  }


  
  private func checkIfStageCompleted() {
          if enemies.allSatisfy({ $0.hp <= 0 }) {
              isStageCompleted = true
              // Notify the GameViewModel to advance the stage
              // gameViewModel?.checkAndAdvanceStage() // If you have a reference to GameViewModel
          }
      }
}

