//
//  EnemyActions.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 21/08/2024.
//

import Foundation

extension StageViewModel {
  // Helper function to calculate cumulative weights
  func cumulativeSum(_ input: [Double]) -> [Double] {
      var sum: Double = 0
      return input.map { sum += $0; return sum }
  }
  
  func startEnemyTurn() {
      var cleanseChance = 0.1 // Lower initial cleanse chance

      for (index, enemy) in enemies.enumerated() where enemy.curHp > 0 {
          // Skip the turn if the enemy is silenced
          if enemy.isSilenced() {
              print("Enemy \(enemy.name) is silenced and skips its turn.")
              decrementSilenceEffectDuration(for: &enemies[index])
              continue
          }

          // Increase cleanse chance for each subsequent enemy
          let actionPerformed = performEnemyAction(enemy: &enemies[index], at: index, cleanseChance: cleanseChance)
          if actionPerformed == .cleanse {
              cleanseChance = 0.1 // Reset chance after successful cleanse
          } else {
              cleanseChance += 0.1 // Increase chance if not cleansed
          }

          // Decrement poison and silence effects after the enemy's action
          decrementPoisonEffectDuration(for: &enemies[index])
          decrementSilenceEffectDuration(for: &enemies[index])
      }

      startPlayerTurn() // Back to player turn
  }

  // Function to decrement the silence effect duration
  private func decrementSilenceEffectDuration(for enemy: inout Enemy) {
      if let index = enemy.debuffEffects.firstIndex(where: { $0.type == .silence }) {
          enemy.debuffEffects[index].duration -= 1
          if enemy.debuffEffects[index].duration <= 0 {
              enemy.debuffEffects.remove(at: index)
              print("Enemy \(enemy.name) is no longer silenced.")
          } else {
              print("Enemy \(enemy.name) has \(enemy.debuffEffects[index].duration) turns of silence left.")
          }
      }
  }


  // Function to decrement the poison effect duration
  private func decrementPoisonEffectDuration(for enemy: inout Enemy) {
      if let index = enemy.debuffEffects.firstIndex(where: { $0.type == .poison }) {
          enemy.debuffEffects[index].duration -= 1
          if enemy.debuffEffects[index].duration <= 0 {
              enemy.debuffEffects.removeAll { $0.type == .poison }
          } else {
              // Update the debuff effect stack
              enemy.debuffEffects[index].value -= 1
              print("Enemy \(enemy.name) has \(enemy.debuffEffects[index].value) poison stacks left.")
          }
      }
  }

  // Perform an action for a given enemy
  func performEnemyAction(enemy: inout Enemy, at index: Int, cleanseChance: Double) -> EnemyAction {
      let possibleActions: [EnemyAction] = [.attack, .buff, .cleanse]
      var chosenAction: EnemyAction = .attack // Default to attack
      var actionWeights: [Double] = [0.6, 0.2, 0.2] // Initial weights: attack is more likely

      // Adjust weights based on current conditions
      if hasDebuffedAlly(excluding: index) {
          actionWeights[2] = cleanseChance // Increase chance for cleanse if there's a debuffed ally
      }

      // Calculate cumulative weights for random selection
      let cumulativeWeights = cumulativeSum(actionWeights)
      let randomValue = Double.random(in: 0...1)
      for (i, weight) in cumulativeWeights.enumerated() where randomValue <= weight {
          chosenAction = possibleActions[i]
          break
      }

      // Perform the chosen action
      switch chosenAction {
      case .attack:
          performAttack(enemy: &enemy)
      case .buff:
          performBuff(enemy: &enemy)
      case .cleanse:
          performCleanse(for: &enemy)
      }

      return chosenAction
  }

  // Perform attack action
  func performAttack(enemy: inout Enemy) {
      let damageRange: ClosedRange<Int>
      if currentStage <= 5 {
          damageRange = 2...6
      } else if currentStage <= 10 {
          damageRange = 4...8
      } else {
          damageRange = enemy.isBoss ? 5...10 : 4...8
      }

      let damage = Int.random(in: damageRange) + enemy.attackBuff
      player.curHP -= max(0, damage - player.tempHP) // Apply temp HP first, then curHP
      player.tempHP = max(0, player.tempHP - damage)

      print("Enemy \(enemy.name) attacks the player for \(damage) damage. Player HP: \(player.curHP)")
  }

  // Check if any ally is debuffed (excluding the current enemy)
  func hasDebuffedAlly(excluding index: Int) -> Bool {
      for (i, ally) in enemies.enumerated() where i != index && ally.isDebuffed() {
          return true
      }
      return false
  }

  // Perform buff action
  func performBuff(enemy: inout Enemy) {
      enemy.applyBuff()
      print("Enemy \(enemy.name) gains +1 attack. Total attack buff: \(enemy.attackBuff)")
  }

  // Perform cleanse action
  func performCleanse(for enemy: inout Enemy) {
      if let debuffedAllyIndex = enemies.firstIndex(where: { $0.isDebuffed() }) {
          enemies[debuffedAllyIndex].cleanse()
          print("Enemy \(enemy.name) cleanses debuffs from \(enemies[debuffedAllyIndex].name).")
      }
  }
}
