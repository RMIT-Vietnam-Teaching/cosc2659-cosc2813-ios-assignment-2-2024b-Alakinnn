//
//  PlayerHandView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct PlayerHandView: View {
    var vm: StageViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(vm.playerHand.indices, id: \.self) { index in
                            CardView(card: vm.playerHand[index])
                                .shadow(
                                    color: vm.selectedCard?.id == vm.playerHand[index].id ? Color.gray.opacity(0.4) : Color.clear,
                                    radius: vm.selectedCard?.id == vm.playerHand[index].id ? 8 : 0
                                )
                                .onTapGesture {
                                    if vm.isTutorialActive && vm.currentTutorialStep == 0 {
                                        vm.selectedCard = vm.playerHand[index]
                                        vm.nextTutorialStep()
                                    } else if !vm.isTutorialActive {
                                        vm.selectedCard = vm.playerHand[index]
                                    }
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
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(vm.isPlayerHandHighlighted ? Color.yellow : Color.clear, lineWidth: 4)
                    .animation(.easeInOut, value: vm.isPlayerHandHighlighted)
            )
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -5)
        }
    }
}

#Preview {
    PlayerHandView(vm: StageViewModel(difficulty: .medium, player: Player(hp: 44)))
}

