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
import SDWebImageSwiftUI
struct CharacterBody2D: View {
    let offsetValue: CGFloat
    let width: CGFloat
    let height: CGFloat
    var vm: StageViewModel
    var index: Int
  @State var isAnimating: Bool = true

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
                          AnimatedImage(name: enemy.enemyState == .takingDamage ? enemy.enemyImages[1] : enemy.enemyImages[0], isAnimating: $isAnimating)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .offset(y: offsetValue)

                            Image(systemName: enemy.intendedAction == .attack ? "flame.fill" :
                                   enemy.intendedAction == .buff ? "arrow.up.circle.fill" :
                                   enemy.intendedAction == .cleanse ? "figure.mind.and.body" :
                                   "speaker.slash.fill"
                            )
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(4)
                            .padding(4)

                            Text("\(enemy.curHp)/\(enemy.maxHp)")
                            .font(.kreonSubheadline)
                                .foregroundColor(.white)
                                .padding(4)
                                .background(Color.green)
                                .cornerRadius(4)
                        }
                        .frame(width: width, height: height)
                        .position(x: screenSize.width / 2, y: screenSize.height / 2)
                        .clipped()
                        .padding(.top, 48)

                        // Display effects above the enemy without affecting layout
                        HStack(spacing: 2) {
                            ForEach(enemy.debuffEffects, id: \.self) { debuff in
                                VStack {
                                    Text(debuff.type == .poison ? "☠️" : "🔇")
                                    Text("\(debuff.duration)x")
                                        .font(.kreonSubheadline)
                                        .foregroundColor(.white)
                                }
                                .padding(4)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(4)
                            }
                        }
                        .position(x: screenSize.width / 2, y: screenSize.height / 2 - height / 2 - 20) // Adjust position above the enemy image
                    }

                    Rectangle()
                        .fill(Color.black.opacity(0.001))
                        .frame(width: width, height: height)
                        .offset(y: offsetValue)
                        .onTapGesture {
                            vm.applyCard(at: index)
                        }
                }
            }
        } else {
            // Placeholder or loading view if the index is out of bounds
            Text("Loading...")
                .font(.kreonHeadline)
                .foregroundColor(.gray)
                .frame(width: width, height: height)
        }
    }
}

#Preview {
    CharacterBody2D(offsetValue: 0, width: 100, height: 200, vm: StageViewModel(difficulty: .medium, player: Player(hp: 44), mode: .regular), index: 0)
}
