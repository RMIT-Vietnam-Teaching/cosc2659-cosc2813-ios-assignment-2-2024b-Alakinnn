/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 10/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import Observation

@Observable class Card: Identifiable, Equatable{
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
  
  // Equatable protocol conformance
  static func ==(lhs: Card, rhs: Card) -> Bool {
      return lhs.id == rhs.id &&
             lhs.name == rhs.name &&
             lhs.description == rhs.description &&
             lhs.cardType == rhs.cardType &&
             lhs.baseValue == rhs.baseValue &&
             lhs.imageName == rhs.imageName &&
             lhs.currentValue == rhs.currentValue
  }
  
  // Convert Card to dictionary
  func toDictionary() -> [String: Any] {
      return [
          "id": id.uuidString,
          "name": name,
          "description": description,
          "cardType": cardType.rawValue,
          "baseValue": baseValue,
          "currentValue": currentValue,
          "imageName": imageName
      ]
  }

  // Create Card from dictionary
  static func fromDictionary(_ dictionary: [String: Any]) -> Card? {
      guard
          let idString = dictionary["id"] as? String,
          let id = UUID(uuidString: idString),
          let name = dictionary["name"] as? String,
          let description = dictionary["description"] as? String,
          let cardTypeRawValue = dictionary["cardType"] as? String,
          let cardType = CardType(rawValue: cardTypeRawValue),
          let baseValue = dictionary["baseValue"] as? Int,
          let currentValue = dictionary["currentValue"] as? Int,
          let imageName = dictionary["imageName"] as? String
      else { return nil }

      let card = Card(id: id, name: name, description: description, cardType: cardType, value: baseValue, imageName: imageName)
    card.currentValue = currentValue
    return card
  }
}

enum CardType: String, Codable  {
  case attack
  case defense
  case poison
  case silence
  case drawCards
  case heal
  case doublePoison
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
