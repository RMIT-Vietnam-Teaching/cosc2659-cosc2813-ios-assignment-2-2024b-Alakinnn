//
//  Card.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

enum CardType: Codable {
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

struct Card: Identifiable, Transferable, Codable {
    let id: UUID
    let name: String
    let description: String
    let cardType: CardType
    let value: Int
    let imageName: String 

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .cardObject)
    }
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

extension UTType {
  static let cardObject = UTType(exportedAs: "sa.hoang.cardObject")
}
