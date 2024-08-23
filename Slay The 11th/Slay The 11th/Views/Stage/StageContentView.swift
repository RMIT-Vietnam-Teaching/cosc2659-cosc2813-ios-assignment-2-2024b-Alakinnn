//
//  StageContentView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 23/08/2024.
//

import SwiftUI

struct StageContentView: View {
    var vm: GameViewModel

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
            RewardSelectionOverlay(vm: vm)
        )
    }
}


#Preview {
    StageContentView(vm: GameViewModel())
}
