//
//  TutorialViewOverlay.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 28/08/2024.
//

import SwiftUI

import SwiftUI

struct TutorialOverlayView: View {
    let step: TutorialStep
    let onNext: () -> Void
    let position: CGPoint

    var body: some View {
        VStack {
            Text(step.instruction)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
                .position(position)
                .transition(.opacity)
                .onTapGesture {
                    onNext()
                }
        }
    }
}

struct TutorialStep {
    let instruction: String
}

