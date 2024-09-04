/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 10/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

import SwiftUI

struct PlayerHandView: View {
    var vm: StageViewModel

    @State private var appearedCards: [Bool] = []

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(vm.playerHand.indices, id: \.self) { index in
                            let card = vm.playerHand[index]
                            let isSelected = vm.selectedCard?.id == card.id
                          let hasAppeared = appearedCards.contains((index != 0))
                            
                            CardView(card: card)
                                .shadow(
                                    color: isSelected ? Color.gray.opacity(0.4) : Color.clear,
                                    radius: isSelected ? 8 : 0
                                )
                                .opacity(hasAppeared ? 1 : 0)
                                .scaleEffect(hasAppeared ? 1 : 0.5)
                                .animation(.easeInOut(duration: 0.5), value: appearedCards)
                                .onTapGesture {
                                    vm.selectedCard = card
                                }
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                                        withAnimation {
                                            if !appearedCards.contains((index != 0)) {
                                                appearedCards.append((index != 0))
                                            }
                                        }
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
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -5)
        }
        .onAppear {
            appearedCards = []
        }
        .onChange(of: vm.playerHand) { _ in
            appearedCards = []
            withAnimation {
                for index in vm.playerHand.indices {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                      if !appearedCards.contains((index != 0)) {
                        appearedCards.append((index != 0))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PlayerHandView(vm: StageViewModel(difficulty: .medium, player: Player(hp: 44), mode: .regular))
}
