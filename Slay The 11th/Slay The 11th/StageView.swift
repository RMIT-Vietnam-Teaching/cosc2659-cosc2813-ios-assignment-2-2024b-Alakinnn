  //
  //  MainGameView.swift
  //  Slay The 11th
  //
  //  Created by Duong Tran Minh Hoang on 10/08/2024.
  //

  import SwiftUI

struct StageView: View {
    var vm: GameViewModel
    @Binding var isGameStarted: Bool
    @State private var blackoutOpacity: Double = 0.0
    @State private var showGameOverView: Bool = false

    var body: some View {
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
                            withAnimation(.easeInOut(duration: 2.0)) {
                                blackoutOpacity = 1.0
                            }
                            // Delay the appearance of the GameOverView until after the blackout
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                showGameOverView = true
                            }
                        }

                    if showGameOverView {
                        GameOverView(onConfirm: {
                            vm.stageViewModel.isGameOver = false
                            isGameStarted = false // Navigate back to the main menu
                        })
                        .background(Color.black.opacity(0.8))
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                    }
                }
            }
        )
        .navigationBarHidden(true)
    }
}



  
  #Preview {
    StageView(vm: GameViewModel(), isGameStarted: .constant(true))
  }


