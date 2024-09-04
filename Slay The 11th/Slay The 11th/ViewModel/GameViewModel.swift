/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 13/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

import Foundation
import Observation
import SwiftUI

enum Difficulty: Int {
  case easy
  case medium
  case hard
  
  var name: String {
      switch self {
      case .easy:
          return "easy"
      case .medium:
          return "medium"
      case .hard:
          return "hard"
      }
  }
}

enum Mode: Int {
  case tutorial = 0
  case regular = 1
}

@Observable class GameViewModel {
    var difficulty: Difficulty
    var stageViewModel: StageViewModel
    var isGameStarted: Bool = false
    var hasSavedRun: Bool = false
    var showStatistics: Bool = false
    var mode: Mode
    var isTutorial: Bool = false

    init(difficulty: Difficulty = .medium, mode: Mode = .regular) {
        self.difficulty = difficulty
        self.mode = mode
      if mode == .tutorial {
        self.isTutorial = true
      }
        self.stageViewModel = StageViewModel(difficulty: difficulty, mode: mode)

        // Only load the game if it's in regular mode
        if mode == .regular {
            loadGame()
        }
    }

    // Updated loadGame method
    func loadGame() {
        if mode == .tutorial {
            return // Skip loading in tutorial mode
        }

        if UserDefaults.standard.bool(forKey: "isGameStarted") {
            self.isGameStarted = true
            self.difficulty = Difficulty(rawValue: UserDefaults.standard.integer(forKey: "difficulty")) ?? .medium
            let savedModeRawValue = UserDefaults.standard.integer(forKey: "gameMode")
            self.mode = Mode(rawValue: savedModeRawValue) ?? .regular

            if let playerData = UserDefaults.standard.dictionary(forKey: "playerData"),
               let stageData = UserDefaults.standard.dictionary(forKey: "stageData"),
               let enemiesData = UserDefaults.standard.array(forKey: "enemies"){
                let player = Player.fromDictionary(playerData)
                let stageViewModel = StageViewModel.fromDictionary(stageData, difficulty: difficulty)
                self.stageViewModel = stageViewModel ?? StageViewModel(difficulty: difficulty, player: player!, mode: mode)
                self.stageViewModel.difficulty = difficulty
                self.stageViewModel.player = player!
                self.stageViewModel.mode = mode
                self.stageViewModel.currentStage = stageViewModel?.currentStage ?? 1
                
                let enemiesDataList: [Enemy] = enemiesData.compactMap{
                    guard let validElement = $0 as? [String : Any] else { return nil }
                    return Enemy.fromDictionary(validElement)
                }
                
                self.stageViewModel.enemies = enemiesDataList

                self.stageViewModel.resumeTimer() // Resume the timer after loading the game
            }

            hasSavedRun = true
        }
    }
    
    func saveGame() {
        guard mode == .regular else { return } // Only save in regular mode
        stageViewModel.pauseTimer() // Pause the timer before saving
        

        UserDefaults.standard.set(isGameStarted, forKey: "isGameStarted")
        UserDefaults.standard.set(difficulty.rawValue, forKey: "difficulty")
        UserDefaults.standard.set(stageViewModel.player.toDictionary(), forKey: "playerData")
        UserDefaults.standard.set(stageViewModel.enemies.compactMap{ $0.toDictionary() }, forKey: "enemies")
        UserDefaults.standard.set(stageViewModel.toDictionary(), forKey: "stageData")
        UserDefaults.standard.set(mode.rawValue, forKey: "gameMode")

        hasSavedRun = true
    }

    func abandonRun() {
        // Remove saved state if abandoning
        UserDefaults.standard.removeObject(forKey: "isGameStarted")
        UserDefaults.standard.removeObject(forKey: "difficulty")
        UserDefaults.standard.removeObject(forKey: "playerData")
        UserDefaults.standard.removeObject(forKey: "stageData")
        UserDefaults.standard.removeObject(forKey: "gameMode")

        hasSavedRun = false
        isGameStarted = false
    }
}


