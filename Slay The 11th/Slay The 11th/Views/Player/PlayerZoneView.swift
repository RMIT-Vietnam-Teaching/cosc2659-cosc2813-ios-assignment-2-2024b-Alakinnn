//
//  PlayerZoneView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 15/08/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlayerZoneView: View {
    var vm: StageViewModel
  @State var isAnimating: Bool = true
    var body: some View {
        GeometryReader { geometry in
            let zoneWidth = geometry.size.width
            let zoneHeight = geometry.size.height

            ZStack {

                HStack {
                  Spacer()
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "shield.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.yellow)
                            
                          Text("\(vm.player.tempHP)")
                            .font(.kreonBody)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 10)

                        ZStack {
                          AnimatedImage(name: vm.player.playerState == .idle ? "Player-Idle.gif" : "Player-Damage.gif", isAnimating: $isAnimating)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: zoneWidth * 0.25, height: zoneHeight * 0.4)


                            Rectangle()
                                .fill(Color.black.opacity(0.001))
                                .frame(width: zoneWidth * 0.2, height: zoneHeight * 0.4)
                                .onTapGesture {
                                    if let card = vm.selectedCard {
                                        switch card.cardType {
                                        case .defense:
                                            vm.applyDefenseEffect(value: card.currentValue)
                                            vm.moveCardToDiscardedDeck(card)
                                            vm.selectedCard = nil
                                            
                                        case .drawCards:
                                            vm.applyDrawEffect(value: card.baseValue)
                                            vm.moveCardToDiscardedDeck(card)
                                            vm.selectedCard = nil
                                            
                                        default:
                                            print("Card type \(card.cardType) is not applicable to the player directly.")
                                        }
                                    }
                                }
                        }

                      Text("\(vm.player.curHP)/\(vm.player.maxHP)")
                        .font(.kreonBody)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.green)
                            .cornerRadius(4)
                    }
                    .padding(.leading, 32)
                  
                    Button(action: {
                      vm.endPlayerTurn()
                      AudioManager.shared.queueSFX("sfxButton")
                    }) {
                        Text("End Turn")
                        .font(.kreonBody)
                            .padding(24)
                            .background(Image("bigBtnBackground").resizable())
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                  Spacer()
                }
                .padding(.horizontal, 16)
            }
            .frame(width: zoneWidth, height: zoneHeight)
        }
    }
}

#Preview {
    PlayerZoneView(vm: StageViewModel(difficulty: .medium, player: Player(hp: 44), mode: .regular))
}


