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
  var playerState: EntityState = .idle
  init(hp: Int) {
      self.maxHP = hp
      self.curHP = hp
  }

  // Method to convert player state to a dictionary
  func toDictionary() -> [String: Any] {
      return [
          "curHP": curHP,
          "maxHP": maxHP,
          "tempHP": tempHP,
          "attackBuff": attackBuff,
          "shieldBuff": shieldBuff
      ]
  }

  // Method to load player state from a dictionary
  static func fromDictionary(_ dictionary: [String: Any]) -> Player? {
      guard
          let curHP = dictionary["curHP"] as? Int,
          let maxHP = dictionary["maxHP"] as? Int,
          let tempHP = dictionary["tempHP"] as? Int,
          let attackBuff = dictionary["attackBuff"] as? Int,
          let shieldBuff = dictionary["shieldBuff"] as? Int
      else { return nil }

      let player = Player(hp: maxHP)
      player.curHP = curHP
      player.tempHP = tempHP
      player.attackBuff = attackBuff
      player.shieldBuff = shieldBuff

      return player
  }
}

