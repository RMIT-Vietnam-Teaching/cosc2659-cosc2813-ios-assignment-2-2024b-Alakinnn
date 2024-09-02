//
//  GameOverView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 23/08/2024.
//
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
            AudioManager.shared.playImmediateSFX("gameOverSfx")
        }
    }
}

#Preview {
    GameOverView {
        // Preview action
    }
}


