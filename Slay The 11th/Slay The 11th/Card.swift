//
//  Card.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import Foundation
import SwiftUI

enum CardType {
  case attack
  case defense
  case poison
  case silence
  case drawCards
}

struct Debuff {
    let type: DebuffType
    var value: Int
    var duration: Int
}

enum DebuffType {
    case poison
    case silence
}

struct Card: Identifiable  {
  let id: UUID
  let name: String
  let description: String
  let cardType: CardType
  let value: Int
  let image: Image
}

struct Player {
  let HP: Int
  let extraDamage: Int
}

struct Enemy {
  let HP: Int
  let debuffEffects: [Debuff]
  let isBoss: Bool
}

enum EnemyActions {
  case attack
  case heal
  case buff
  case cleanse
}


