//
//  StageContentView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 23/08/2024.
//

import SwiftUI
import NavigationTransitions
struct StageContentView: View {
    @Bindable var vm: StageViewModel
  var gameVm: GameViewModel

    var body: some View {
        VStack(spacing: 0) {
            EnemyZoneView(vm: vm)
                .frame(height: UIScreen.main.bounds.height * 0.4)

            PlayerZoneView(vm: vm)
                .frame(height: UIScreen.main.bounds.height * 0.2)

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
