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
    var vm: GameViewModel
    var index: Int // Pass the index instead of the enemy

    var body: some View {
        let enemy = vm.stageViewModel.enemies[index]

        ZStack {
            VStack(spacing: 0) {
                // Display effects above the enemy
                HStack {
                    ForEach(enemy.debuffEffects, id: \.self) { debuff in
                        VStack {
                            Text(debuff.type == .poison ? "☠️" : "🔇") // Example: Use emojis or custom icons
                            Text("\(debuff.value)x")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(4)
                    }
                }
                .padding(.vertical, 8)

                // Enemy image
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                    .offset(y: offsetValue)
                
                VStack {
                  Image(systemName: enemy.intendedAction == .attack ? "flame.fill" : enemy.intendedAction == .buff ? "arrow.up.circle.fill" : enemy.intendedAction == .cleanse ? "figure.mind.and.body" :
                          "speaker.slash.fill"
                  )

                }
                .background(Color.black.opacity(0.2))
                .cornerRadius(4)
              
                // HP Bar below the enemy
                Text("\(enemy.curHp)/\(enemy.maxHp)")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color.green)
                    .cornerRadius(4)
                    .padding(.top, 4)
            }
            .frame(width: width, height: height)
          
            Rectangle()
                .fill(Color.black.opacity(0.001))
                .frame(width: width * 0.8, height: height * 0.6)
                .border(Color.red, width: 2)
                .offset(y: offsetValue)
                .onTapGesture {
                    vm.stageViewModel.applyCard(at: index)
                }
        }
    }
}

#Preview {
    CharacterBody2D(offsetValue: 0, width: 100, height: 200, vm: GameViewModel(), index: 0)
}
