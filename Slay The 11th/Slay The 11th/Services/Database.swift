/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 29/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

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
//    UserDefaults.resetDefaults()
    if fetchPlayers().isEmpty {
                initializeMockData()
            }
    
    if fetchAchievements().isEmpty {
      initializeAchievements()
    }
  }

  func fetchPlayers(limit: Int = 0) -> [PlayerScore] {
          if let data = UserDefaults.standard.data(forKey: playersKey) {
              do {
                  let decoder = JSONDecoder()
                  var players = try decoder.decode([PlayerScore].self, from: data)
                  
                  // If a limit is set, return only that number of players
                  if limit > 0 {
                      return Array(players.suffix(limit))
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
      let newPlayer = PlayerScore(id: newPlayerID, name: name, score: 0, stagesFinished: 1)
      players.append(newPlayer)
      savePlayers(players)
      return newPlayerID
  }

  func updatePlayerScore(playerId: String, newScore: Int, stagesFinished: Int) {
      var players = fetchPlayers()
      if let index = players.firstIndex(where: { $0.id == playerId }) {
          players[index].score = newScore
          players[index].stagesFinished = stagesFinished 
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
             Achievement(id: "first_run", name: NSLocalizedString("achievement_first_run_name", comment: "First run achievement name"), description: NSLocalizedString("achievement_first_run_description", comment: "First run achievement description"), iconName: "firstRunComplete", isUnlocked: false),
             Achievement(id: "gain_attack_buff", name: NSLocalizedString("achievement_gain_attack_buff_name", comment: "Gain attack buff achievement name"), description: NSLocalizedString("achievement_gain_attack_buff_description", comment: "Gain attack buff achievement description"), iconName: "attackBuffComplete", isUnlocked: false),
             Achievement(id: "gain_shield_buff", name: NSLocalizedString("achievement_gain_shield_buff_name", comment: "Gain shield buff achievement name"), description: NSLocalizedString("achievement_gain_shield_buff_description", comment: "Gain shield buff achievement description"), iconName: "defendBuffComplete", isUnlocked: false),
             Achievement(id: "reach_stage_7", name: NSLocalizedString("achievement_reach_stage_7_name", comment: "Reach stage 7 achievement name"), description: NSLocalizedString("achievement_reach_stage_7_description", comment: "Reach stage 7 achievement description"), iconName: "7thStageComplete", isUnlocked: false),
             Achievement(id: "clear_game_first_time", name: NSLocalizedString("achievement_clear_game_first_time_name", comment: "Clear game for the first time achievement name"), description: NSLocalizedString("achievement_clear_game_first_time_description", comment: "Clear game for the first time achievement description"), iconName: "firstVictoryComplete", isUnlocked: false),
             Achievement(id: "clear_game_easy", name: NSLocalizedString("achievement_clear_game_easy_name", comment: "Clear game on easy difficulty achievement name"), description: NSLocalizedString("achievement_clear_game_easy_description", comment: "Clear game on easy difficulty achievement description"), iconName: "easyComplete", isUnlocked: false),
             Achievement(id: "clear_game_medium", name: NSLocalizedString("achievement_clear_game_medium_name", comment: "Clear game on medium difficulty achievement name"), description: NSLocalizedString("achievement_clear_game_medium_description", comment: "Clear game on medium difficulty achievement description"), iconName: "medComplete", isUnlocked: false),
             Achievement(id: "clear_game_hard", name: NSLocalizedString("achievement_clear_game_hard_name", comment: "Clear game on hard difficulty achievement name"), description: NSLocalizedString("achievement_clear_game_hard_description", comment: "Clear game on hard difficulty achievement description"), iconName: "hardComplete", isUnlocked: false)
         ]
         saveAchievements(initialAchievements)
     }
  
  private func initializeMockData() {
          let mockPlayerScores: [PlayerScore] = [
              PlayerScore(id: "1", name: "Rahim", score: 100, stagesFinished: 1),
              PlayerScore(id: "2", name: "Feing", score: 200, stagesFinished: 2),
              PlayerScore(id: "3", name: "Qutic", score: 1100, stagesFinished: 11),  // Won the game
              PlayerScore(id: "4", name: "Wukong", score: 300, stagesFinished: 3),
              PlayerScore(id: "5", name: "Rshata", score: 400, stagesFinished: 4),
              PlayerScore(id: "6", name: "Wujin", score: 700, stagesFinished: 11), // Won the game
              PlayerScore(id: "7", name: "Wokux", score: 500, stagesFinished: 5),
              PlayerScore(id: "8", name: "Brokeboi", score: 600, stagesFinished: 6),
              PlayerScore(id: "9", name: "Vyti", score: 900, stagesFinished: 11), // Won the game
              PlayerScore(id: "10", name: "Salca", score: 800, stagesFinished: 8),
              PlayerScore(id: "11", name: "Loam", score: 1000, stagesFinished: 11), // Won the game

          ]
          savePlayers(mockPlayerScores)
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
              PlayerScore(id: "1", name: "Player1", score: 100, stagesFinished: 1),
              PlayerScore(id: "2", name: "Player2", score: 200, stagesFinished: 1)
          ]
      }
}
