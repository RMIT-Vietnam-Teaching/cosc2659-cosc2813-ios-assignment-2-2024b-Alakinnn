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
    var index: Int

    var body: some View {
        let enemy = vm.stageViewModel.enemies[index]

        GeometryReader { geometry in
            let screenSize = geometry.size
            let dynamicPadding: CGFloat = screenSize.width > 600 ? 12 : 6 // Adjust padding based on screen width

          ZStack {
            VStack(spacing: dynamicPadding) {
                  // Display effects above the enemy
                  HStack {
                      ForEach(enemy.debuffEffects, id: \.self) { debuff in
                          VStack {
                              Text(debuff.type == .poison ? "☠️" : "🔇")
                              Text("\(debuff.value)x")
                                  .font(.caption)
                                  .foregroundColor(.white)
                          }
                          .background(Color.black.opacity(0.7))
                          .cornerRadius(4)
                      }
                  }
                  .padding(.top, dynamicPadding)

            
                  // Enemy image (default system image)
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
                .padding(.vertical, dynamicPadding)

                  Text("\(enemy.curHp)/\(enemy.maxHp)")
                      .font(.caption)
                      .foregroundColor(.white)
                      .padding(4)
                      .background(Color.green)
                      .cornerRadius(4)
              }
              .frame(width: width, height: height) // Set fixed width and height
              .position(x: screenSize.width / 2, y: screenSize.height / 2) // Center the view
            .clipped()
            
            Rectangle()
              .fill(Color.black.opacity(0.001))
              .
                .frame(width: width, height: height)
                .offset(y: offsetValue)
                .onTapGesture {
                    vm.stageViewModel.applyCard(at: index)
                }
          }
          
            
        }
    }
}

#Preview {
    CharacterBody2D(offsetValue: 0, width: 100, height: 200, vm: GameViewModel(), index: 0)
}
