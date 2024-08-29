//
//  GameViewModel.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 13/08/2024.
//

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

@Observable class GameViewModel {
    var difficulty: Difficulty
    var stageViewModel: StageViewModel
    var isGameStarted: Bool = false
    var hasSavedRun: Bool = false
  var showStatistics: Bool = false

    init(difficulty: Difficulty = .medium) {
        self.difficulty = difficulty
        self.stageViewModel = StageViewModel(difficulty: difficulty)
        loadGame() // Load the game state if it exists
    }

    func saveGame() {
        stageViewModel.pauseTimer() // Pause the timer before saving

        UserDefaults.standard.set(isGameStarted, forKey: "isGameStarted")
        UserDefaults.standard.set(difficulty.rawValue, forKey: "difficulty")
        UserDefaults.standard.set(stageViewModel.player.toDictionary(), forKey: "playerData")
        UserDefaults.standard.set(stageViewModel.toDictionary(), forKey: "stageData")

        hasSavedRun = true
    }

    func loadGame() {
        if UserDefaults.standard.bool(forKey: "isGameStarted") {
            self.isGameStarted = true
            self.difficulty = Difficulty(rawValue: UserDefaults.standard.integer(forKey: "difficulty")) ?? .medium

            if let playerData = UserDefaults.standard.dictionary(forKey: "playerData"),
               let stageData = UserDefaults.standard.dictionary(forKey: "stageData") {
                let player = Player.fromDictionary(playerData)
                let stageViewModel = StageViewModel.fromDictionary(stageData, difficulty: difficulty)
                self.stageViewModel = StageViewModel(difficulty: difficulty, player: player!)
                self.stageViewModel.currentStage = stageViewModel?.currentStage ?? 1
                self.stageViewModel.enemies = stageViewModel?.enemies ?? []

                self.stageViewModel.resumeTimer() // Resume the timer after loading the game
            }

            hasSavedRun = true
        }
    }


    func abandonRun() {
        UserDefaults.standard.removeObject(forKey: "isGameStarted")
        UserDefaults.standard.removeObject(forKey: "difficulty")
        UserDefaults.standard.removeObject(forKey: "playerData")
        UserDefaults.standard.removeObject(forKey: "stageData")

        hasSavedRun = false
        isGameStarted = false
    }
}

