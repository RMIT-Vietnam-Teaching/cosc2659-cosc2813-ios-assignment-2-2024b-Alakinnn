import SwiftUI
import Observation

@Observable class StageViewModel {
  var availableDeck: [Card] = createStaticDeck() // Cards available to draw
  var discardedDeck: [Card] = [] // Cards that have been used
  var playerHand: [Card] = [] // Cards currently in the player's hand
  var player: Player
  var selectedCard: Card? = nil
  var isStageCompleted: Bool = false
  var enemies: [Enemy] = []
  var currentStage: Int = 1
  var isPlayerTurn: Bool = true  // Track if it's the player's turn
  var difficulty: Difficulty
  var isShowingRewards: Bool = false
  var selectedReward: Reward? = nil

  init(difficulty: Difficulty, player: Player) {
      self.player = player
    self.difficulty = difficulty
      self.enemies = EnemyFactory.createEnemies(for: difficulty, stage: currentStage)
      startPlayerTurn()
  }

  // Start player's turn
  func startPlayerTurn() {
      isPlayerTurn = true
      resetPlayerTempHP() // Reset temp HP at the start of the player's turn
      drawInitialHand()
  }

  // Reset player's temporary HP
  private func resetPlayerTempHP() {
      player.tempHP = 0
  }

  // End player's turn
  func endPlayerTurn() {
      isPlayerTurn = false
      discardPlayerHand()
      applyPoisonEffects() // Apply poison effects to all enemies
      startEnemyTurn()
  }

  func checkIfStageCompleted() {
      if enemies.allSatisfy({ $0.curHp <= 0 }) {
        isStageCompleted = true
        player.tempHP = 0
        isShowingRewards = true
      }
  }

  func checkAndAdvanceStage() {
      if isStageCompleted {
          currentStage += 1

          let newEnemies = EnemyFactory.createEnemies(for: difficulty, stage: currentStage)
          if !newEnemies.isEmpty {
              enemies = newEnemies
              isStageCompleted = false
              startPlayerTurn() // Restart player's turn for the new stage
              print("Advancing to Stage \(currentStage)")
          } else {
              print("No more stages available. Game completed.")
          }
      }
  }
}
