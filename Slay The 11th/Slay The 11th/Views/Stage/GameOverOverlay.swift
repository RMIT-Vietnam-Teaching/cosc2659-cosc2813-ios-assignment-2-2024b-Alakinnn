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

struct GameOverOverlay: View {
    @Binding var blackoutOpacity: Double
    @Binding var showGameOverView: Bool
    @Binding var isGameStarted: Bool
    var vm: StageViewModel

    var body: some View {
        if vm.isGameOver {
            Color.black
                .opacity(blackoutOpacity)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        blackoutOpacity = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            showGameOverView = true
                        }
                    }
                }

            if showGameOverView {
                GameOverView(onConfirm: {
                    vm.isGameOver = false
                    isGameStarted = false
                })
                .background(Color.black.opacity(0.8))
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity.combined(with: .scale))
                .navigationTransition(.fade(.out))
            }
        }
    }
}
