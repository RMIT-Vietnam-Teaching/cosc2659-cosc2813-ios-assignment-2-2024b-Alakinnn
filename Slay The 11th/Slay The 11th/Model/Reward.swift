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
          return String(format: NSLocalizedString("heal_description", comment: "Heal percentage description"), percentage)
      case .attackBuff(let value):
          return String(format: NSLocalizedString("attack_buff_description", comment: "Attack buff description"), value)
      case .shieldBuff(let value):
          return String(format: NSLocalizedString("shield_buff_description", comment: "Shield buff description"), value)
      case .addCards(let cards):
          return String(format: NSLocalizedString("add_cards_description", comment: "Add cards description"), cards.count)
      case .symbolicAward:
          return NSLocalizedString("symbol_of_victory", comment: "Symbol of Victory")
      }
  }
  
  func toDictionary() -> [String: Any] {
      var typeDict: [String: Any] = [:]

      switch type {
      case .heal(let percentage):
          typeDict = ["type": "heal", "percentage": percentage]
      case .attackBuff(let value):
          typeDict = ["type": "attackBuff", "value": value]
      case .shieldBuff(let value):
          typeDict = ["type": "shieldBuff", "value": value]
      case .addCards(let cards):
          typeDict = ["type": "addCards", "cards": cards.map { $0.toDictionary() }]  // Assuming Card has a `toDictionary` method
      case .symbolicAward:
          typeDict = ["type": "symbolicAward"]
      }

      return [
          "type": typeDict,
          "name": name,
          "description": description,
          "iconName": iconName
      ]
  }
  
  static func fromDictionary(_ dictionary: [String: Any]) -> Reward? {
      guard
          let typeDict = dictionary["type"] as? [String: Any],
          let name = dictionary["name"] as? String,
          let description = dictionary["description"] as? String,
          let iconName = dictionary["iconName"] as? String
      else { return nil }

      let type: RewardType

      if let percentage = typeDict["percentage"] as? Int {
          type = .heal(percentage: percentage)
      } else if let value = typeDict["value"] as? Int {
          if typeDict["type"] as? String == "attackBuff" {
              type = .attackBuff(value: value)
          } else if typeDict["type"] as? String == "shieldBuff" {
              type = .shieldBuff(value: value)
          } else {
              return nil
          }
      } else if let cardsData = typeDict["cards"] as? [[String: Any]] {
          let cards = cardsData.compactMap { Card.fromDictionary($0) } 
          type = .addCards(cards: cards)
      } else if typeDict["type"] as? String == "symbolicAward" {
          type = .symbolicAward
      } else {
          return nil
      }

      return Reward(type: type, name: name, description: description, iconName: iconName)
  }

}

class RewardSystem {
    static func rewardsForStage(_ stage: Int) -> [Reward] {
        switch stage {
        case 1:
            return [Reward(type: .attackBuff(value: 2), name: NSLocalizedString("attack_buff_name", comment: "Attack Buff name"), description: NSLocalizedString("attack_buff_plus2_description", comment: "+2 Attack Buff description"), iconName: "flame.fill"),
                    Reward(type: .heal(percentage: 35), name: NSLocalizedString("heal_name", comment: "Heal name"), description: NSLocalizedString("heal_35_description", comment: "Heal 35% description"), iconName: "heart.fill")]
        case 3:
            return [Reward(type: .shieldBuff(value: 3), name: NSLocalizedString("shield_buff_name", comment: "Shield Buff name"), description: NSLocalizedString("shield_buff_plus3_description", comment: "+3 Shield Buff description"), iconName: "shield.fill"),
                    Reward(type: .heal(percentage: 35), name: NSLocalizedString("heal_name", comment: "Heal name"), description: NSLocalizedString("heal_35_description", comment: "Heal 35% description"), iconName: "heart.fill")]
        case 5:
            return [Reward(type: .addCards(cards: [Card(id: UUID(), name: NSLocalizedString("double_poison_card_name", comment: "Double Poison Card name"), description: NSLocalizedString("double_poison_card_description", comment: "Doubles the poison stacks description"), cardType: .poison, value: 0, imageName: "poison.fill")]), name: NSLocalizedString("add_poison_cards_name", comment: "Add Poison Cards name"), description: NSLocalizedString("add_poison_cards_description", comment: "Add cards that double poison stacks description"), iconName: "drop.fill"),
                    Reward(type: .heal(percentage: 35), name: NSLocalizedString("heal_name", comment: "Heal name"), description: NSLocalizedString("heal_35_description", comment: "Heal 35% description"), iconName: "heart.fill")]
        case 7:
            return [Reward(type: .addCards(cards: [Card(id: UUID(), name: NSLocalizedString("heal_card_name", comment: "Heal Card name"), description: NSLocalizedString("heal_card_description", comment: "Heals for 2 HP description"), cardType: .heal, value: 2, imageName: "heal.fill")]), name: NSLocalizedString("add_heal_cards_name", comment: "Add Heal Cards name"), description: NSLocalizedString("add_heal_cards_description", comment: "Add cards that heal 2 HP description"), iconName: "bandage.fill"),
                    Reward(type: .heal(percentage: 35), name: NSLocalizedString("heal_name", comment: "Heal name"), description: NSLocalizedString("heal_35_description", comment: "Heal 35% description"), iconName: "heart.fill")]
        case 9:
            return [Reward(type: .attackBuff(value: 2), name: NSLocalizedString("attack_buff_name", comment: "Attack Buff name"), description: NSLocalizedString("attack_buff_plus2_description", comment: "+2 Attack Buff description"), iconName: "flame.fill"),
                    Reward(type: .shieldBuff(value: 2), name: NSLocalizedString("shield_buff_name", comment: "Shield Buff name"), description: NSLocalizedString("shield_buff_plus2_description", comment: "+2 Shield Buff description"), iconName: "shield.fill"),
                    Reward(type: .heal(percentage: 35), name: NSLocalizedString("heal_name", comment: "Heal name"), description: NSLocalizedString("heal_35_description", comment: "Heal 35% description"), iconName: "heart.fill")]
        case 11:
            return [Reward(type: .symbolicAward, name: NSLocalizedString("victory_symbol_name", comment: "Victory Symbol name"), description: NSLocalizedString("victory_symbol_description", comment: "You won the game! description"), iconName: "trophy.fill")]
        default:
            return [Reward(type: .heal(percentage: 35), name: NSLocalizedString("heal_name", comment: "Heal name"), description: NSLocalizedString("heal_35_description", comment: "Heal 35% description"), iconName: "heart.fill")]
        }
    }

    static func applyReward(_ reward: Reward, gameVm: GameViewModel, db: DatabaseManager, to player: Player, in stageViewModel: StageViewModel) {
        switch reward.type {
        case .heal(let percentage):
            let healAmount = (player.maxHP * percentage) / 100
            player.curHP = min(player.curHP + healAmount, player.maxHP)
        case .attackBuff(let value):
            player.attackBuff += value
            stageViewModel.updateCardValues()
            gameVm.checkAndUnlockAchievements(db: db, action: .gainAttackBuff)
        case .shieldBuff(let value):
            player.shieldBuff += value
            stageViewModel.updateCardValues()
          gameVm.checkAndUnlockAchievements(db: db, action: .gainShieldBuff)
        case .addCards(let cards):
            stageViewModel.availableDeck.append(contentsOf: cards)
        case .symbolicAward:
            print(NSLocalizedString("symbolic_award_message", comment: "Symbolic award message"))
        }
    }
}


