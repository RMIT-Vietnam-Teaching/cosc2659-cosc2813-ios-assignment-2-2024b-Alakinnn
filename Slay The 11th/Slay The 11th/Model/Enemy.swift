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
    var attackBuff: Int = 0 // Track attack buffs applied to the enemy

    init(name: String, hp: Int, debuffEffects: [Debuff] = [], isBoss: Bool = false) {
        self.name = name
        self.curHp = hp
        self.maxHp = hp
        self.debuffEffects = debuffEffects
        self.isBoss = isBoss
    }
    
    // Check if the enemy is silenced
    func isSilenced() -> Bool {
        return debuffEffects.contains { $0.type == .silence }
    }

    // Check if the enemy has any debuff
    func isDebuffed() -> Bool {
        return !debuffEffects.isEmpty
    }
    
    // Apply an attack buff to the enemy
    func applyBuff() {
        attackBuff += 1
    }
    
    // Perform a cleanse action, removing all debuffs
    func cleanse() {
        debuffEffects.removeAll()
    }
}

enum EnemyAction {
    case attack
    case buff
    case cleanse
}
