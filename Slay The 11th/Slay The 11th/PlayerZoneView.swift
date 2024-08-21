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
                    // Player shield, icon, and HP on the left
                    VStack(spacing: 10) {
                        // Display shield icons above the player
                        HStack(spacing: 8) {
                            Image(systemName: "shield.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.yellow)
                            
                            Text("\(vm.player.tempHP)")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 10)

                        // Player image with tap detection
                        ZStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: zoneWidth * 0.2, height: zoneHeight * 0.4)
                                .foregroundColor(.blue)

                            Rectangle()
                                .fill(Color.black.opacity(0.001)) // Invisible but tappable area
                                .frame(width: zoneWidth * 0.2, height: zoneHeight * 0.4) // Match the player image size
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

                        // HP Bar below the player
                        Text("\(vm.player.curHP)/\(vm.player.maxHP)")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.green)
                            .cornerRadius(4)
                    }
                    .padding(.leading, 32)
                    Spacer() // Push the button to the right

                    // "End Turn" button on the right
                    Button(action: {
                      vm.stageViewModel.endPlayerTurn() // Call the function to end the player's turn
                    }) {
                        Text("End Turn")
                            .font(.headline)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 16) // Add some padding to the sides
            }
            .frame(width: zoneWidth, height: zoneHeight)
        }
    }
}

#Preview {
    PlayerZoneView(vm: GameViewModel())
}


