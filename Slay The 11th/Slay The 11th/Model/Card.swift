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
  
  // Convert Debuff to dictionary
  func toDictionary() -> [String: Any] {
      return [
          "type": type.rawValue,
          "value": value,
          "duration": duration
      ]
  }

  // Create Debuff from dictionary
  static func fromDictionary(_ dictionary: [String: Any]) -> Debuff? {
      guard
          let typeRawValue = dictionary["type"] as? String,
          let type = DebuffType(rawValue: typeRawValue),
          let value = dictionary["value"] as? Int,
          let duration = dictionary["duration"] as? Int
      else { return nil }

      return Debuff(type: type, value: value, duration: duration)
  }
}

enum DebuffType: String {
    case poison
    case silence
}
