  //
  //  MainGameView.swift
  //  Slay The 11th
  //
  //  Created by Duong Tran Minh Hoang on 10/08/2024.
  //

import SwiftUI
import NavigationTransitions
import Pow

struct StageView: View {
  var gameVm: GameViewModel
  var db: DatabaseManager
  var toastManager = ToastManager.shared
    @State private var blackoutOpacity: Double = 0.0
    @State private var showGameOverView: Bool = false
    @State private var isPaused: Bool = false
    @State private var showMenuSheet: Bool = false
    @State private var showSpotlight: Bool = true
    @State private var currentSpot: Int = 0

    var body: some View {
        ZStack {
            // Game content view
            StageContentView(vm: gameVm.stageViewModel, gameVm: gameVm)

            // Header view, if the game is not over
            if !gameVm.stageViewModel.isGameOver {
              StageHeaderView(vm: gameVm.stageViewModel, gameVm: gameVm, isPaused: $isPaused, showMenuSheet: $showMenuSheet, db:db)
            }

            // Pause overlay
            PauseOverlay(isPaused: $isPaused)

            // Handle game over directly in the StageView
            if gameVm.stageViewModel.isGameOver {
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
                        gameVm.stageViewModel.isGameOver = false
                      gameVm.isGameStarted = false
                    })
                    .background(Color.black.opacity(0.8))
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity.combined(with: .scale))
                    .navigationTransition(.fade(.out))
                }
            }
          
          // Add this section for the toast
          if toastManager.showToast, let message = toastManager.toastMessage {
              ToastView(message: message)
                  .transition(.move(edge: .top).combined(with: .opacity))
                  .onAppear {
                      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                          withAnimation {
                              toastManager.showToast = false
                              toastManager.toastMessage = nil
                          }
                      }
                  }
          }
        }
        .statusBarHidden()
        .navigationBarHidden(true)
    }
}



  
  #Preview {
    StageView( gameVm: GameViewModel(), db: MockDataManager())
  }


