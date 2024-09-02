//
//  PauseOverlay.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 23/08/2024.
//

import SwiftUI

struct PauseOverlay: View {
    @Binding var isPaused: Bool

    var body: some View {
        if isPaused {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    Button(action: {
                        isPaused = false
                    }) {
                        Text(NSLocalizedString("unpause", comment: "Button to unpause the game"))
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.8))
                            .cornerRadius(10)
                    }
                )
        }
    }
}

#Preview {
    PauseOverlay(isPaused: .constant(true))
}

