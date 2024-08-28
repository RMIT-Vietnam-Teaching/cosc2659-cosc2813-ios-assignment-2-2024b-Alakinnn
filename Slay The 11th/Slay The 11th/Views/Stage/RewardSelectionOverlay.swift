//
//  RewardSelectionOverlay.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 23/08/2024.
//

import SwiftUI
import NavigationTransitions
struct RewardSelectionOverlay: View {
    var vm: StageViewModel
  @State private var blackoutOpacity: Double = 0.0

    var body: some View {
        if vm.isShowingRewards {
            RewardSelectionView(
                rewards: RewardSystem.rewardsForStage(vm.currentStage),
                selectedReward: Binding(
                    get: { vm.selectedReward },
                    set: { vm.selectedReward = $0 }
                ),
                onConfirm: {
                    if let reward = vm.selectedReward {
                        vm.reshuffleAllCardsIntoAvailableDeckAfterTurnEnds()
                        RewardSystem.applyReward(reward, to: vm.player, in: vm)
                        vm.isShowingRewards = false
                        
                        if vm.currentStage == 11 {
                          // First, handle the animation for blackout or any other UI effects
                          withAnimation(.easeInOut(duration: 1.3)) {
                              blackoutOpacity = 1
                          }

                          // Delay setting allStagesCleared to ensure smooth transition
                          DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                              vm.allStagesCleared = true
                          }
                        } else {
                            vm.checkAndAdvanceStage()
                        }
                    }
                }
            )
            .background(Color.black.opacity(0.8))
            .edgesIgnoringSafeArea(.all)
            .transition(.opacity)
            .navigationTransition(.fade(.out))

        }
    }
}




#Preview {
  RewardSelectionOverlay(vm: StageViewModel(difficulty: .medium, player: Player(hp: 44)))
}
