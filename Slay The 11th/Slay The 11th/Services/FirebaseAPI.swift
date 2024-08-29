//
//  FirebaseAPI.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 29/08/2024.
//
import SwiftUI
import Observation

@Observable class DatabaseManager {
  static let shared = DatabaseManager()
  private let playersKey = "players"
  private let achievementsKey = "achievements"
  private let firstRunCompletedKey = "firstRunCompleted"
  private let firstRunKey = "firstRun"
  private let firstAttackBuff = "attackBuff"
  private let firstDefendBuff = "defendBuff"

  init() {
    UserDefaults.resetDefaults()

    if fetchAchievements().isEmpty {
      initializeAchievements()
    }
  }

  func fetchPlayers(limit: Int = 0) -> [PlayerScore] {
          if let data = UserDefaults.standard.data(forKey: playersKey) {
              do {
                  let decoder = JSONDecoder()
                  var players = try decoder.decode([PlayerScore].self, from: data)
                  players.sort(by: { $0.score > $1.score }) // Sort players by score descending
                  
                  // If a limit is set, return only that number of players
                  if limit > 0 {
                      return Array(players.prefix(limit))
                  } else {
                      return players
                  }
              } catch {
                  print("Failed to decode player data: \(error.localizedDescription)")
              }
          }
          return []
      }

  func addNewPlayer(name: String) -> String {
      var players = fetchPlayers()
      let newPlayerID = UUID().uuidString
      let newPlayer = PlayerScore(id: newPlayerID, name: name, score: 0)
      players.append(newPlayer)
      savePlayers(players)
      return newPlayerID
  }

  func updatePlayerScore(playerId: String, newScore: Int) {
      var players = fetchPlayers()
      if let index = players.firstIndex(where: { $0.id == playerId }) {
          players[index].score = newScore
          savePlayers(players)
      } else {
          print("Player not found")
      }
  }

  private func savePlayers(_ players: [PlayerScore]) {
      do {
          let encoder = JSONEncoder()
          let data = try encoder.encode(players)
          UserDefaults.standard.set(data, forKey: playersKey)
      } catch {
          print("Failed to encode player data: \(error.localizedDescription)")
      }
  }
  // Fetch achievements from local storage
      func fetchAchievements() -> [Achievement] {
          if let data = UserDefaults.standard.data(forKey: achievementsKey) {
              do {
                  let decoder = JSONDecoder()
                  return try decoder.decode([Achievement].self, from: data)
              } catch {
                  print("Failed to decode achievement data: \(error.localizedDescription)")
              }
          }
          return []
      }

      // Initialize achievements
      private func initializeAchievements() {
          let initialAchievements = [
              Achievement(id: "first_run", name: "To The Spire", description: "Start a run for the first time.", iconName: "firstRunComplete", isUnlocked: false),
              Achievement(id: "gain_attack_buff", name: "Whetting Blade", description: "Gain an attack buff for the first time.", iconName: "attackBuffComplete", isUnlocked: false),
              Achievement(id: "gain_shield_buff", name: "Hard As Rock", description: "Gain a shield buff for the first time.", iconName: "defendBuffComplete", isUnlocked: false),
              Achievement(id: "reach_stage_7", name: "Halfway There", description: "Reach stage 7 for the first time.", iconName: "7thStageComplete", isUnlocked: false),
              Achievement(id: "clear_game_first_time", name: "First Victory?", description: "Clear the game for the first time.", iconName: "firstVictoryComplete", isUnlocked: false),
              Achievement(id: "clear_game_easy", name: "Victory on Easy", description: "Clear the game on Easy difficulty.", iconName: "easyComplete", isUnlocked: false),
              Achievement(id: "clear_game_medium", name: "Victory on Medium", description: "Clear the game on Medium difficulty.", iconName: "medComplete", isUnlocked: false),
              Achievement(id: "clear_game_hard", name: "Victory on Hard", description: "Clear the game on Hard difficulty.", iconName: "hardComplete", isUnlocked: false)
          ]
          saveAchievements(initialAchievements)
      }

      // Check if an achievement is unlocked
      func isAchievementUnlocked(_ id: String) -> Bool {
          let achievements = fetchAchievements()
          return achievements.contains(where: { $0.id == id && $0.isUnlocked })
      }

      // Unlock an achievement if not already unlocked
      func unlockAchievement(_ id: String) {
          var achievements = fetchAchievements()
          if let index = achievements.firstIndex(where: { $0.id == id }), !achievements[index].isUnlocked {
              achievements[index].isUnlocked = true
              saveAchievements(achievements)
              ToastManager.shared.showToast(message: "Achievement Unlocked: \(achievements[index].name)")
          }
      }

      private func saveAchievements(_ achievements: [Achievement]) {
          do {
              let encoder = JSONEncoder()
              let data = try encoder.encode(achievements)
              UserDefaults.standard.set(data, forKey: achievementsKey)
          } catch {
              print("Failed to encode achievement data: \(error.localizedDescription)")
          }
      }
}

// Mock DataManager for Previews
class MockDataManager: DatabaseManager {
  override func fetchPlayers(limit: Int = 0) -> [PlayerScore] {
          return [
              PlayerScore(id: "1", name: "Player1", score: 100),
              PlayerScore(id: "2", name: "Player2", score: 200)
          ]
      }
}
