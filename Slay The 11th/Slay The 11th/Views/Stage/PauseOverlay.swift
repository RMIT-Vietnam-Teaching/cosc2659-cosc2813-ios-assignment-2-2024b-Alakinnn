/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 23/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

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

