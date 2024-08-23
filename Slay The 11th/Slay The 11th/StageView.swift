  //
  //  MainGameView.swift
  //  Slay The 11th
  //
  //  Created by Duong Tran Minh Hoang on 10/08/2024.
  //

import SwiftUI
import NavigationTransitions

struct StageView: View {
    var vm: GameViewModel
    @Binding var isGameStarted: Bool
    @State private var blackoutOpacity: Double = 0.0
    @State private var showGameOverView: Bool = false
    @State private var isPaused: Bool = false

    var body: some View {
      ZStack {
        VStack(spacing: 0) {
            EnemyZoneView(vm: vm)
                .frame(height: UIScreen.main.bounds.height * 0.4)
            
            PlayerZoneView(vm: vm)
                .frame(height: UIScreen.main.bounds.height * 0.25)
            
            PlayerHandView(vm: vm)
                .frame(height: UIScreen.main.bounds.height * 0.35)
        }
        .edgesIgnoringSafeArea(.all)
        .overlay(
            Group {
                if vm.stageViewModel.isShowingRewards {
                    RewardSelectionView(
                        rewards: RewardSystem.rewardsForStage(vm.stageViewModel.currentStage),
                        selectedReward: Binding(
                            get: { vm.stageViewModel.selectedReward },
                            set: { vm.stageViewModel.selectedReward = $0 }
                        ),
                        onConfirm: {
                            if let reward = vm.stageViewModel.selectedReward {
                              vm.stageViewModel.reshuffleAllCardsIntoAvailableDeckAfterTurnEnds()
                                RewardSystem.applyReward(reward, to: vm.stageViewModel.player, in: vm.stageViewModel)
                                vm.stageViewModel.isShowingRewards = false
                                vm.stageViewModel.checkAndAdvanceStage()
                            }
                        }
                    )
                    .background(Color.black.opacity(0.8))
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                }
                if vm.stageViewModel.isGameOver {
                    Color.black
                        .opacity(blackoutOpacity)
                        .edgesIgnoringSafeArea(.all)
                        .onAppear {
                          withAnimation(.easeInOut(duration: 1.2)) {
                                blackoutOpacity = 1.0
                            }
                            // Delay the appearance of the GameOverView until after the blackout
                          DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                    showGameOverView = true
                                }
                            }
                        }

                    if showGameOverView {
                        GameOverView(onConfirm: {
                            vm.stageViewModel.isGameOver = false
                            isGameStarted = false // Navigate back to the main menu
                        })
                        .background(Color.black.opacity(0.8))
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity.combined(with: .scale))
                        .navigationTransition(.fade(.out))
                    }
                }
            }
        )
        .navigationBarHidden(true)
          
        // Header for stage number and pause menu
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    // Your pause logic here
                    isPaused = true
                }) {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                }
                .frame(width: 35, height: 35) // Ensure the frame is square

                Spacer()

                Text("Stage \(vm.stageViewModel.currentStage)")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 6)
            .frame(height: 60)
            .background(Color.black.opacity(0.7))

            Spacer()
        }
        .edgesIgnoringSafeArea(.top)


        // Pause overlay
        if isPaused {
          Color.black.opacity(0.7)
              .edgesIgnoringSafeArea(.all)
              .overlay(
                  Button("Unpause") {
                      isPaused = false
                  }
                  .font(.title)
                  .foregroundColor(.white)
                  .padding()
                  .background(Color.gray.opacity(0.8))
                  .cornerRadius(10)
              )
        }
      }
  }
}


  
  #Preview {
    StageView(vm: GameViewModel(), isGameStarted: .constant(true))
  }


