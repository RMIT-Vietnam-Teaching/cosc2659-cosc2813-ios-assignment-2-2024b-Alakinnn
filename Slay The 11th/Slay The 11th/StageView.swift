//
//  MainGameView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct StageView: View {
    var vm = GameViewModel()

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
            }
        )
        .onChange(of: vm.stageViewModel.isStageCompleted) {
            if vm.stageViewModel.isStageCompleted {
                vm.stageViewModel.isShowingRewards = true
            }
        }
    }
}

#Preview {
  StageView()
}


