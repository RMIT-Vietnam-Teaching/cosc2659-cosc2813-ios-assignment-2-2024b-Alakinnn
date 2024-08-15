//
//  Enemy.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 15/08/2024.
//

import Foundation
import Observation

@Observable class Enemy: Identifiable {
    let id = UUID()
    var name: String
    var curHp: Int
    let maxHp: Int
    var debuffEffects: [Debuff] = []
    var isBoss: Bool = false

    init(name: String, hp: Int, debuffEffects: [Debuff] = [], isBoss: Bool = false) {
        self.name = name
        self.curHp = hp
        self.maxHp = hp
        self.debuffEffects = debuffEffects
        self.isBoss = isBoss
    }
}


enum EnemyActions {
  case attack
  case heal
  case buff
  case cleanse
}
