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
  var player: Player
  var difficulty: Difficulty
  var stageViewModel: StageViewModel
  
  init(difficulty: Difficulty = .medium, player: Player = Player(hp: 44)) {
      self.player = player
      self.difficulty = difficulty
      self.stageViewModel = StageViewModel(difficulty: difficulty, player: player)
  }

}
