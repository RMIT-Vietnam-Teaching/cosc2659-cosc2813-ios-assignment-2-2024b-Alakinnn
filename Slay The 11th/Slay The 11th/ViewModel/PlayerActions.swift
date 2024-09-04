/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 21/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

import Foundation

extension StageViewModel {
  // Apply poison effects to all enemies
  func applyPoisonEffects() {
      var delay: Double = 0.0

      for index in enemies.indices where enemies[index].curHp > 0 {
          if let poisonIndex = enemies[index].debuffEffects.firstIndex(where: { $0.type == .poison }) {
              let poison = enemies[index].debuffEffects[poisonIndex]
              
              // Use DispatchQueue to apply poison effect after a delay
              DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                  self.enemies[index].enemyState = .takingDamage
                AudioManager.shared.playImmediateSFX("stabSfx")
                  self.enemies[index].curHp -= poison.duration
                  self.enemies[index].curHp = max(0, self.enemies[index].curHp)
                if self.difficulty == .hard {
                  self.enemies[index].debuffEffects[poisonIndex].duration -= 2
                } else {
                  self.enemies[index].debuffEffects[poisonIndex].duration -= 1

                }
                
                
                  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                      if self.enemies[index].curHp > 0 {
                          self.enemies[index].enemyState = .idle
                      } else {
                          self.enemies[index].enemyState = .dead
                      }
                  }
                  
                  print("Enemy \(self.enemies[index].name) takes \(poison.duration) poison damage. Remaining HP: \(self.enemies[index].curHp)")
                  
                  // Remove poison if duration is over
                  if self.enemies[index].debuffEffects[poisonIndex].duration <= 0 {
                      self.enemies[index].debuffEffects.remove(at: poisonIndex)
                  }

                  // Check if it's the last enemy in the list and apply further logic
                  if index == self.enemies.indices.last {
                      self.checkIfStageCompleted()
                  }
              }

              // Increment delay for the next enemy
              delay += 1.5 // Increase delay for each enemy to separate the effects
          }
      }
  }


  // Apply a card's effect to the enemy or the player
  func applyCard(at index: Int? = nil) {
      guard let card = selectedCard else {
          print("No card selected")
          return
      }

      // Check if the card is player-specific (defense, draw, or heal)
      switch card.cardType {
      case .defense:
        AudioManager.shared.playImmediateSFX("playCardSfx")
          applyDefenseEffect(value: card.currentValue)
      case .drawCards:
        AudioManager.shared.playImmediateSFX("playCardSfx")
          applyDrawEffect(value: card.currentValue)
      case .heal:
        AudioManager.shared.playImmediateSFX("playCardSfx")
          applyHealEffect(value: card.currentValue)
      default:
          if let enemyIndex = index, enemies[enemyIndex].curHp > 0 { // Ensure enemy is alive
              applyCardToEnemy(at: enemyIndex)
          } else {
              print("This card requires a target or the target is dead")
              return
          }
      }
      // Move the used card to the discarded deck
      moveCardToDiscardedDeck(card)

      // Clear the selected card after applying
      selectedCard = nil
    
      checkIfStageCompleted()
  }

  // Apply a heal effect to the player
  func applyHealEffect(value: Int) {
      let healAmount = min(value, player.maxHP - player.curHP)
      player.curHP += healAmount
      print("Player healed by \(healAmount) HP. Current HP: \(player.curHP)")
  }

  // Apply a card to an enemy
  private func applyCardToEnemy(at index: Int) {
      guard let card = selectedCard else {
          print("No card selected")
          return
      }

      // Ensure the index is valid
      guard index >= 0 && index < enemies.count else {
          print("Invalid enemy index")
          return
      }

      // Work directly with the enemy in the array
      var enemy = enemies[index]

      switch card.cardType {
      case .attack:
          enemy.enemyState = .takingDamage
          enemy.curHp -= card.currentValue
          AudioManager.shared.playImmediateSFX("stabSfx")
          enemy.curHp = max(0, enemy.curHp) // Ensure HP does not drop below 0
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if enemy.curHp > 0 {
                        enemy.enemyState = .idle
                    } else {
                      enemy.enemyState = .dead
                    }
                }
          print("Enemy \(enemy.name) takes \(card.currentValue) damage. Remaining HP: \(enemy.curHp)")

      case .poison:
        AudioManager.shared.playImmediateSFX("playCardSfx")
        addOrUpdateDebuff(on: &enemy, type: .poison, value: card.currentValue, duration: card.currentValue)
          print("Enemy \(enemy.name) is poisoned for \(card.currentValue) damage per turn.")

      case .silence:
        AudioManager.shared.playImmediateSFX("playCardSfx")
        addOrUpdateDebuff(on: &enemy, type: .silence, value: card.currentValue, duration: card.currentValue)
        enemy.setIntendedAction(.none)
          print("Enemy \(enemy.name) is silenced.")
        
      case .doublePoison:
         // Double the poison duration if it exists
         AudioManager.shared.playImmediateSFX("playCardSfx")
         if let index = enemy.debuffEffects.firstIndex(where: { $0.type == .poison }) {
             enemy.debuffEffects[index].duration *= 2 // Double the duration
             print("Enemy \(enemy.name) has their poison duration doubled to \(enemy.debuffEffects[index].duration) turns.")
         } else {
             print("Enemy \(enemy.name) has no poison debuff to double.")
         }


      default:
          print("Unhandled card type: \(card.cardType)")
      }

      // Update the enemy in the array
      enemies[index] = enemy

      // Move the used card to the discarded deck
      moveCardToDiscardedDeck(card)

      // Clear the selected card after applying
      selectedCard = nil

      // Check if the stage is completed after the attack
      checkIfStageCompleted()
  }


  // Add or update a debuff on the enemy
  private func addOrUpdateDebuff(on enemy: inout Enemy, type: DebuffType, value: Int, duration: Int) {
      if let index = enemy.debuffEffects.firstIndex(where: { $0.type == type }) {
          // If the debuff already exists, update the value and increase the duration
          enemy.debuffEffects[index].duration += duration
      } else {
          // If the debuff doesn't exist, add it
          let debuff = Debuff(type: type, value: value, duration: duration)
          enemy.debuffEffects.append(debuff)
      }
  }

  // Apply defense effect to the player
  func applyDefenseEffect(value: Int) {
      player.tempHP += value
      print("Player gains \(value) temporary HP. Total temporary HP: \(player.tempHP)")
  }

  // Apply draw effect (draw additional cards)
  func applyDrawEffect(value: Int) {
      for _ in 0..<value {
          drawCard()
      }
      print("Player draws \(value) cards.")
  }
}
