//
//  StageViewModel.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 11/08/2024.
//

import SwiftUI
import Observation

@Observable class StageViewModel {
  var availableDeck: [Card] = [] // Cards available to draw
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
  var isGameOver: Bool = false
  var score: Int = 0
  var startTime: Date?
  var elapsedTime: TimeInterval = 0
  var timer: Timer?
  var allStagesCleared: Bool = false
  var playerID: String?
  var mode: Mode

  init(difficulty: Difficulty, player: Player = Player(hp: 44), playerID: String? = nil, mode: Mode) {
    self.player = player
    self.difficulty = difficulty
    self.mode = mode
    self.enemies = generateEnemies(mode: mode)
    self.availableDeck = generateDeck(mode: mode)
    self.playerID = playerID
    self.startTime = Date()
    self.startTimer()
    self.calculateScore()
  }
  
  func generateEnemies(mode: Mode) -> [Enemy] {
    if mode == .regular {
      return EnemyFactory.createEnemies(for: difficulty, stage: currentStage)
    } else {
      return [Enemy(name: "Dummy", hp: 14, debuffEffects: [Debuff(type: .poison, value: 1, duration: 1)])]
    }
  }
  
  func generateDeck(mode:Mode) -> [Card] {
    if mode == .regular {
      return createStaticDeck()
    } else {
      return [
        Card(id: UUID(), name: "Attack", description: "Slash the enemy", cardType: .attack, value: 3, imageName: "flame.fill"),
        Card(id: UUID(), name: "Poison", description: "Poison the enemy", cardType: .poison, value: 2, imageName: "drop.fill"),
        Card(id: UUID(), name: "Defense", description: "Shield yourself", cardType: .defense, value: 2, imageName: "shield.fill"),
        Card(id: UUID(), name: "Silence", description: "Silence the enemy.", cardType: .silence, value: 1, imageName: "speaker.slash.fill"),
        Card(id: UUID(), name: "Draw Cards", description: "Draw more cards.", cardType: .drawCards, value: 2, imageName: "rectangle.stack.fill"),
        Card(id: UUID(), name: "Attack", description: "Slash the enemy", cardType: .attack, value: 3, imageName: "flame.fill"),

        Card(id: UUID(), name: "Attack", description: "Slash the enemy", cardType: .attack, value: 3, imageName: "flame.fill"),

        Card(id: UUID(), name: "Attack", description: "Slash the enemy", cardType: .attack, value: 3, imageName: "flame.fill"),
      ]
    }
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
      calculateScore()
      if mode == .tutorial {
        allStagesCleared = true
      }
      }
  }

  func checkAndAdvanceStage() {
      if isStageCompleted {
          enemies.removeAll()

          if currentStage == 11 {
              print("Game completed. Showing victory screen.")
          } else {
              currentStage += 1
              let newEnemies = EnemyFactory.createEnemies(for: difficulty, stage: currentStage)

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
  }
  
  func gameOver() {
      isGameOver = true
  }
  
  func updatePlayerScore(db: DatabaseManager) {
      guard let playerID = playerID else {
          print("No playerID found, unable to update score.")
          return
      }
      let newScore = score
      let stagesFinished = currentStage - 1 // Assuming `currentStage` exists and tracks the stage

      db.updatePlayerScore(playerId: playerID, newScore: newScore, stagesFinished: stagesFinished)
      print("Score and stage updated successfully in local storage.")
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
              "isGameOver": isGameOver,
              "gameMode": mode.rawValue,
              "startTime": startTime?.timeIntervalSinceReferenceDate ?? 0,
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
              let isGameOver = dictionary["isGameOver"] as? Bool,
              let modeRawValue = dictionary["gameMode"] as? Int
          else { return nil }

          let mode = Mode(rawValue: modeRawValue) ?? .regular
          let availableDeck = availableDeckData.compactMap { Card.fromDictionary($0) }
          let discardedDeck = discardedDeckData.compactMap { Card.fromDictionary($0) }
          let playerHand = playerHandData.compactMap { Card.fromDictionary($0) }
          let player = Player.fromDictionary(playerData)
          let enemies = enemiesData.compactMap { Enemy.fromDictionary($0) }

          let stageViewModel = StageViewModel(difficulty: difficulty, player: player!, mode: mode)
          stageViewModel.availableDeck = availableDeck
          stageViewModel.discardedDeck = discardedDeck
          stageViewModel.playerHand = playerHand
          stageViewModel.currentStage = currentStage
          stageViewModel.isPlayerTurn = isPlayerTurn
          stageViewModel.isStageCompleted = isStageCompleted
          stageViewModel.enemies = enemies
          stageViewModel.isShowingRewards = isShowingRewards
          stageViewModel.isGameOver = isGameOver

          if let startTimeInterval = dictionary["startTime"] as? TimeInterval {
              stageViewModel.startTime = Date(timeIntervalSinceReferenceDate: startTimeInterval)
          }

          return stageViewModel
      }
}
