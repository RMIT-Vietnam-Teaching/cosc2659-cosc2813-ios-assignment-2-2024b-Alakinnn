//
//  Card.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import Observation

@Observable class Card: Identifiable{
  let id: UUID
  let name: String
  let description: String
  let cardType: CardType
  let baseValue: Int
  let imageName: String
  var currentValue: Int
  
  init(id: UUID, name: String, description: String, cardType: CardType, value: Int, imageName: String) {
    self.id = id
    self.name = name
    self.description = description
    self.cardType = cardType
    self.baseValue = value
    self.currentValue = value
    self.imageName = imageName
  }
}

enum CardType: Codable {
  case attack
  case defense
  case poison
  case silence
  case drawCards
  case heal
}

struct Debuff: Hashable {
    let type: DebuffType
    var value: Int
    var duration: Int
}

enum DebuffType {
    case poison
    case silence
}
