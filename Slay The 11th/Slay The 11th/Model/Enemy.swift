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
    var intendedAction: EnemyAction = .attack
    var enemyImages: [String]
    var attackBuff: Int = 0
    var enemyState: EnemyState = .idle
    var isGrayscale: Bool { return curHp <= 0 }

  init(name: String, hp: Int, debuffEffects: [Debuff] = [], isBoss: Bool = false, enemyImages: [String] ) {
        self.name = name
        self.curHp = hp
        self.maxHp = hp
        self.debuffEffects = debuffEffects
        self.isBoss = isBoss
      self.enemyImages = enemyImages
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
  
  func setIntendedAction(_ action: EnemyAction) {
          self.intendedAction = action
      }
  
  // Convert Enemy to dictionary
   func toDictionary() -> [String: Any] {
       return [
           "id": id.uuidString,
           "name": name,
           "curHp": curHp,
           "maxHp": maxHp,
           "debuffEffects": debuffEffects.map { $0.toDictionary() },
           "isBoss": isBoss,
           "intendedAction": intendedAction.rawValue,
           "attackBuff": attackBuff,
           "enemyImages": enemyImages,
           "enemyState": enemyState.rawValue
       ]
   }

   // Create Enemy from dictionary
   static func fromDictionary(_ dictionary: [String: Any]) -> Enemy? {
       guard
           let name = dictionary["name"] as? String,
           let curHp = dictionary["curHp"] as? Int,
           let maxHp = dictionary["maxHp"] as? Int,
           let debuffEffectsData = dictionary["debuffEffects"] as? [[String: Any]],
           let isBoss = dictionary["isBoss"] as? Bool,
           let intendedActionRawValue = dictionary["intendedAction"] as? String,
           let intendedAction = EnemyAction(rawValue: intendedActionRawValue),
           let attackBuff = dictionary["attackBuff"] as? Int,
           let enemyImages = dictionary["enemyImages"] as? [String: [String]],
           let currentStateRawValue = dictionary["currentState"] as? String,
           let enemyImages = dictionary["enemyImages"] as? [String],
          let enemyStateRawValue = dictionary["enemyState"] as? String, 
          let enemyState = EnemyState(rawValue: enemyStateRawValue)
     else { return nil }

       let debuffEffects = debuffEffectsData.compactMap { Debuff.fromDictionary($0) }

       let enemy = Enemy(name: name, hp: maxHp, debuffEffects: debuffEffects, isBoss: isBoss, enemyImages: enemyImages)
       enemy.curHp = curHp
       enemy.intendedAction = intendedAction
       enemy.attackBuff = attackBuff
       return enemy
   }
}

enum EnemyAction: String {
    case attack
    case buff
    case cleanse
    case none
}

enum EnemyState: String {
    case idle = "idle"
    case takingDamage = "takingDamage"
    case dead = "dead"
}
