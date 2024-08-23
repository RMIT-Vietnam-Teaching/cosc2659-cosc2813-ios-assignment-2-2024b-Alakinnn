//
//  GameOverOverlay.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 23/08/2024.
//

import SwiftUI

struct GameOverOverlay: View {
    @Binding var blackoutOpacity: Double
    @Binding var showGameOverView: Bool
    @Binding var isGameStarted: Bool
    var vm: GameViewModel

    var body: some View {
        if vm.stageViewModel.isGameOver {
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
                    vm.stageViewModel.isGameOver = false
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
