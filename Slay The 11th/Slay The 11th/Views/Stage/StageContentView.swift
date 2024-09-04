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
struct StageContentView: View {
  @Bindable var vm: StageViewModel
  var gameVm: GameViewModel

    var body: some View {
        VStack(spacing: 0) {
          VStack(spacing: 0) {
            EnemyZoneView(vm: vm)
              .frame(height: UIScreen.main.bounds.height * 0.4)
            PlayerZoneView(vm: vm)
                .frame(height: UIScreen.main.bounds.height * 0.25)
          }
          .background(
          Image("stageBackground")
            .resizable()
            .scaledToFill()
            .blur(radius: 5)
            .frame(height: UIScreen.main.bounds.height * 0.7))
            
            PlayerHandView(vm: vm)
                .frame(height: UIScreen.main.bounds.height * 0.4)
        }
        .navigationDestination(isPresented: $vm.isShowingRewards) {
            RewardSelectionOverlay(vm: gameVm)
        }
        .navigationTransition(.fade(.cross))
    }
}


#Preview {
    StageContentView(vm: StageViewModel(difficulty: .medium, player: Player(hp: 44), mode: .regular), gameVm: GameViewModel())
}
