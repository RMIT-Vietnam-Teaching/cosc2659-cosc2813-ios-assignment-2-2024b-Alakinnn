//
//  Reward.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 20/08/2024.
//

import Foundation
import Observation

enum RewardType {
    case heal(percentage: Int)
    case attackBuff(value: Int)
    case shieldBuff(value: Int)
    case addCards(cards: [Card])
    case symbolicAward
}

@Observable class Reward {
  let type: RewardType
  let name: String
  let description: String
  let iconName: String
  
  init(type: RewardType, name: String, description: String, iconName: String) {
    self.type = type
    self.name = name
    self.description = description
    self.iconName = iconName
  }
    
  var valueDescription: String {
      switch type {
      case .heal(let percentage):
          return "\(percentage)% Max HP"
      case .attackBuff(let value):
          return "+\(value) Attack Buff"
      case .shieldBuff(let value):
          return "+\(value) Shield Buff"
      case .addCards(let cards):
          return "Add \(cards.count) cards to deck"
      case .symbolicAward:
          return "Symbol of Victory"
      }
  }
}

class RewardSystem {
    static func rewardsForStage(_ stage: Int) -> [Reward] {
        switch stage {
        case 1:
            return [Reward(type: .attackBuff(value: 2), name: "Attack Buff", description: "+2 Attack Buff", iconName: "flame.fill"),
                    Reward(type: .heal(percentage: 35), name: "Heal", description: "Heal 35% Max HP", iconName: "heart.fill")]
        case 3:
            return [Reward(type: .shieldBuff(value: 3), name: "Shield Buff", description: "+3 Shield Buff", iconName: "shield.fill"),
                    Reward(type: .heal(percentage: 35), name: "Heal", description: "Heal 35% Max HP", iconName: "heart.fill")]
        case 5:
            return [Reward(type: .addCards(cards: [Card(id: UUID(), name: "Double Poison", description: "Doubles the poison stacks", cardType: .poison, value: 0, imageName: "poison.fill")]), name: "Add Poison Cards", description: "Add cards that double poison stacks", iconName: "drop.fill"),
                    Reward(type: .heal(percentage: 35), name: "Heal", description: "Heal 35% Max HP", iconName: "heart.fill")]
        case 7:
            return [Reward(type: .addCards(cards: [Card(id: UUID(), name: "Heal Card", description: "Heals for 2 HP", cardType: .heal, value: 2, imageName: "heal.fill")]), name: "Add Heal Cards", description: "Add cards that heal 2 HP", iconName: "bandage.fill"),
                    Reward(type: .heal(percentage: 35), name: "Heal", description: "Heal 35% Max HP", iconName: "heart.fill")]
        case 9:
            return [Reward(type: .attackBuff(value: 2), name: "Attack Buff", description: "+2 Attack Buff", iconName: "flame.fill"),
                    Reward(type: .shieldBuff(value: 2), name: "Shield Buff", description: "+2 Shield Buff", iconName: "shield.fill"),
                    Reward(type: .heal(percentage: 35), name: "Heal", description: "Heal 35% Max HP", iconName: "heart.fill")]
        case 11:
            return [Reward(type: .symbolicAward, name: "Victory Symbol", description: "You won the game!", iconName: "trophy.fill")]
        default:
            return [Reward(type: .heal(percentage: 35), name: "Heal", description: "Heal 35% Max HP", iconName: "heart.fill")]
        }
    }

    static func applyReward(_ reward: Reward, to player: Player, in stageViewModel: StageViewModel) {
        switch reward.type {
        case .heal(let percentage):
            let healAmount = (player.maxHP * percentage) / 100
            player.curHP = min(player.curHP + healAmount, player.maxHP)
        case .attackBuff(let value):
            player.attackBuff += value
            stageViewModel.updateCardValues()
        case .shieldBuff(let value):
            player.shieldBuff += value
            stageViewModel.updateCardValues()
        case .addCards(let cards):
            stageViewModel.availableDeck.append(contentsOf: cards)
        case .symbolicAward:
            print("Player receives a symbolic award for winning the game.")
        }
    }
}


