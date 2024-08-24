//
//  PlayerHandView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct PlayerHandView: View {
    var vm: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                      ForEach(vm.stageViewModel.playerHand.indices, id: \.self) { index in
                            CardView(card: vm.stageViewModel.playerHand[index])
                          .shadow(
                            color: vm.stageViewModel.selectedCard?.id == vm.stageViewModel.playerHand[index].id ? Color.gray.opacity(0.4) : Color.clear,
                              radius: vm.stageViewModel.selectedCard?.id == vm.stageViewModel.playerHand[index].id ? 8 : 0
                          )
                          .onTapGesture {
                              vm.stageViewModel.selectedCard = vm.stageViewModel.playerHand[index]
                          }
                    }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(8, for: .scrollContent)
                .scrollTargetBehavior(.paging)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
              Image("handBackground")
                .resizable()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .aspectRatio(contentMode: .fill)
                .clipped()
            )
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -5)
        }
    }
}

#Preview {
    PlayerHandView(vm: GameViewModel())
}
