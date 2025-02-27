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

struct GameOverView: View {
    var onConfirm: () -> Void

    var body: some View {
        VStack {
            Text(NSLocalizedString("game_over", comment: "Game Over text"))
                .font(.kreonTitle)
                .padding()

            Button(action: {
                onConfirm()
                AudioManager.shared.stopBackgroundMusic()
                AudioManager.shared.playBackgroundMusic("mainMenu")
            }) {
                Text(NSLocalizedString("confirm", comment: "Confirm button text"))
                    .font(.kreonTitle2)
                    .padding()
                    .background(Image("bigBtnBackground").resizable())
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.3)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
        .onAppear {
            AudioManager.shared.clearSFXQueue()
            AudioManager.shared.playImmediateSFX("gameOverSfx")
        }
    }
}

#Preview {
    GameOverView {
        // Preview action
    }
}


