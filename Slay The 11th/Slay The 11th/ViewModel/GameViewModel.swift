//
//  GameViewModel.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 13/08/2024.
//

import Foundation
import Observation
import SwiftUI

enum Difficulty {
  case easy
  case medium
  case hard
}

@Observable class GameViewModel {
  var playerHealth: Int
  var difficulty: Difficulty
  var stageViewModel: StageViewModel
  
  init(difficulty: Difficulty = .medium) {
    self.playerHealth = 44
    self.difficulty = difficulty
    self.stageViewModel = StageViewModel(difficulty: difficulty)
  }
  
  func checkAndAdvanceStage() {
    if stageViewModel.isStageCompleted {
      stageViewModel.currentStage += 1
      print("Advancing to Stage \(stageViewModel.currentStage)")
    }
  }
}
