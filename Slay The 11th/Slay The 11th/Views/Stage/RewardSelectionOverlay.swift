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
import NavigationTransitions
struct RewardSelectionOverlay: View {
    var vm: GameViewModel
  var db: DatabaseManager = DatabaseManager.shared
  @State private var blackoutOpacity: Double = 0.0

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
                      vm.stageViewModel.reshuffleAllCardsIntoAvailableDeckAfterStageEnds()
                    RewardSystem.applyReward(reward, gameVm: vm, db: db, to: vm.stageViewModel.player, in: vm.stageViewModel)
                    vm.stageViewModel.isShowingRewards = false
                        
                    if vm.stageViewModel.currentStage == 11 {
                          // First, handle the animation for blackout or any other UI effects
                          withAnimation(.easeInOut(duration: 1.3)) {
                              blackoutOpacity = 1
                          }

                          // Delay setting allStagesCleared to ensure smooth transition
                          DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            vm.stageViewModel.allStagesCleared = true
                          }
                        } else {
                          vm.stageViewModel.checkAndAdvanceStage()
                          if (vm.stageViewModel.currentStage == 7) {
                            vm.checkAndUnlockAchievements(db: db, action: .reachStageSeven)
                          }
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
  RewardSelectionOverlay(vm: GameViewModel())
}
