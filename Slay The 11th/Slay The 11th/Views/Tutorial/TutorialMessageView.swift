//
//  TutorialMessageView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 30/08/2024.
//

import SwiftUI

struct TutorialMessageView: View {
    var step: TutorialStep // Current step of the tutorial

    var body: some View {
        VStack {
            Text(tutorialMessage(for: step))
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .background(
                    Color.black.opacity(0.8)
                        .cornerRadius(10)
                        .padding()
                )
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }

    // Method to return the appropriate message for each tutorial step
    func tutorialMessage(for step: TutorialStep) -> String {
        switch step {
        case .introduction:
            return "Welcome to the tutorial! Follow these steps to learn the basics."
        case .highlightHand:
            return "This is your hand. Here are the cards you can play."
        case .explainCardTypes:
            return "Each card has a unique effect. Learn how to use them to your advantage."
        case .selectCard:
            return "Tap on a card to select it. You can swipe to see more cards."
        case .highlightEnemyZone:
            return "These are your enemies. Your goal is to defeat them!"
        case .explainEnemyDetails:
            return "Pay attention to the enemies' health and status effects."
        case .applyCard:
            return "Select an enemy to apply your card's effect."
        case .complete:
            return "Tutorial complete! You're ready to start playing."
        }
    }
}
