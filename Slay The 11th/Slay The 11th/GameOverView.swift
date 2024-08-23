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
                .font(.largeTitle)
                .padding()

            Button("Confirm") {
                onConfirm()
            }
            .font(.title)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)  // Add padding to prevent the button from touching the borders
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.3)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding() // Add padding to the overall view
    }
}

#Preview {
  GameOverView {
  
  }
}

