//
//  EnemyBody2D.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 10/08/2024.
//

import SwiftUI

struct CharacterBody2D: View {
    let offsetValue: CGFloat
    let width: CGFloat
    let height: CGFloat
    var vm: StageViewModel
    var index: Int

    var body: some View {
        // Safely unwrap the enemy to avoid out-of-bounds access
        if index < vm.enemies.count {
            let enemy = vm.enemies[index]

            GeometryReader { geometry in
                let screenSize = geometry.size
                let dynamicPadding: CGFloat = screenSize.width > 600 ? 12 : 6 // Adjust padding based on screen width

                ZStack {
                    ZStack {
                        // Enemy image, intention, and HP bar
                        VStack(spacing: 16) {
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width, height: height)
                                .offset(y: offsetValue)

                            Image(systemName: enemy.intendedAction == .attack ? "flame.fill" :
                                   enemy.intendedAction == .buff ? "arrow.up.circle.fill" :
                                   enemy.intendedAction == .cleanse ? "figure.mind.and.body" :
                                   "speaker.slash.fill"
                            )
                            .font(.title)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(4)
                            .padding(4)

                            Text("\(enemy.curHp)/\(enemy.maxHp)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(4)
                                .background(Color.green)
                                .cornerRadius(4)
                        }
                        .frame(width: width, height: height)
                        .position(x: screenSize.width / 2, y: screenSize.height / 2)
                        .clipped()
                        .padding(.top, 48)

                        HStack(spacing: 2) {
                            ForEach(enemy.debuffEffects, id: \.self) { debuff in
                                VStack {
                                    Text(debuff.type == .poison ? "☠️" : "🔇")
                                    Text("\(debuff.duration)x")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                .padding(4)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(4)
                            }
                        }
                        .position(x: screenSize.width / 2, y: screenSize.height / 2 - height / 2 - 20)
                    }

                    Rectangle()
                        .fill(Color.black.opacity(0.001))
                        .frame(width: width, height: height)
                        .offset(y: offsetValue)
                        .onTapGesture {
                            vm.applyCard(at: index)
                          if vm.isTutorialActive && vm.currentTutorialStep == 1 {
                            vm.nextTutorialStep()
                          }
                        }
                }
            }
        } else {
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.gray)
                .frame(width: width, height: height)
        }
    }
}

#Preview {
    CharacterBody2D(offsetValue: 0, width: 100, height: 200, vm: StageViewModel(difficulty: .medium, player: Player(hp: 44)), index: 0)
}
