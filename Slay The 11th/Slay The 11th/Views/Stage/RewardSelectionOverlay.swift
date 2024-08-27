//
//  RewardSelectionOverlay.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 23/08/2024.
//

import SwiftUI

struct RewardSelectionOverlay: View {
    var vm: StageViewModel

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
                        vm.checkAndAdvanceStage()
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
  RewardSelectionOverlay(vm: StageViewModel(difficulty: .medium, player: Player(hp: 44)))
}
