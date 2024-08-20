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
  var tempHP: Int
  var attackBuff: Int = 0
  var shieldBuff: Int = 0
  
  init(maxHP: Int, tempHP: Int) {
    self.maxHP = maxHP
    self.curHP = maxHP
    self.tempHP = tempHP
  }
}
