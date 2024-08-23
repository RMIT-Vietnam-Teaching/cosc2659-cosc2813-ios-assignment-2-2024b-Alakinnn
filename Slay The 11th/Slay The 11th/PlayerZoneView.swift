//
//  PlayerZoneView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 15/08/2024.
//

import SwiftUI

struct PlayerZoneView: View {
    var vm: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            let zoneWidth = geometry.size.width
            let zoneHeight = geometry.size.height

            ZStack {
                // Background
                Color.green.opacity(0.7)
                    .frame(width: zoneWidth, height: zoneHeight)

                HStack {
                  Spacer()
                    VStack(spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "shield.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.yellow)
                            
                          Text("\(vm.stageViewModel.player.tempHP)")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 10)

                        ZStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: zoneWidth * 0.2, height: zoneHeight * 0.4)
                                .foregroundColor(.blue)

                            Rectangle()
                                .fill(Color.black.opacity(0.001))
                                .frame(width: zoneWidth * 0.2, height: zoneHeight * 0.4)
                                .onTapGesture {
                                    if let card = vm.stageViewModel.selectedCard {
                                        switch card.cardType {
                                        case .defense:
                                            vm.stageViewModel.applyDefenseEffect(value: card.currentValue)
                                            vm.stageViewModel.moveCardToDiscardedDeck(card)
                                            vm.stageViewModel.selectedCard = nil
                                            
                                        case .drawCards:
                                            vm.stageViewModel.applyDrawEffect(value: card.baseValue)
                                            vm.stageViewModel.moveCardToDiscardedDeck(card)
                                            vm.stageViewModel.selectedCard = nil
                                            
                                        default:
                                            print("Card type \(card.cardType) is not applicable to the player directly.")
                                        }
                                    }
                                }
                        }

                      Text("\(vm.stageViewModel.player.curHP)/\(vm.stageViewModel.player.maxHP)")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.green)
                            .cornerRadius(4)
                    }
                    .padding(.leading, 32)
                  
                    Button(action: {
                      vm.stageViewModel.endPlayerTurn()
                    }) {
                        Text("End Turn")
                            .font(.headline)
                            .padding()
                            .background(Color.red)
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
    PlayerZoneView(vm: GameViewModel())
}


