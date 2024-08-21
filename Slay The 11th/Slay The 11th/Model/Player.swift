//
//  Player.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 15/08/2024.
//

import Foundation
import Observation

@Observable class Player {
  var maxHP: Int
  var curHP: Int
  var tempHP: Int = 0
  var attackBuff: Int = 0
  var shieldBuff: Int = 0
  
  init(hp: Int) {
    self.maxHP = hp
    self.curHP = hp
  }
}
