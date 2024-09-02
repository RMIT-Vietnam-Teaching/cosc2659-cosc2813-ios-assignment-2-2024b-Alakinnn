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
      // Start with the first enemy
      performEnemyAction(at: 0)
  }

  private func performEnemyAction(at index: Int) {
      // Ensure the index is within bounds
      guard index < enemies.count else {
          // All enemies have taken their turn, start player's turn
          startPlayerTurn()
          return
      }

      // Check if the current enemy is alive
      if enemies[index].curHp > 0 {
          let action = enemies[index].intendedAction

          // Check if the enemy is silenced before performing any action
          if enemies[index].isSilenced() {
              print("Enemy \(enemies[index].name) is silenced and skips its turn.")
              decrementSilenceEffectDuration(for: &enemies[index])
              performNextEnemyAction(afterDelay: 0.5, fromIndex: index)
              return
          }

          // Execute the previously calculated action
          switch action {
          case .attack:
              performAttack(enemy: &enemies[index])
            AudioManager.shared.playImmediateSFX("stabSfx")
            player.playerState = .takingDamage
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              if self.player.curHP > 0 {
                self.player.playerState = .idle
                      } else {
                        self.player.playerState = .dead
                      }
                  }
          case .buff:
              performBuff(enemy: &enemies[index])
          case .cleanse:
              performCleanse(for: &enemies[index])
          case .none:
              print("Enemy \(enemies[index].name) is silenced and skips its turn.")
          }

          decrementSilenceEffectDuration(for: &enemies[index])
      }

      // Perform the next enemy action with a delay
      performNextEnemyAction(afterDelay: 0.5, fromIndex: index)
  }

  private func performNextEnemyAction(afterDelay delay: TimeInterval, fromIndex index: Int) {
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
          self.performEnemyAction(at: index + 1)
      }
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
          // Check if the difficulty is hard
          if difficulty == .hard {
              // If hard difficulty, remove the silence debuff immediately
              enemy.debuffEffects.remove(at: index)
              print("Enemy \(enemy.name) is no longer silenced due to hard difficulty.")
          } else {
              // Decrement the silence effect duration for other difficulties
              enemy.debuffEffects[index].duration -= 1
              if enemy.debuffEffects[index].duration <= 0 {
                  enemy.debuffEffects.remove(at: index)
                  print("Enemy \(enemy.name) is no longer silenced.")
              } else {
                  print("Enemy \(enemy.name) has \(enemy.debuffEffects[index].duration) turns of silence left.")
              }
          }
      }
  }


  // Function to decrement the poison effect duration
//  private func decrementPoisonEffectDuration(for enemy: inout Enemy) {
//      if let index = enemy.debuffEffects.firstIndex(where: { $0.type == .poison }) {
//          // Decrement the duration first
//          enemy.debuffEffects[index].duration -= 1
//          
//          if enemy.debuffEffects[index].duration <= 0 {
//              // If the duration has expired, remove the poison debuff
//              enemy.debuffEffects.remove(at: index)
//              print("Enemy \(enemy.name) is no longer poisoned.")
//          } else {
//              // Update the debuff effect stack (value)
//              enemy.debuffEffects[index].value = max(0, enemy.debuffEffects[index].value - 1) // Ensure value does not drop below 0
//              print("Enemy \(enemy.name) has \(enemy.debuffEffects[index].value) poison stacks left.")
//          }
//      }
//  }

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
          damageRange = enemy.isBoss ? 5...10 : 2...6
      }

      let damage = Int.random(in: damageRange) + enemy.attackBuff
      player.curHP -= max(0, damage - player.tempHP) // Apply temp HP first, then curHP
      player.tempHP = max(0, player.tempHP - damage)
      player.curHP = max(0, player.curHP) // Ensure HP does not drop below 0

      print("Enemy \(enemy.name) attacks the player for \(damage) damage. Player HP: \(player.curHP)")
      
      if player.curHP <= 0 {
          gameOver()
      }
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
