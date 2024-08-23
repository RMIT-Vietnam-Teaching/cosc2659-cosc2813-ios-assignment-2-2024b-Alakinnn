//
//  RewardSelectionOverlay.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 23/08/2024.
//

import SwiftUI

struct RewardSelectionOverlay: View {
    var vm: GameViewModel

    var body: some View {
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
    }
}


#Preview {
  RewardSelectionOverlay(vm: GameViewModel())
}
