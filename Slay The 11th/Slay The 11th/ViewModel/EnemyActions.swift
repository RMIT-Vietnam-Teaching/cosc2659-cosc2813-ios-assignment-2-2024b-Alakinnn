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
          // Ensure that intentions are already calculated
          for (index, enemy) in enemies.enumerated() where enemy.curHp > 0 {
              let action = enemy.intendedAction
              
              // Execute the previously calculated action
              switch action {
              case .attack:
                  performAttack(enemy: &enemies[index])
              case .buff:
                  performBuff(enemy: &enemies[index])
              case .cleanse:
                  performCleanse(for: &enemies[index])
              case .none:
                  print("Enemy \(enemy.name) is silenced and skips its turn.")
              }

              // Decrement effects after performing the action
              decrementPoisonEffectDuration(for: &enemies[index])
              decrementSilenceEffectDuration(for: &enemies[index])
          }

          startPlayerTurn() // Back to player turn
  }


  
  func calculateEnemyIntentions() {
          var cleanseChance = 0.1 // initial cleanse chance

          for (index, enemy) in enemies.enumerated() where enemy.curHp > 0 {
              // Skip if the enemy is silenced
              if enemy.isSilenced() {
                  enemy.intendedAction = .none // Or some other default action to indicate no action
                  continue
              }

              // Calculate the intended action
              enemy.intendedAction = determineEnemyAction(for: &enemies[index], at: index, cleanseChance: cleanseChance)

              // Increase cleanse chance if not performed
              if enemy.intendedAction != .cleanse {
                  cleanseChance += 0.1
              }
          }
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
  private func determineEnemyAction(for enemy: inout Enemy, at index: Int, cleanseChance: Double) -> EnemyAction {
      let possibleActions: [EnemyAction] = [.attack, .buff, .cleanse]
      var chosenAction: EnemyAction = .attack // Default to attack
      var actionWeights: [Double] = [0.7, 0.2, 0.1] // Initial weights: attack is more likely

      // Adjust weights based on current conditions
      if hasDebuffedAlly(excluding: index) {
          actionWeights[2] = cleanseChance // Increase chance for cleanse if there's a debuffed ally
      } else {
          actionWeights[2] = 0.0 // No chance to cleanse if no debuffed allies exist
      }

      // Calculate cumulative weights for random selection
      let cumulativeWeights = cumulativeSum(actionWeights)
      let randomValue = Double.random(in: 0...1)
      for (i, weight) in cumulativeWeights.enumerated() where randomValue <= weight {
          chosenAction = possibleActions[i]
          break
      }

      // Final check: if cleanse was chosen but there is nothing to cleanse, fallback to attack
//    There was a bug where it shows cleanse but enemy attacks instead
      if chosenAction == .cleanse && !hasDebuffedAlly(excluding: index) {
          chosenAction = .attack
      }

      print("Enemy \(enemy.name) at index \(index) intends to \(chosenAction).")

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
