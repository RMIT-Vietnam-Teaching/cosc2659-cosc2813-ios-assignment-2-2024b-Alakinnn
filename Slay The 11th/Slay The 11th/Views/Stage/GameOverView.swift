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
            Text("Game Over")
                .font(.kreonTitle)
                .padding()

            Button("Confirm") {
                onConfirm()
            }
            .font(.kreonTitle2)
            .padding()
            .background(Image("bigBtnBackground").resizable())
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)  // Add padding to prevent the button from touching the borders
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.3)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
        .onAppear {
          AudioManager.shared.queueSFX("gameOverSfx")
        }
    }
}

#Preview {
  GameOverView {
  
  }
}

