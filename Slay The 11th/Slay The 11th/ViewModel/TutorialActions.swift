//
//  TutorialActions.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 28/08/2024.
//

import Foundation
import SwiftUI

extension StageViewModel {
  
  func setupTutorialStage() {
          enemies = [Enemy(name: "Tutorial Enemy", hp: 11)]
    
    availableDeck = [
            Card(id: UUID(), name: "Attack", description: "Slash the enemy", cardType: .attack, value: 3, imageName: "flame.fill"),
            Card(id: UUID(), name: "Attack", description: "Slash the enemy", cardType: .attack, value: 3, imageName: "flame.fill"),
            Card(id: UUID(), name: "Attack", description: "Slash the enemy", cardType: .attack, value: 3, imageName: "flame.fill"),
            Card(id: UUID(), name: "Attack", description: "Slash the enemy", cardType: .attack, value: 3, imageName: "flame.fill"),
            Card(id: UUID(), name: "Attack", description: "Slash the enemy", cardType: .attack, value: 3, imageName: "flame.fill"),
            Card(id: UUID(), name: "Attack", description: "Slash the enemy", cardType: .attack, value: 3, imageName: "flame.fill"),
            Card(id: UUID(), name: "Attack", description: "Slash the enemy", cardType: .attack, value: 3, imageName: "flame.fill"),
          ]
          
    playerHand = [
      Card(id: UUID(), name: "Attack", description: "Slash the enemy", cardType: .attack, value: 3, imageName: "flame.fill"),   // Attack card
      Card(id: UUID(), name: "Defense", description: "Shield yourself", cardType: .defense, value: 2, imageName: "shield.fill"),
      Card(id: UUID(), name: "Draw Cards", description: "Draw more cards.", cardType: .drawCards, value: 2, imageName: "rectangle.stack.fill"),
      Card(id: UUID(), name: "Silence", description: "Silence the enemy.", cardType: .silence, value: 1, imageName: "speaker.slash.fill"),
      Card(id: UUID(), name: "Poison", description: "Poison the enemy", cardType: .poison, value: 2, imageName: "drop.fill"),
       ]
    }
  
  func setupTutorialSteps() {
      tutorialSteps = [
          TutorialStep(instruction: "This is your hand. Select a card to use."),
          TutorialStep(instruction: "Tap on the enemies to attack."),
          TutorialStep(instruction: "This is your player area. Here you can see your health and buffs."),
          TutorialStep(instruction: "This is the card type tutorial. Each card type has a different effect."),
          TutorialStep(instruction: "Press End Turn to complete your turn."),
          TutorialStep(instruction: "Tutorial Completed!")
      ]
  }

  func nextTutorialStep() {
          withAnimation {
              if currentTutorialStep < tutorialSteps.count - 1 {
                  currentTutorialStep += 1
                  updateHighlights()
              } else {
                  // If the tutorial is complete, stop the tutorial and handle any end-of-tutorial logic
                  isTutorialActive = false
                  clearHighlights() // Make sure to clear any highlights
              }
          }
      }

      private func updateHighlights() {
          clearHighlights() // Clear previous highlights

          switch currentTutorialStep {
          case 0:
              highlightedCardIndex = 0 // Highlight the first card when selecting a card
          case 1:
              isEnemyZoneHighlighted = true // Highlight enemy zone when tapping enemies
          case 2:
              isPlayerZoneHighlighted = true // Highlight player zone when explaining it
          case 3:
              isPlayerHandHighlighted = true // Highlight the entire player hand
          case 4:
              isEndTurnHighlighted = true // Highlight the "End Turn" button
          default:
              break
          }
      }

      private func clearHighlights() {
          highlightedCardIndex = nil
          isEnemyZoneHighlighted = false
          isPlayerZoneHighlighted = false
          isEndTurnHighlighted = false
          isPlayerHandHighlighted = false // Clear player hand highlight
      }
}
