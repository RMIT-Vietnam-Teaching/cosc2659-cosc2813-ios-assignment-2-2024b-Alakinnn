//
//  StageViewModel.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 11/08/2024.
//

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
  var currentStage: Int = 3
  var isPlayerTurn: Bool = true  // Track if it's the player's turn
  var difficulty: Difficulty
  var isShowingRewards: Bool = false
  var selectedReward: Reward? = nil
  var isGameOver: Bool = false

  init(difficulty: Difficulty, player: Player = Player(hp: 44)) {
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
      calculateEnemyIntentions()
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
        currentStage += 1
      }
  }

  func checkAndAdvanceStage() {
      if isStageCompleted {
        enemies.removeAll()
        let newEnemies = EnemyFactory.createEnemies(for: difficulty, stage: currentStage)
        print(newEnemies)

          if !newEnemies.isEmpty {
              enemies = newEnemies
              isStageCompleted = false
              startPlayerTurn()
              print("Advancing to Stage \(currentStage)")
          } else {
              print("No more stages available. Game completed.")
          }
      }
  }
  
  func gameOver() {
    isGameOver = true
  }
  
  // Serialization method
      func toDictionary() -> [String: Any] {
          return [
              "availableDeck": availableDeck.map { $0.toDictionary() }, 
              "discardedDeck": discardedDeck.map { $0.toDictionary() },
              "playerHand": playerHand.map { $0.toDictionary() },
              "player": player.toDictionary(),
              "currentStage": currentStage,
              "isPlayerTurn": isPlayerTurn,
              "isStageCompleted": isStageCompleted,
              "enemies": enemies.map { $0.toDictionary() },
              "difficulty": difficulty.rawValue,
              "isShowingRewards": isShowingRewards,
              "selectedReward": selectedReward?.toDictionary() ?? [:],
              "isGameOver": isGameOver
          ]
      }

      // Deserialization method
      static func fromDictionary(_ dictionary: [String: Any], difficulty: Difficulty) -> StageViewModel? {
          guard
              let availableDeckData = dictionary["availableDeck"] as? [[String: Any]],
              let discardedDeckData = dictionary["discardedDeck"] as? [[String: Any]],
              let playerHandData = dictionary["playerHand"] as? [[String: Any]],
              let playerData = dictionary["player"] as? [String: Any],
              let currentStage = dictionary["currentStage"] as? Int,
              let isPlayerTurn = dictionary["isPlayerTurn"] as? Bool,
              let isStageCompleted = dictionary["isStageCompleted"] as? Bool,
              let enemiesData = dictionary["enemies"] as? [[String: Any]],
              let isShowingRewards = dictionary["isShowingRewards"] as? Bool,
              let isGameOver = dictionary["isGameOver"] as? Bool
          else { return nil }

          let availableDeck = availableDeckData.compactMap { Card.fromDictionary($0) }  // Assuming Card has a `fromDictionary` method
          let discardedDeck = discardedDeckData.compactMap { Card.fromDictionary($0) }
          let playerHand = playerHandData.compactMap { Card.fromDictionary($0) }
          let player = Player.fromDictionary(playerData)
          let enemies = enemiesData.compactMap { Enemy.fromDictionary($0) }  // Assuming Enemy has a `fromDictionary` method

          let stageViewModel = StageViewModel(difficulty: difficulty, player: player!)
          stageViewModel.availableDeck = availableDeck
          stageViewModel.discardedDeck = discardedDeck
          stageViewModel.playerHand = playerHand
          stageViewModel.currentStage = currentStage
          stageViewModel.isPlayerTurn = isPlayerTurn
          stageViewModel.isStageCompleted = isStageCompleted
          stageViewModel.enemies = enemies
          stageViewModel.isShowingRewards = isShowingRewards
          stageViewModel.isGameOver = isGameOver

          return stageViewModel
      }
}
